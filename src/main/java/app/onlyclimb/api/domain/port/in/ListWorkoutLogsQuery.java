package app.onlyclimb.api.domain.port.in;

import java.time.Instant;
import java.util.UUID;

/**
 * Filters for listing the caller's own workout logs (logs are private).
 * Ordered by {@code performedAt DESC, id DESC}; cursor encodes both.
 */
public record ListWorkoutLogsQuery(
        UUID ownerId,
        UUID workoutTemplateId,
        Instant from,
        Instant to,
        String cursor,
        int limit) {

    public ListWorkoutLogsQuery {
        if (ownerId == null) {
            throw new IllegalArgumentException("ownerId is required");
        }
        if (limit <= 0 || limit > 100) {
            limit = 20;
        }
    }
}
