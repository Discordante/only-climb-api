package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record UpdateWorkoutLogRequest(
        UUID workoutTemplateId,
        @NotNull Instant performedAt,
        @Min(1) Integer durationMinutes,
        @Min(1) @Max(10) Integer perceivedEffort,
        String notes,
        @Valid List<WorkoutLogEntryRequest> entries) {
}
