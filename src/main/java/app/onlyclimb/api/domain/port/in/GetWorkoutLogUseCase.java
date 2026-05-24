package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.WorkoutLog;

import java.util.UUID;

public interface GetWorkoutLogUseCase {
    /** Returns the log only if the caller owns it; otherwise throws {@code WorkoutLogNotFoundException}. */
    WorkoutLog getOwned(UUID logId, UUID callerId);
}
