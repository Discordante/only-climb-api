package app.onlyclimb.api.domain.model;

import java.util.Objects;

/**
 * Read-only entry from the {@code climbing_grades} catalog. Combines the
 * {@link ClimbingGrade} value object with the catalog ordering.
 */
public record ClimbingGradeEntry(ClimbingGrade grade, int sortOrder) {

    public ClimbingGradeEntry {
        Objects.requireNonNull(grade, "grade is required");
    }
}
