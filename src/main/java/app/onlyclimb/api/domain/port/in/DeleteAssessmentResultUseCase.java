package app.onlyclimb.api.domain.port.in;

import java.util.UUID;

public interface DeleteAssessmentResultUseCase {
    void delete(UUID resultId, UUID callerId);
}
