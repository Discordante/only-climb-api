package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.WorkoutLog;

public interface UpdateWorkoutLogUseCase {
    WorkoutLog update(UpdateWorkoutLogCommand command);
}
