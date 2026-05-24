package app.onlyclimb.api.domain.model;

import java.math.BigDecimal;
import java.util.Objects;
import java.util.UUID;

/**
 * Single numeric measurement attached to an {@link AssessmentResult}, one per
 * {@link AssessmentTest}. Immutable.
 */
public record AssessmentMetric(UUID testId, BigDecimal numericValue) {

    public AssessmentMetric {
        Objects.requireNonNull(testId, "testId is required");
        Objects.requireNonNull(numericValue, "numericValue is required");
    }
}
