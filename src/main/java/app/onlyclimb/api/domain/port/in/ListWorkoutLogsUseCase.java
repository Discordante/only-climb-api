package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository;

public interface ListWorkoutLogsUseCase {
    WorkoutLogRepository.Page<WorkoutLog> list(ListWorkoutLogsQuery query);
}
