package app.onlyclimb.api.domain.port.in;

import java.math.BigDecimal;
import java.util.UUID;

/** Single measurement input when recording an assessment result. */
public record AssessmentMetricInput(UUID testId, BigDecimal numericValue) {}
