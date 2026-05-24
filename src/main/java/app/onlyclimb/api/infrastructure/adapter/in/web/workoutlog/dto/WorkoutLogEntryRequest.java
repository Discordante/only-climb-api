package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto;

import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.util.Map;
import java.util.UUID;

public record WorkoutLogEntryRequest(
        @Min(1) int position,
        @NotNull UUID exerciseId,
        WorkoutLogEntryStatus status,
        Map<ParameterType, String> plannedConfig,
        Map<ParameterType, String> actualConfig,
        String notes) {
}
