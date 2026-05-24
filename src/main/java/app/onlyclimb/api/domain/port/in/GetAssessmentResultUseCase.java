package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AssessmentResult;

import java.util.UUID;

public interface GetAssessmentResultUseCase {
    AssessmentResult getOwned(UUID resultId, UUID callerId);
}
