package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import app.onlyclimb.api.domain.model.AssessmentResult;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record AssessmentResultResponse(
        UUID id,
        UUID definitionId,
        UUID ownerId,
        Instant performedAt,
        BigDecimal userWeightKg,
        String notes,
        List<AssessmentMetricDto> metrics,
        Instant createdAt) {

    public static AssessmentResultResponse from(AssessmentResult result) {
        return new AssessmentResultResponse(
                result.getId(),
                result.getDefinitionId(),
                result.getOwnerId(),
                result.getPerformedAt(),
                result.getUserWeightKg().orElse(null),
                result.getNotes().orElse(null),
                result.getMetrics().stream().map(AssessmentMetricDto::from).toList(),
                result.getCreatedAt());
    }
}
