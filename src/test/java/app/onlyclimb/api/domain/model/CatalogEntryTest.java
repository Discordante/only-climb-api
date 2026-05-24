package app.onlyclimb.api.domain.model;

import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class CatalogEntryTest {

    @Test
    void rejectsBlankCode() {
        assertThatThrownBy(() -> new CatalogEntry(UUID.randomUUID(), " ", 0, Map.of(), List.of()))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void resolvesRequestedLocale() {
        CatalogEntry entry = new CatalogEntry(
                UUID.randomUUID(), "HANGBOARD", 10, Map.of(),
                List.of(
                        new Translation("es", CatalogEntry.FIELD_NAME, "Hangboard"),
                        new Translation("en", CatalogEntry.FIELD_NAME, "Hangboard EN")));
        assertThat(entry.resolveField(CatalogEntry.FIELD_NAME, "en")).contains("Hangboard EN");
    }

    @Test
    void fallsBackToSpanishWhenLocaleMissing() {
        CatalogEntry entry = new CatalogEntry(
                UUID.randomUUID(), "PULL", 20, Map.of(),
                List.of(new Translation("es", CatalogEntry.FIELD_NAME, "Tracción")));
        assertThat(entry.resolveField(CatalogEntry.FIELD_NAME, "fr")).contains("Tracción");
    }

    @Test
    void returnsEmptyWhenFieldUnknown() {
        CatalogEntry entry = new CatalogEntry(
                UUID.randomUUID(), "X", 0, Map.of(),
                List.of(new Translation("es", CatalogEntry.FIELD_NAME, "X")));
        assertThat(entry.resolveField(CatalogEntry.FIELD_DESCRIPTION, "es")).isEmpty();
    }

    @Test
    void exposesMetadataAsImmutableCopy() {
        Map<String, String> input = new java.util.HashMap<>();
        input.put("unit", "kg");
        CatalogEntry entry = new CatalogEntry(UUID.randomUUID(), "X", 0, input, List.of());
        input.put("unit", "mutated");
        assertThat(entry.metadata()).containsEntry("unit", "kg");
    }
}
