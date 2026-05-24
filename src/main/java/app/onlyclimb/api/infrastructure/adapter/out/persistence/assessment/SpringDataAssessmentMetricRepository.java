package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface SpringDataAssessmentMetricRepository
        extends JpaRepository<AssessmentMetricJpaEntity, Long> {

    List<AssessmentMetricJpaEntity> findByResultIdIn(List<Long> resultIds);
}
