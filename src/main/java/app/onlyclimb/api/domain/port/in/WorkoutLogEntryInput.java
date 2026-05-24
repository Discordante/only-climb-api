package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;

import java.util.Map;
import java.util.UUID;

public record WorkoutLogEntryInput(
        int position,
        UUID exerciseId,
        WorkoutLogEntryStatus status,
        Map<ParameterType, String> plannedConfig,
        Map<ParameterType, String> actualConfig,
        String notes) {
}
