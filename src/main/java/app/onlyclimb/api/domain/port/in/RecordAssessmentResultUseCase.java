package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AssessmentResult;

public interface RecordAssessmentResultUseCase {
    AssessmentResult record(RecordAssessmentResultCommand command);
}
