package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;

import java.util.List;

public interface ListClimbingGradesUseCase {

    /**
     * Returns the climbing grades catalog. When {@code scale} is {@code null}
     * the result spans every supported scale.
     */
    List<ClimbingGradeEntry> list(GradeScale scale);
}
