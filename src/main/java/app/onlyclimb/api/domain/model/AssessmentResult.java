package app.onlyclimb.api.domain.model;

import app.onlyclimb.api.domain.exception.ContentOwnershipException;
import app.onlyclimb.api.domain.exception.InvalidAssessmentResultException;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

/**
 * Immutable snapshot of a user's measurement against an
 * {@link AssessmentDefinition}. Once persisted it cannot be updated — only
 * deleted by its owner. This is intentional: assessment history must reflect
 * what was actually measured.
 */
public final class AssessmentResult {

    private final UUID id;
    private final UUID ownerId;
    private final UUID definitionId;
    private final Instant performedAt;
    private final BigDecimal userWeightKg;
    private final String notes;
    private final List<AssessmentMetric> metrics;
    private final Instant createdAt;

    public AssessmentResult(
            UUID id,
            UUID ownerId,
            UUID definitionId,
            Instant performedAt,
            BigDecimal userWeightKg,
            String notes,
            List<AssessmentMetric> metrics,
            Instant createdAt) {
        this.id = Objects.requireNonNull(id, "id is required");
        this.ownerId = Objects.requireNonNull(ownerId, "ownerId is required");
        this.definitionId = Objects.requireNonNull(definitionId, "definitionId is required");
        this.performedAt = Objects.requireNonNull(performedAt, "performedAt is required");
        if (userWeightKg != null && userWeightKg.signum() < 0) {
            throw new InvalidAssessmentResultException("userWeightKg must be >= 0");
        }
        this.userWeightKg = userWeightKg;
        this.notes = (notes != null && notes.isBlank()) ? null : notes;
        if (metrics == null || metrics.isEmpty()) {
            throw new InvalidAssessmentResultException("at least one metric is required");
        }
        Set<UUID> seen = new LinkedHashSet<>();
        for (AssessmentMetric m : metrics) {
            if (!seen.add(m.testId())) {
                throw new InvalidAssessmentResultException("duplicate metric for test " + m.testId());
            }
        }
        this.metrics = List.copyOf(metrics);
        this.createdAt = Objects.requireNonNull(createdAt, "createdAt is required");
    }

    /**
     * Factory used by the application service when recording a new result.
     */
    public static AssessmentResult create(
            UUID ownerId,
            UUID definitionId,
            Instant performedAt,
            BigDecimal userWeightKg,
            String notes,
            List<AssessmentMetric> metrics) {
        Instant now = Instant.now();
        return new AssessmentResult(
                UUID.randomUUID(),
                ownerId,
                definitionId,
                performedAt,
                userWeightKg,
                notes,
                metrics,
                now);
    }

    public void assertOwnedBy(UUID candidateOwnerId) {
        if (candidateOwnerId == null || !candidateOwnerId.equals(ownerId)) {
            throw new ContentOwnershipException("Caller does not own this assessment result");
        }
    }

    public UUID getId() { return id; }
    public UUID getOwnerId() { return ownerId; }
    public UUID getDefinitionId() { return definitionId; }
    public Instant getPerformedAt() { return performedAt; }
    public Optional<BigDecimal> getUserWeightKg() { return Optional.ofNullable(userWeightKg); }
    public Optional<String> getNotes() { return Optional.ofNullable(notes); }
    public List<AssessmentMetric> getMetrics() { return metrics; }
    public Instant getCreatedAt() { return createdAt; }
}
