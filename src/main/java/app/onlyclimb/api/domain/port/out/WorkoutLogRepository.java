package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsQuery;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WorkoutLogRepository {

    WorkoutLog save(WorkoutLog log);

    Optional<WorkoutLog> findById(UUID id);

    void deleteById(UUID id);

    Page<WorkoutLog> search(ListWorkoutLogsQuery query);

    record Page<T>(List<T> items, String nextCursor) {}
}
