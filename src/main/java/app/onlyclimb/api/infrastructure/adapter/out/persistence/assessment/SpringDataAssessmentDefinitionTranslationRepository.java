package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface SpringDataAssessmentDefinitionTranslationRepository
        extends JpaRepository<AssessmentDefinitionTranslationJpaEntity, Long> {

    List<AssessmentDefinitionTranslationJpaEntity> findByDefinitionIdIn(List<Long> definitionIds);
}
