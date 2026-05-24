package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface SpringDataAssessmentTestRepository
        extends JpaRepository<AssessmentTestJpaEntity, Long> {

    List<AssessmentTestJpaEntity> findByDefinitionIdOrderByPositionAsc(Long definitionId);

    List<AssessmentTestJpaEntity> findByDefinitionIdIn(List<Long> definitionIds);
}
