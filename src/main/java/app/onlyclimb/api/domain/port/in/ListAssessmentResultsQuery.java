package app.onlyclimb.api.domain.port.in;

import java.util.UUID;

public record ListAssessmentResultsQuery(
        UUID ownerId,
        UUID definitionId,
        String cursor,
        int limit) {

    public ListAssessmentResultsQuery {
        if (limit <= 0 || limit > 100) {
            limit = 20;
        }
    }
}
