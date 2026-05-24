package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import java.util.List;

public record AssessmentResultPageResponse(
        List<AssessmentResultResponse> data,
        String nextCursor) {
}
