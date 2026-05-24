package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import app.onlyclimb.api.domain.model.AssessmentMetric;
import app.onlyclimb.api.domain.port.in.AssessmentMetricInput;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

public record AssessmentMetricDto(
        @NotNull UUID testId,
        @NotNull BigDecimal numericValue) {

    public AssessmentMetricInput toInput() {
        return new AssessmentMetricInput(testId, numericValue);
    }

    public static AssessmentMetricDto from(AssessmentMetric metric) {
        return new AssessmentMetricDto(metric.testId(), metric.numericValue());
    }
}
