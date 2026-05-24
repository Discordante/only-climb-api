package app.onlyclimb.api.domain.exception;

import java.util.UUID;

public class WorkoutLogNotFoundException extends RuntimeException {
    public WorkoutLogNotFoundException(UUID id) {
        super("Workout log not found: " + id);
    }
}
