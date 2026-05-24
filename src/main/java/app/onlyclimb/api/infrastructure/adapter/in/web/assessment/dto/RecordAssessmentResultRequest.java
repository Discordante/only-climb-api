package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record RecordAssessmentResultRequest(
        @NotNull UUID definitionId,
        @NotNull Instant performedAt,
        BigDecimal userWeightKg,
        String notes,
        @NotEmpty @Valid List<AssessmentMetricDto> metrics) {
}
