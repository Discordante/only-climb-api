package app.onlyclimb.api.domain.port.in;

import java.util.UUID;

public interface DeleteWorkoutLogUseCase {
    void delete(UUID logId, UUID callerId);
}
