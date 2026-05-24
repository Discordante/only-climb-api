package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import app.onlyclimb.api.domain.model.AssessmentMetric;
import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.port.in.ListAssessmentResultsQuery;
import app.onlyclimb.api.domain.port.out.AssessmentResultRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Transactional
class AssessmentResultJpaAdapter implements AssessmentResultRepository {

    private final SpringDataAssessmentResultRepository resultRepo;
    private final SpringDataAssessmentMetricRepository metricRepo;
    private final SpringDataAssessmentTestRepository testRepo;
    private final SpringDataAssessmentDefinitionRepository definitionRepo;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public AssessmentResult save(AssessmentResult result) {
        AssessmentResultJpaEntity entity = resultRepo.findByUuid(result.getId())
                .orElseGet(AssessmentResultJpaEntity::new);
        boolean isNew = entity.getId() == null;
        if (isNew) {
            entity.setUuid(result.getId());
            entity.setCreatedAt(result.getCreatedAt());
            entity.setUserId(resolveUserId(result.getOwnerId()));
            entity.setDefinitionId(resolveDefinitionId(result.getDefinitionId()));
        }
        entity.setPerformedAt(result.getPerformedAt());
        entity.setUserWeightKg(result.getUserWeightKg().orElse(null));
        entity.setNotes(result.getNotes().orElse(null));
        AssessmentResultJpaEntity persisted = resultRepo.save(entity);

        // Metrics are immutable per result — only write on creation.
        if (isNew) {
            for (AssessmentMetric m : result.getMetrics()) {
                AssessmentMetricJpaEntity metric = new AssessmentMetricJpaEntity();
                metric.setResultId(persisted.getId());
                metric.setTestId(resolveTestId(m.testId()));
                metric.setNumericValue(m.numericValue());
                metricRepo.save(metric);
            }
        }
        return toDomain(persisted);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<AssessmentResult> findById(UUID id) {
        return resultRepo.findByUuid(id).map(this::toDomain);
    }

    @Override
    public void deleteById(UUID id) {
        resultRepo.findByUuid(id).ifPresent(resultRepo::delete);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<AssessmentResult> search(ListAssessmentResultsQuery query) {
        Long ownerId = resolveUserIdOrNull(query.ownerId());
        if (ownerId == null) {
            return new Page<>(List.of(), null);
        }
        Long definitionId = query.definitionId() == null
                ? null : resolveDefinitionIdOrNull(query.definitionId());
        if (query.definitionId() != null && definitionId == null) {
            return new Page<>(List.of(), null);
        }

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<AssessmentResultJpaEntity> cq = cb.createQuery(AssessmentResultJpaEntity.class);
        Root<AssessmentResultJpaEntity> root = cq.from(AssessmentResultJpaEntity.class);

        List<Predicate> predicates = new ArrayList<>();
        predicates.add(cb.equal(root.get("userId"), ownerId));
        if (definitionId != null) {
            predicates.add(cb.equal(root.get("definitionId"), definitionId));
        }

        Cursor parsed = parseCursor(query.cursor());
        if (parsed != null) {
            Predicate older = cb.lessThan(root.get("performedAt"), parsed.performedAt);
            Predicate sameTime = cb.and(
                    cb.equal(root.get("performedAt"), parsed.performedAt),
                    cb.lessThan(root.get("id"), parsed.id));
            predicates.add(cb.or(older, sameTime));
        }

        cq.where(predicates.toArray(new Predicate[0]));
        cq.orderBy(cb.desc(root.get("performedAt")), cb.desc(root.get("id")));

        List<AssessmentResultJpaEntity> rows = entityManager.createQuery(cq)
                .setMaxResults(query.limit() + 1)
                .getResultList();

        String nextCursor = null;
        if (rows.size() > query.limit()) {
            AssessmentResultJpaEntity last = rows.get(query.limit() - 1);
            nextCursor = encodeCursor(last.getPerformedAt(), last.getId());
            rows = rows.subList(0, query.limit());
        }

        List<AssessmentResult> items = new ArrayList<>(rows.size());
        // Batch-load metrics for all rows
        List<Long> resultIds = rows.stream().map(AssessmentResultJpaEntity::getId).toList();
        Map<Long, List<AssessmentMetricJpaEntity>> metricsByResult = new HashMap<>();
        if (!resultIds.isEmpty()) {
            for (AssessmentMetricJpaEntity m : metricRepo.findByResultIdIn(resultIds)) {
                metricsByResult.computeIfAbsent(m.getResultId(), k -> new ArrayList<>()).add(m);
            }
        }
        for (AssessmentResultJpaEntity row : rows) {
            items.add(toDomain(row, metricsByResult.getOrDefault(row.getId(), List.of())));
        }
        return new Page<>(items, nextCursor);
    }

    // ------------------------------------------------------------------

    private AssessmentResult toDomain(AssessmentResultJpaEntity entity) {
        List<AssessmentMetricJpaEntity> metrics =
                metricRepo.findByResultIdIn(List.of(entity.getId()));
        return toDomain(entity, metrics);
    }

    private AssessmentResult toDomain(AssessmentResultJpaEntity entity,
                                      List<AssessmentMetricJpaEntity> metricRows) {
        List<AssessmentMetric> metrics = new ArrayList<>(metricRows.size());
        for (AssessmentMetricJpaEntity m : metricRows) {
            metrics.add(new AssessmentMetric(resolveTestUuid(m.getTestId()), m.getNumericValue()));
        }
        return new AssessmentResult(
                entity.getUuid(),
                resolveUserUuid(entity.getUserId()),
                resolveDefinitionUuid(entity.getDefinitionId()),
                entity.getPerformedAt(),
                entity.getUserWeightKg(),
                entity.getNotes(),
                metrics,
                entity.getCreatedAt());
    }

    private Long resolveUserId(UUID uuid) {
        Object id = entityManager.createNativeQuery("SELECT id FROM users WHERE uuid = :uuid")
                .setParameter("uuid", uuid).getSingleResult();
        return ((Number) id).longValue();
    }

    private Long resolveUserIdOrNull(UUID uuid) {
        try { return resolveUserId(uuid); } catch (NoResultException e) { return null; }
    }

    private UUID resolveUserUuid(Long id) {
        Object u = entityManager.createNativeQuery("SELECT uuid FROM users WHERE id = :id")
                .setParameter("id", id).getSingleResult();
        return (UUID) u;
    }

    private Long resolveDefinitionId(UUID uuid) {
        return definitionRepo.findByUuid(uuid)
                .map(AssessmentDefinitionJpaEntity::getId)
                .orElseThrow(() -> new IllegalStateException("Missing assessment definition: " + uuid));
    }

    private Long resolveDefinitionIdOrNull(UUID uuid) {
        return definitionRepo.findByUuid(uuid)
                .map(AssessmentDefinitionJpaEntity::getId)
                .orElse(null);
    }

    private UUID resolveDefinitionUuid(Long id) {
        return definitionRepo.findById(id)
                .map(AssessmentDefinitionJpaEntity::getUuid)
                .orElseThrow(() -> new IllegalStateException("Missing assessment definition row: " + id));
    }

    private Long resolveTestId(UUID uuid) {
        Object id = entityManager.createNativeQuery(
                        "SELECT id FROM assessment_tests WHERE uuid = :uuid")
                .setParameter("uuid", uuid).getSingleResult();
        return ((Number) id).longValue();
    }

    private UUID resolveTestUuid(Long id) {
        Object u = entityManager.createNativeQuery(
                        "SELECT uuid FROM assessment_tests WHERE id = :id")
                .setParameter("id", id).getSingleResult();
        return (UUID) u;
    }

    // Cursor handling ---------------------------------------------------

    private record Cursor(Instant performedAt, Long id) {}

    private static Cursor parseCursor(String cursor) {
        if (cursor == null || cursor.isBlank()) return null;
        try {
            byte[] decoded = Base64.getUrlDecoder().decode(cursor);
            String raw = new String(decoded, StandardCharsets.UTF_8);
            String[] parts = raw.split(":");
            if (parts.length != 2) return null;
            return new Cursor(Instant.ofEpochMilli(Long.parseLong(parts[0])), Long.parseLong(parts[1]));
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    private static String encodeCursor(Instant performedAt, Long id) {
        String raw = performedAt.toEpochMilli() + ":" + id;
        return Base64.getUrlEncoder().withoutPadding()
                .encodeToString(raw.getBytes(StandardCharsets.UTF_8));
    }
}
