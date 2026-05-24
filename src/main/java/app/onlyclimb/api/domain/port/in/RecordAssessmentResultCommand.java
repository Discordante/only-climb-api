package app.onlyclimb.api.domain.port.in;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record RecordAssessmentResultCommand(
        UUID ownerId,
        UUID definitionId,
        Instant performedAt,
        BigDecimal userWeightKg,
        String notes,
        List<AssessmentMetricInput> metrics) {}
