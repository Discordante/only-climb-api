package app.onlyclimb.api.infrastructure.adapter.out.persistence.workoutlog;

import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.model.WorkoutLogEntry;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsQuery;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
class WorkoutLogJpaAdapter implements WorkoutLogRepository {

    private final SpringDataWorkoutLogRepository logRepo;
    private final SpringDataWorkoutLogEntryRepository entryRepo;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public WorkoutLog save(WorkoutLog log) {
        WorkoutLogJpaEntity entity = logRepo.findByUuid(log.getId())
                .orElseGet(WorkoutLogJpaEntity::new);
        if (entity.getId() == null) {
            entity.setUuid(log.getId());
            entity.setCreatedAt(log.getCreatedAt());
            entity.setUserId(resolveUserId(log.getOwnerId()));
        }
        entity.setUpdatedAt(log.getUpdatedAt());
        entity.setWorkoutTemplateId(log.getWorkoutTemplateId()
                .map(this::resolveTemplateIdOrNull).orElse(null));
        entity.setPerformedAt(log.getPerformedAt());
        entity.setDurationMinutes(log.getDurationMinutes().orElse(null));
        entity.setPerceivedEffort(log.getPerceivedEffort().orElse(null));
        entity.setNotes(log.getNotes().orElse(null));

        WorkoutLogJpaEntity persisted = logRepo.save(entity);
        replaceEntries(persisted.getId(), log.getEntries());
        return toDomain(persisted);
    }

    @Override
    public Optional<WorkoutLog> findById(UUID id) {
        return logRepo.findByUuid(id).map(this::toDomain);
    }

    @Override
    public void deleteById(UUID id) {
        logRepo.findByUuid(id).ifPresent(entity -> {
            entryRepo.deleteByLogId(entity.getId());
            logRepo.delete(entity);
        });
    }

    @Override
    public Page<WorkoutLog> search(ListWorkoutLogsQuery query) {
        Long ownerLongId = resolveUserIdOrNull(query.ownerId());
        if (ownerLongId == null) {
            return new Page<>(List.of(), null);
        }

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<WorkoutLogJpaEntity> cq = cb.createQuery(WorkoutLogJpaEntity.class);
        Root<WorkoutLogJpaEntity> root = cq.from(WorkoutLogJpaEntity.class);

        List<Predicate> predicates = new ArrayList<>();
        predicates.add(cb.equal(root.get("userId"), ownerLongId));

        if (query.workoutTemplateId() != null) {
            Long tplId = resolveTemplateIdOrNull(query.workoutTemplateId());
            if (tplId == null) {
                return new Page<>(List.of(), null);
            }
            predicates.add(cb.equal(root.get("workoutTemplateId"), tplId));
        }
        if (query.from() != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("performedAt"), query.from()));
        }
        if (query.to() != null) {
            predicates.add(cb.lessThan(root.get("performedAt"), query.to()));
        }

        Cursor decoded = decodeCursor(query.cursor());
        if (decoded != null) {
            predicates.add(cb.or(
                    cb.lessThan(root.<Instant>get("performedAt"), decoded.performedAt),
                    cb.and(
                            cb.equal(root.get("performedAt"), decoded.performedAt),
                            cb.lessThan(root.get("id"), decoded.id))));
        }

        cq.where(predicates.toArray(new Predicate[0]));
        cq.orderBy(cb.desc(root.get("performedAt")), cb.desc(root.get("id")));

        List<WorkoutLogJpaEntity> rows = entityManager.createQuery(cq)
                .setMaxResults(query.limit() + 1)
                .getResultList();

        String nextCursor = null;
        if (rows.size() > query.limit()) {
            WorkoutLogJpaEntity last = rows.get(query.limit() - 1);
            nextCursor = encodeCursor(last.getPerformedAt(), last.getId());
            rows = rows.subList(0, query.limit());
        }
        List<WorkoutLog> domain = rows.stream().map(this::toDomain).toList();
        return new Page<>(domain, nextCursor);
    }

    // ---------------------------------------------------------------------
    // Mapping
    // ---------------------------------------------------------------------

    private WorkoutLog toDomain(WorkoutLogJpaEntity entity) {
        List<WorkoutLogEntryJpaEntity> rows = entryRepo.findByLogIdOrderByPosition(entity.getId());
        List<WorkoutLogEntry> entries = new ArrayList<>(rows.size());
        for (WorkoutLogEntryJpaEntity row : rows) {
            entries.add(new WorkoutLogEntry(
                    row.getPosition(),
                    resolveExerciseUuid(row.getExerciseId()),
                    row.getStatus(),
                    mapConfig(row.getPlannedConfig()),
                    mapConfig(row.getActualConfig()),
                    row.getNotes()));
        }
        return new WorkoutLog(
                entity.getUuid(),
                resolveUserUuid(entity.getUserId()),
                Optional.ofNullable(entity.getWorkoutTemplateId())
                        .map(this::resolveTemplateUuid).orElse(null),
                entity.getPerformedAt(),
                entity.getDurationMinutes(),
                entity.getPerceivedEffort(),
                entity.getNotes(),
                entries,
                entity.getCreatedAt(),
                entity.getUpdatedAt());
    }

    private static Map<ParameterType, String> mapConfig(Map<String, String> raw) {
        if (raw == null || raw.isEmpty()) return Map.of();
        Map<ParameterType, String> result = new LinkedHashMap<>();
        for (Map.Entry<String, String> e : raw.entrySet()) {
            try {
                result.put(ParameterType.valueOf(e.getKey()), e.getValue());
            } catch (IllegalArgumentException ignored) {
                // Unknown legacy parameter — skip on read.
            }
        }
        return result;
    }

    private void replaceEntries(Long logId, List<WorkoutLogEntry> entries) {
        entryRepo.deleteByLogId(logId);
        entryRepo.flush();
        for (WorkoutLogEntry entry : entries) {
            WorkoutLogEntryJpaEntity row = new WorkoutLogEntryJpaEntity();
            row.setUuid(UUID.randomUUID());
            row.setLogId(logId);
            row.setExerciseId(resolveExerciseId(entry.getExerciseId()));
            row.setPosition(entry.getPosition());
            row.setStatus(entry.getStatus() == null ? WorkoutLogEntryStatus.COMPLETED : entry.getStatus());
            row.setPlannedConfig(toRawConfig(entry.getPlannedConfig()));
            row.setActualConfig(toRawConfig(entry.getActualConfig()));
            row.setNotes(entry.getNotes());
            entryRepo.save(row);
        }
    }

    private static Map<String, String> toRawConfig(Map<ParameterType, String> config) {
        Map<String, String> raw = new LinkedHashMap<>();
        if (config != null) {
            config.forEach((k, v) -> raw.put(k.name(), v));
        }
        return raw;
    }

    // ---------------------------------------------------------------------
    // UUID <-> id translation
    // ---------------------------------------------------------------------

    private Long resolveUserId(UUID userUuid) {
        Object id = entityManager.createNativeQuery("SELECT id FROM users WHERE uuid = :uuid")
                .setParameter("uuid", userUuid)
                .getSingleResult();
        return ((Number) id).longValue();
    }

    private Long resolveUserIdOrNull(UUID userUuid) {
        try {
            return resolveUserId(userUuid);
        } catch (NoResultException e) {
            return null;
        }
    }

    private UUID resolveUserUuid(Long userId) {
        return (UUID) entityManager.createNativeQuery("SELECT uuid FROM users WHERE id = :id")
                .setParameter("id", userId)
                .getSingleResult();
    }

    private Long resolveExerciseId(UUID exerciseUuid) {
        Object id = entityManager.createNativeQuery("SELECT id FROM exercises WHERE uuid = :uuid")
                .setParameter("uuid", exerciseUuid)
                .getSingleResult();
        return ((Number) id).longValue();
    }

    private UUID resolveExerciseUuid(Long exerciseId) {
        return (UUID) entityManager.createNativeQuery("SELECT uuid FROM exercises WHERE id = :id")
                .setParameter("id", exerciseId)
                .getSingleResult();
    }

    private Long resolveTemplateIdOrNull(UUID templateUuid) {
        try {
            Object id = entityManager.createNativeQuery(
                            "SELECT id FROM workout_templates WHERE uuid = :uuid")
                    .setParameter("uuid", templateUuid)
                    .getSingleResult();
            return ((Number) id).longValue();
        } catch (NoResultException e) {
            return null;
        }
    }

    private UUID resolveTemplateUuid(Long templateId) {
        return (UUID) entityManager.createNativeQuery(
                        "SELECT uuid FROM workout_templates WHERE id = :id")
                .setParameter("id", templateId)
                .getSingleResult();
    }

    // ---------------------------------------------------------------------
    // Cursor helpers
    // ---------------------------------------------------------------------

    private record Cursor(Instant performedAt, Long id) {}

    private static String encodeCursor(Instant performedAt, Long id) {
        String raw = performedAt.toEpochMilli() + ":" + id;
        return Base64.getUrlEncoder().withoutPadding()
                .encodeToString(raw.getBytes(StandardCharsets.UTF_8));
    }

    private static Cursor decodeCursor(String encoded) {
        if (encoded == null) return null;
        try {
            String raw = new String(Base64.getUrlDecoder().decode(encoded), StandardCharsets.UTF_8);
            int sep = raw.indexOf(':');
            if (sep < 0) return null;
            Instant at = Instant.ofEpochMilli(Long.parseLong(raw.substring(0, sep)));
            Long id = Long.parseLong(raw.substring(sep + 1));
            return new Cursor(at, id);
        } catch (RuntimeException ex) {
            return null;
        }
    }
}
