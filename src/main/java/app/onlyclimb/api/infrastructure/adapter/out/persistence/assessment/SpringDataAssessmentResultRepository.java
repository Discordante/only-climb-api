package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

interface SpringDataAssessmentResultRepository
        extends JpaRepository<AssessmentResultJpaEntity, Long> {

    Optional<AssessmentResultJpaEntity> findByUuid(UUID uuid);
}
