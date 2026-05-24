package app.onlyclimb.api.infrastructure.adapter.out.persistence.catalog;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.port.out.CatalogReadRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Component
@Transactional(readOnly = true)
class CatalogJpaAdapter implements CatalogReadRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<CatalogEntry> findAll(CatalogType type) {
        CatalogTableMapping mapping = CatalogTableMapping.of(type);
        Map<UUID, MutableEntry> byId = loadEntries(mapping);
        if (byId.isEmpty()) {
            return List.of();
        }
        loadTranslations(mapping, byId);
        List<CatalogEntry> result = new ArrayList<>(byId.size());
        for (MutableEntry e : byId.values()) {
            result.add(new CatalogEntry(e.uuid, e.code, e.sortOrder, e.metadata, e.translations));
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    private Map<UUID, MutableEntry> loadEntries(CatalogTableMapping mapping) {
        StringBuilder cols = new StringBuilder("id, uuid, code, sort_order");
        for (String extra : mapping.extraColumns()) {
            cols.append(", ").append(extra);
        }
        String sql = "SELECT " + cols + " FROM " + mapping.table()
                + " WHERE is_active = TRUE ORDER BY sort_order, code";
        List<Object[]> rows = entityManager.createNativeQuery(sql).getResultList();
        Map<UUID, MutableEntry> byUuid = new LinkedHashMap<>();
        for (Object[] row : rows) {
            Long id = ((Number) row[0]).longValue();
            UUID uuid = (UUID) row[1];
            String code = (String) row[2];
            int sortOrder = ((Number) row[3]).intValue();
            Map<String, String> metadata = new LinkedHashMap<>();
            String[] extras = mapping.extraColumns();
            for (int i = 0; i < extras.length; i++) {
                Object value = row[4 + i];
                if (value != null) {
                    metadata.put(mapping.metadataKey(extras[i]), value.toString());
                }
            }
            byUuid.put(uuid, new MutableEntry(id, uuid, code, sortOrder, metadata));
        }
        return byUuid;
    }

    @SuppressWarnings("unchecked")
    private void loadTranslations(CatalogTableMapping mapping, Map<UUID, MutableEntry> byUuid) {
        String sql = "SELECT c.uuid, t.locale, t.field, t.value FROM "
                + mapping.table() + " c JOIN " + mapping.translationsTable() + " t "
                + "ON t." + mapping.foreignKey() + " = c.id "
                + "WHERE c.is_active = TRUE";
        List<Object[]> rows = entityManager.createNativeQuery(sql).getResultList();
        for (Object[] row : rows) {
            UUID uuid = (UUID) row[0];
            MutableEntry entry = byUuid.get(uuid);
            if (entry == null) continue;
            entry.translations.add(new Translation(
                    (String) row[1], (String) row[2], (String) row[3]));
        }
    }

    private static final class MutableEntry {
        final Long id;
        final UUID uuid;
        final String code;
        final int sortOrder;
        final Map<String, String> metadata;
        final List<Translation> translations = new ArrayList<>();

        MutableEntry(Long id, UUID uuid, String code, int sortOrder, Map<String, String> metadata) {
            this.id = id;
            this.uuid = uuid;
            this.code = code;
            this.sortOrder = sortOrder;
            this.metadata = metadata;
        }
    }
}
