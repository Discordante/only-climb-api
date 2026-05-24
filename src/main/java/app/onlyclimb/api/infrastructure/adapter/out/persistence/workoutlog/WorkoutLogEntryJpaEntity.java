package app.onlyclimb.api.infrastructure.adapter.out.persistence.workoutlog;

import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "workout_log_entries", uniqueConstraints = @UniqueConstraint(
        name = "workout_log_entries_log_id_position_key",
        columnNames = {"log_id", "position"}))
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
class WorkoutLogEntryJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;

    @Column(name = "log_id", nullable = false)
    private Long logId;

    @Column(name = "exercise_id", nullable = false)
    private Long exerciseId;

    @Column(name = "position", nullable = false)
    private int position;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status", nullable = false, columnDefinition = "workout_log_entry_status")
    private WorkoutLogEntryStatus status;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "planned_config", nullable = false, columnDefinition = "jsonb")
    private Map<String, String> plannedConfig = new LinkedHashMap<>();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "actual_config", nullable = false, columnDefinition = "jsonb")
    private Map<String, String> actualConfig = new LinkedHashMap<>();

    @Column(name = "notes")
    private String notes;
}
