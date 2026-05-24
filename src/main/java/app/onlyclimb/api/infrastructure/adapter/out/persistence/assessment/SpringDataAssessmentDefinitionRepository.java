package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

interface SpringDataAssessmentDefinitionRepository
        extends JpaRepository<AssessmentDefinitionJpaEntity, Long> {

    Optional<AssessmentDefinitionJpaEntity> findByUuid(UUID uuid);

    List<AssessmentDefinitionJpaEntity> findByActiveTrueOrderByCodeAsc();
}
