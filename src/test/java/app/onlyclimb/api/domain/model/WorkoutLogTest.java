package app.onlyclimb.api.domain.model;

import app.onlyclimb.api.domain.exception.ContentOwnershipException;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class WorkoutLogTest {

    private static final UUID OWNER = UUID.randomUUID();
    private static final UUID STRANGER = UUID.randomUUID();

    private static WorkoutLogEntry entry(int position) {
        return new WorkoutLogEntry(
                position, UUID.randomUUID(),
                WorkoutLogEntryStatus.COMPLETED,
                Map.of(ParameterType.REPS, "5"),
                Map.of(ParameterType.REPS, "4"),
                null);
    }

    @Test
    void create_setsDefaults_andRenumbersPositions() {
        WorkoutLog log = WorkoutLog.create(
                OWNER, null, Instant.parse("2025-01-15T10:00:00Z"),
                45, 7, "felt great",
                List.of(entry(5), entry(2)));

        assertThat(log.getOwnerId()).isEqualTo(OWNER);
        assertThat(log.getWorkoutTemplateId()).isEmpty();
        assertThat(log.getDurationMinutes()).contains(45);
        assertThat(log.getPerceivedEffort()).contains(7);
        assertThat(log.getEntries()).extracting(WorkoutLogEntry::getPosition).containsExactly(1, 2);
        assertThat(log.getCreatedAt()).isEqualTo(log.getUpdatedAt());
    }

    @Test
    void rejectsDuplicatePositions() {
        assertThatThrownBy(() -> WorkoutLog.create(
                OWNER, null, Instant.now(), null, null, null,
                List.of(entry(1), entry(1))))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Duplicate position");
    }

    @Test
    void rejectsPerceivedEffortOutOfRange() {
        assertThatThrownBy(() -> WorkoutLog.create(
                OWNER, null, Instant.now(), null, 11, null, List.of(entry(1))))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("perceivedEffort");
        assertThatThrownBy(() -> WorkoutLog.create(
                OWNER, null, Instant.now(), null, 0, null, List.of(entry(1))))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("perceivedEffort");
    }

    @Test
    void rejectsNonPositiveDuration() {
        assertThatThrownBy(() -> WorkoutLog.create(
                OWNER, null, Instant.now(), 0, null, null, List.of(entry(1))))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("durationMinutes");
    }

    @Test
    void requiresOwnerAndPerformedAt() {
        assertThatThrownBy(() -> WorkoutLog.create(
                null, null, Instant.now(), null, null, null, List.of(entry(1))))
                .isInstanceOf(NullPointerException.class);
        assertThatThrownBy(() -> WorkoutLog.create(
                OWNER, null, null, null, null, null, List.of(entry(1))))
                .isInstanceOf(NullPointerException.class);
    }

    @Test
    void assertOwnedBy_rejectsStranger() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null, List.of(entry(1)));
        assertThatThrownBy(() -> log.assertOwnedBy(STRANGER))
                .isInstanceOf(ContentOwnershipException.class);
    }

    @Test
    void replaceEntries_renumbers_andTouches() throws InterruptedException {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null, List.of(entry(1)));
        Instant before = log.getUpdatedAt();
        Thread.sleep(2);
        log.replaceEntries(List.of(entry(10), entry(3)));
        assertThat(log.getEntries()).extracting(WorkoutLogEntry::getPosition).containsExactly(1, 2);
        assertThat(log.getUpdatedAt()).isAfter(before);
    }

    @Test
    void replaceEntries_rejectsEmpty() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null, List.of(entry(1)));
        assertThatThrownBy(() -> log.replaceEntries(List.of()))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
