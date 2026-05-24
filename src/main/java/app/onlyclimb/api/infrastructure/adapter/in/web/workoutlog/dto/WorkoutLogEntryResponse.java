package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto;

import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.WorkoutLogEntry;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;

import java.util.Map;
import java.util.UUID;

public record WorkoutLogEntryResponse(
        int position,
        UUID exerciseId,
        WorkoutLogEntryStatus status,
        Map<ParameterType, String> plannedConfig,
        Map<ParameterType, String> actualConfig,
        String notes) {

    public static WorkoutLogEntryResponse from(WorkoutLogEntry entry) {
        return new WorkoutLogEntryResponse(
                entry.getPosition(),
                entry.getExerciseId(),
                entry.getStatus(),
                entry.getPlannedConfig(),
                entry.getActualConfig(),
                entry.getNotes());
    }
}
