package app.onlyclimb.api.domain.model;

import app.onlyclimb.api.domain.exception.ContentOwnershipException;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

/**
 * Aggregate root representing one workout session a user actually performed.
 *
 * <p>Workout logs are strictly personal data: only the {@link #getOwnerId owner}
 * may read, update or delete them. No visibility, no source — they always
 * belong to exactly one user.</p>
 *
 * <p>A log may optionally reference the {@link WorkoutTemplate} that inspired
 * it (handy for analytics). It does not auto-update when the template
 * changes; planned vs. actual configs are snapshot on the {@link WorkoutLogEntry}.</p>
 */
public class WorkoutLog {

    private final UUID id;
    private final UUID ownerId;
    private UUID workoutTemplateId;
    private Instant performedAt;
    private Integer durationMinutes;
    private Integer perceivedEffort;
    private String notes;
    private final List<WorkoutLogEntry> entries;
    private final Instant createdAt;
    private Instant updatedAt;

    public WorkoutLog(
            UUID id,
            UUID ownerId,
            UUID workoutTemplateId,
            Instant performedAt,
            Integer durationMinutes,
            Integer perceivedEffort,
            String notes,
            List<WorkoutLogEntry> entries,
            Instant createdAt,
            Instant updatedAt) {
        this.id = Objects.requireNonNull(id, "id is required");
        this.ownerId = Objects.requireNonNull(ownerId, "ownerId is required");
        this.workoutTemplateId = workoutTemplateId;
        this.performedAt = Objects.requireNonNull(performedAt, "performedAt is required");
        setDurationMinutes(durationMinutes);
        setPerceivedEffort(perceivedEffort);
        this.notes = notes;

        this.entries = new ArrayList<>();
        if (entries != null) {
            this.entries.addAll(entries);
        }
        renumberAndValidatePositions();

        this.createdAt = Objects.requireNonNull(createdAt, "createdAt is required");
        this.updatedAt = Objects.requireNonNull(updatedAt, "updatedAt is required");
    }

    /** Factory for a freshly created log. */
    public static WorkoutLog create(
            UUID ownerId,
            UUID workoutTemplateId,
            Instant performedAt,
            Integer durationMinutes,
            Integer perceivedEffort,
            String notes,
            List<WorkoutLogEntry> entries) {
        Instant now = Instant.now();
        return new WorkoutLog(
                UUID.randomUUID(),
                ownerId,
                workoutTemplateId,
                performedAt,
                durationMinutes,
                perceivedEffort,
                notes,
                entries,
                now, now);
    }

    // ---------------------------------------------------------------------
    // Mutators
    // ---------------------------------------------------------------------

    public void updateDetails(
            UUID workoutTemplateId,
            Instant performedAt,
            Integer durationMinutes,
            Integer perceivedEffort,
            String notes) {
        this.workoutTemplateId = workoutTemplateId;
        this.performedAt = Objects.requireNonNull(performedAt, "performedAt is required");
        setDurationMinutes(durationMinutes);
        setPerceivedEffort(perceivedEffort);
        this.notes = notes;
        touch();
    }

    public void replaceEntries(List<WorkoutLogEntry> newEntries) {
        if (newEntries == null || newEntries.isEmpty()) {
            throw new IllegalArgumentException("Workout log must contain at least one entry");
        }
        this.entries.clear();
        this.entries.addAll(newEntries);
        renumberAndValidatePositions();
        touch();
    }

    public void assertOwnedBy(UUID callerId) {
        if (callerId == null || !callerId.equals(ownerId)) {
            throw new ContentOwnershipException("Caller does not own this workout log");
        }
    }

    // ---------------------------------------------------------------------
    // Accessors
    // ---------------------------------------------------------------------

    public UUID getId() { return id; }
    public UUID getOwnerId() { return ownerId; }
    public Optional<UUID> getWorkoutTemplateId() { return Optional.ofNullable(workoutTemplateId); }
    public Instant getPerformedAt() { return performedAt; }
    public Optional<Integer> getDurationMinutes() { return Optional.ofNullable(durationMinutes); }
    public Optional<Integer> getPerceivedEffort() { return Optional.ofNullable(perceivedEffort); }
    public Optional<String> getNotes() { return Optional.ofNullable(notes); }
    public List<WorkoutLogEntry> getEntries() { return Collections.unmodifiableList(entries); }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }

    // ---------------------------------------------------------------------
    // Internals
    // ---------------------------------------------------------------------

    private void setDurationMinutes(Integer value) {
        if (value != null && value <= 0) {
            throw new IllegalArgumentException("durationMinutes must be positive");
        }
        this.durationMinutes = value;
    }

    private void setPerceivedEffort(Integer value) {
        if (value != null && (value < 1 || value > 10)) {
            throw new IllegalArgumentException("perceivedEffort must be in [1, 10]");
        }
        this.perceivedEffort = value;
    }

    private void renumberAndValidatePositions() {
        Set<Integer> seen = new HashSet<>();
        for (WorkoutLogEntry e : entries) {
            if (!seen.add(e.getPosition())) {
                throw new IllegalArgumentException("Duplicate position: " + e.getPosition());
            }
        }
        entries.sort((a, b) -> Integer.compare(a.getPosition(), b.getPosition()));
        for (int i = 0; i < entries.size(); i++) {
            entries.get(i).renumber(i + 1);
        }
    }

    private void touch() {
        this.updatedAt = Instant.now();
    }
}
