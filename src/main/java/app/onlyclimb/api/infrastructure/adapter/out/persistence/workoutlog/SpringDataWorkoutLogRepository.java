package app.onlyclimb.api.infrastructure.adapter.out.persistence.workoutlog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

interface SpringDataWorkoutLogRepository extends JpaRepository<WorkoutLogJpaEntity, Long> {

    Optional<WorkoutLogJpaEntity> findByUuid(UUID uuid);
}
