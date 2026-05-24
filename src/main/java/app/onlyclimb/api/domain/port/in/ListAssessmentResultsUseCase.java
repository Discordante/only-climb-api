package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.port.out.AssessmentResultRepository;

public interface ListAssessmentResultsUseCase {
    AssessmentResultRepository.Page<AssessmentResult> list(ListAssessmentResultsQuery query);
}
