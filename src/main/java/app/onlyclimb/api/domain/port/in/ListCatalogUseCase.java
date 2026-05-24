package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;

import java.util.List;

public interface ListCatalogUseCase {

    /** Returns the active entries of the requested catalog. */
    List<CatalogEntry> list(CatalogType type);
}
