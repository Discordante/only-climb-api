package app.onlyclimb.api.domain.port.in;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record CreateWorkoutLogCommand(
        UUID ownerId,
        UUID workoutTemplateId,
        Instant performedAt,
        Integer durationMinutes,
        Integer perceivedEffort,
        String notes,
        List<WorkoutLogEntryInput> entries) {
}
