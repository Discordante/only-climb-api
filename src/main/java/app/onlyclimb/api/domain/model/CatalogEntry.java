package app.onlyclimb.api.domain.model;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * Read-only entry from a translatable reference catalog (equipment, goal types, ...).
 *
 * <p>{@code metadata} carries catalog-specific extra columns (e.g. {@code unit},
 * {@code valueType} for {@code PARAMETER_TYPE}, {@code requiresTargetGrade}
 * for {@code GOAL_TYPE}). Keys are stable, lowerCamelCase strings.</p>
 *
 * <p>Translations follow the project-wide convention: localized fields fall
 * back to Spanish ({@code "es"}) when the requested locale has no entry.</p>
 */
public record CatalogEntry(
        UUID id,
        String code,
        int sortOrder,
        Map<String, String> metadata,
        List<Translation> translations) {

    public static final String FIELD_NAME = "name";
    public static final String FIELD_DESCRIPTION = "description";
    public static final String FALLBACK_LOCALE = "es";

    public CatalogEntry {
        Objects.requireNonNull(id, "id is required");
        if (code == null || code.isBlank()) {
            throw new IllegalArgumentException("code is required");
        }
        metadata = metadata == null ? Map.of() : Map.copyOf(metadata);
        translations = translations == null ? List.of() : List.copyOf(translations);
    }

    /**
     * Returns the value for the requested field in the requested locale,
     * falling back to Spanish if not present.
     */
    public Optional<String> resolveField(String field, String locale) {
        Objects.requireNonNull(field, "field is required");
        String normalized = locale == null || locale.isBlank()
                ? FALLBACK_LOCALE
                : locale.toLowerCase(Locale.ROOT);
        Optional<String> direct = translations.stream()
                .filter(t -> t.field().equals(field) && t.locale().equals(normalized))
                .map(Translation::value)
                .findFirst();
        if (direct.isPresent() || normalized.equals(FALLBACK_LOCALE)) {
            return direct;
        }
        return translations.stream()
                .filter(t -> t.field().equals(field) && t.locale().equals(FALLBACK_LOCALE))
                .map(Translation::value)
                .findFirst();
    }
}
