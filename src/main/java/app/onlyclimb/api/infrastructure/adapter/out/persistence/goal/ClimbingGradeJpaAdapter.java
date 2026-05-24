package app.onlyclimb.api.infrastructure.adapter.out.persistence.goal;

import app.onlyclimb.api.domain.model.ClimbingGrade;
import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;
import app.onlyclimb.api.domain.port.out.ClimbingGradeRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Component
@Transactional(readOnly = true)
class ClimbingGradeJpaAdapter implements ClimbingGradeRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public boolean exists(ClimbingGrade grade) {
        if (grade == null) return false;
        Number count = (Number) entityManager.createNativeQuery(
                        "SELECT COUNT(*) FROM climbing_grades " +
                                "WHERE scale = CAST(:scale AS grade_scale) AND value = :value")
                .setParameter("scale", grade.getScale().name())
                .setParameter("value", grade.getValue())
                .getSingleResult();
        return count.longValue() > 0;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ClimbingGradeEntry> findAll(GradeScale scale) {
        String sql = "SELECT scale, value, sort_order FROM climbing_grades "
                + (scale != null ? "WHERE scale = CAST(:scale AS grade_scale) " : "")
                + "ORDER BY scale, sort_order";
        var query = entityManager.createNativeQuery(sql);
        if (scale != null) {
            query.setParameter("scale", scale.name());
        }
        List<Object[]> rows = query.getResultList();
        List<ClimbingGradeEntry> result = new ArrayList<>(rows.size());
        for (Object[] row : rows) {
            GradeScale rowScale = GradeScale.valueOf(row[0].toString());
            String value = (String) row[1];
            int sortOrder = ((Number) row[2]).intValue();
            result.add(new ClimbingGradeEntry(new ClimbingGrade(rowScale, value), sortOrder));
        }
        return result;
    }
}
