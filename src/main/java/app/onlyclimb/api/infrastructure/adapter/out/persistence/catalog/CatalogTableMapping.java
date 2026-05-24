package app.onlyclimb.api.infrastructure.adapter.out.persistence.catalog;

import app.onlyclimb.api.domain.model.CatalogType;

import java.util.Map;

/**
 * Static mapping from a {@link CatalogType} to the catalog tables in V3.
 * Centralises table/column names so the adapter stays a single switch.
 */
record CatalogTableMapping(
        String table,
        String translationsTable,
        String foreignKey,
        String[] extraColumns,
        Map<String, String> metadataKeys) {

    static CatalogTableMapping of(CatalogType type) {
        return switch (type) {
            case EXERCISE_CATEGORY -> new CatalogTableMapping(
                    "exercise_categories",
                    "exercise_category_translations",
                    "category_id",
                    new String[0],
                    Map.of());
            case MUSCLE_GROUP -> new CatalogTableMapping(
                    "muscle_groups",
                    "muscle_group_translations",
                    "muscle_group_id",
                    new String[0],
                    Map.of());
            case GRIP_TYPE -> new CatalogTableMapping(
                    "grip_types",
                    "grip_type_translations",
                    "grip_type_id",
                    new String[0],
                    Map.of());
            case PARAMETER_TYPE -> new CatalogTableMapping(
                    "parameter_types",
                    "parameter_type_translations",
                    "parameter_type_id",
                    new String[]{"unit", "value_type"},
                    Map.of("unit", "unit", "value_type", "valueType"));
            case GOAL_TYPE -> new CatalogTableMapping(
                    "goal_types",
                    "goal_type_translations",
                    "goal_type_id",
                    new String[]{"requires_target_grade"},
                    Map.of("requires_target_grade", "requiresTargetGrade"));
            case EQUIPMENT -> new CatalogTableMapping(
                    "equipment",
                    "equipment_translations",
                    "equipment_id",
                    new String[0],
                    Map.of());
        };
    }

    String metadataKey(String column) {
        String mapped = metadataKeys.get(column);
        return mapped != null ? mapped : column;
    }
}
