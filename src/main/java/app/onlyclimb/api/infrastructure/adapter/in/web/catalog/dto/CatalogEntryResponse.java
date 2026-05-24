package app.onlyclimb.api.infrastructure.adapter.in.web.catalog.dto;

import app.onlyclimb.api.domain.model.CatalogEntry;

import java.util.Map;
import java.util.UUID;

public record CatalogEntryResponse(
        UUID id,
        String code,
        int sortOrder,
        String name,
        String description,
        Map<String, String> metadata) {

    public static CatalogEntryResponse from(CatalogEntry entry, String locale) {
        String name = entry.resolveField(CatalogEntry.FIELD_NAME, locale).orElse(null);
        String description = entry.resolveField(CatalogEntry.FIELD_DESCRIPTION, locale).orElse(null);
        return new CatalogEntryResponse(
                entry.id(), entry.code(), entry.sortOrder(),
                name, description, entry.metadata());
    }
}
