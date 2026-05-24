package app.onlyclimb.api.domain.model;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * One performed (or skipped/modified) exercise inside a {@link WorkoutLog}.
 *
 * <p>{@code plannedConfig} is the snapshot of what the user intended to do
 * (typically copied from the originating template entry, if any).
 * {@code actualConfig} is what they actually performed. Keys are
 * {@link ParameterType} names; both maps may be empty (e.g. a SKIPPED entry
 * recorded only for completeness).</p>
 */
public class WorkoutLogEntry {

    private int position;
    private final UUID exerciseId;
    private WorkoutLogEntryStatus status;
    private final Map<ParameterType, String> plannedConfig;
    private final Map<ParameterType, String> actualConfig;
    private String notes;

    public WorkoutLogEntry(
            int position,
            UUID exerciseId,
            WorkoutLogEntryStatus status,
            Map<ParameterType, String> plannedConfig,
            Map<ParameterType, String> actualConfig,
            String notes) {
        if (position <= 0) {
            throw new IllegalArgumentException("position must be >= 1");
        }
        this.position = position;
        this.exerciseId = Objects.requireNonNull(exerciseId, "exerciseId is required");
        this.status = status == null ? WorkoutLogEntryStatus.COMPLETED : status;
        this.plannedConfig = plannedConfig == null ? new LinkedHashMap<>() : new LinkedHashMap<>(plannedConfig);
        this.actualConfig = actualConfig == null ? new LinkedHashMap<>() : new LinkedHashMap<>(actualConfig);
        this.notes = notes;
    }

    public int getPosition() {
        return position;
    }

    public UUID getExerciseId() {
        return exerciseId;
    }

    public WorkoutLogEntryStatus getStatus() {
        return status;
    }

    public Map<ParameterType, String> getPlannedConfig() {
        return java.util.Collections.unmodifiableMap(plannedConfig);
    }

    public Map<ParameterType, String> getActualConfig() {
        return java.util.Collections.unmodifiableMap(actualConfig);
    }

    public String getNotes() {
        return notes;
    }

    void renumber(int newPosition) {
        if (newPosition <= 0) {
            throw new IllegalArgumentException("position must be >= 1");
        }
        this.position = newPosition;
    }
}
