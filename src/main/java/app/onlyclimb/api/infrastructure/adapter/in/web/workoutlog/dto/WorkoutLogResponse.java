package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto;

import app.onlyclimb.api.domain.model.WorkoutLog;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record WorkoutLogResponse(
        UUID id,
        UUID ownerId,
        UUID workoutTemplateId,
        Instant performedAt,
        Integer durationMinutes,
        Integer perceivedEffort,
        String notes,
        List<WorkoutLogEntryResponse> entries,
        Instant createdAt,
        Instant updatedAt) {

    public static WorkoutLogResponse from(WorkoutLog log) {
        return new WorkoutLogResponse(
                log.getId(),
                log.getOwnerId(),
                log.getWorkoutTemplateId().orElse(null),
                log.getPerformedAt(),
                log.getDurationMinutes().orElse(null),
                log.getPerceivedEffort().orElse(null),
                log.getNotes().orElse(null),
                log.getEntries().stream().map(WorkoutLogEntryResponse::from).toList(),
                log.getCreatedAt(),
                log.getUpdatedAt());
    }
}
