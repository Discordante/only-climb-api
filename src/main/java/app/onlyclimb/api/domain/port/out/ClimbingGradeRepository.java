package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.ClimbingGrade;
import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;

import java.util.List;

public interface ClimbingGradeRepository {

    /** True if the {@code (scale, value)} pair exists in the catalog. */
    boolean exists(ClimbingGrade grade);

    /**
     * Returns climbing grades ordered by {@code (scale, sort_order)}.
     * When {@code scale} is {@code null} returns every scale.
     */
    List<ClimbingGradeEntry> findAll(GradeScale scale);
}
