package app.onlyclimb.api.domain.model;

/**
 * Identifies a read-only reference catalog exposed by the API.
 * Each value corresponds to a {@code *_translations} table in V3.
 */
public enum CatalogType {
    EXERCISE_CATEGORY,
    MUSCLE_GROUP,
    GRIP_TYPE,
    PARAMETER_TYPE,
    GOAL_TYPE,
    EQUIPMENT
}
