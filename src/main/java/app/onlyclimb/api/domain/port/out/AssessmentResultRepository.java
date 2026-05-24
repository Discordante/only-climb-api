package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.port.in.ListAssessmentResultsQuery;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface AssessmentResultRepository {

    AssessmentResult save(AssessmentResult result);

    Optional<AssessmentResult> findById(UUID id);

    void deleteById(UUID id);

    Page<AssessmentResult> search(ListAssessmentResultsQuery query);

    record Page<T>(List<T> items, String nextCursor) {}
}
