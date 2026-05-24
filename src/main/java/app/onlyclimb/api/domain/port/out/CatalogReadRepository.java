package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;

import java.util.List;

/** Read-only access to translatable reference catalogs. */
public interface CatalogReadRepository {

    /**
     * Returns active entries of the given catalog ordered by {@code sort_order},
     * each fully loaded with its translations and metadata.
     */
    List<CatalogEntry> findAll(CatalogType type);
}
