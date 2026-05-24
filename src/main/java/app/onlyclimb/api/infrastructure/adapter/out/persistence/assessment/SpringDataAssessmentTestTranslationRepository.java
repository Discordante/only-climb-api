package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface SpringDataAssessmentTestTranslationRepository
        extends JpaRepository<AssessmentTestTranslationJpaEntity, Long> {

    List<AssessmentTestTranslationJpaEntity> findByTestIdIn(List<Long> testIds);
}
