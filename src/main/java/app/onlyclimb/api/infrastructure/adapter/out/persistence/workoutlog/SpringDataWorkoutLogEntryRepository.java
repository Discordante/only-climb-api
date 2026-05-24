package app.onlyclimb.api.infrastructure.adapter.out.persistence.workoutlog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface SpringDataWorkoutLogEntryRepository extends JpaRepository<WorkoutLogEntryJpaEntity, Long> {

    List<WorkoutLogEntryJpaEntity> findByLogIdOrderByPosition(Long logId);

    void deleteByLogId(Long logId);
}
