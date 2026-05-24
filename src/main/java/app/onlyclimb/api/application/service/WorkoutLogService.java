package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.exception.ContentOwnershipException;
import app.onlyclimb.api.domain.exception.ExerciseNotFoundException;
import app.onlyclimb.api.domain.exception.InvalidExerciseConfigException;
import app.onlyclimb.api.domain.exception.WorkoutLogNotFoundException;
import app.onlyclimb.api.domain.exception.WorkoutTemplateNotFoundException;
import app.onlyclimb.api.domain.model.ContentSource;
import app.onlyclimb.api.domain.model.ContentVisibility;
import app.onlyclimb.api.domain.model.Exercise;
import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.model.WorkoutLogEntry;
import app.onlyclimb.api.domain.model.WorkoutTemplate;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.DeleteWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.GetWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsQuery;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsUseCase;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.WorkoutLogEntryInput;
import app.onlyclimb.api.domain.port.out.ExerciseRepository;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository.Page;
import app.onlyclimb.api.domain.port.out.WorkoutTemplateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WorkoutLogService implements
        CreateWorkoutLogUseCase,
        UpdateWorkoutLogUseCase,
        DeleteWorkoutLogUseCase,
        GetWorkoutLogUseCase,
        ListWorkoutLogsUseCase {

    private final WorkoutLogRepository logRepository;
    private final ExerciseRepository exerciseRepository;
    private final WorkoutTemplateRepository templateRepository;

    @Override
    @Transactional
    public WorkoutLog create(CreateWorkoutLogCommand command) {
        Objects.requireNonNull(command.ownerId(), "ownerId is required");
        validateTemplateReference(command.workoutTemplateId(), command.ownerId());
        List<WorkoutLogEntry> entries = mapAndValidateEntries(command.entries(), command.ownerId());
        WorkoutLog log = WorkoutLog.create(
                command.ownerId(),
                command.workoutTemplateId(),
                command.performedAt(),
                command.durationMinutes(),
                command.perceivedEffort(),
                command.notes(),
                entries);
        return logRepository.save(log);
    }

    @Override
    @Transactional
    public WorkoutLog update(UpdateWorkoutLogCommand command) {
        WorkoutLog log = logRepository.findById(command.logId())
                .orElseThrow(() -> new WorkoutLogNotFoundException(command.logId()));
        log.assertOwnedBy(command.callerId());
        validateTemplateReference(command.workoutTemplateId(), command.callerId());
        List<WorkoutLogEntry> entries = mapAndValidateEntries(command.entries(), command.callerId());
        log.updateDetails(
                command.workoutTemplateId(),
                command.performedAt(),
                command.durationMinutes(),
                command.perceivedEffort(),
                command.notes());
        log.replaceEntries(entries);
        return logRepository.save(log);
    }

    @Override
    @Transactional
    public void delete(UUID logId, UUID callerId) {
        WorkoutLog log = logRepository.findById(logId)
                .orElseThrow(() -> new WorkoutLogNotFoundException(logId));
        try {
            log.assertOwnedBy(callerId);
        } catch (ContentOwnershipException ex) {
            // Hide existence of logs the caller does not own.
            throw new WorkoutLogNotFoundException(logId);
        }
        logRepository.deleteById(logId);
    }

    @Override
    @Transactional(readOnly = true)
    public WorkoutLog getOwned(UUID logId, UUID callerId) {
        WorkoutLog log = logRepository.findById(logId)
                .orElseThrow(() -> new WorkoutLogNotFoundException(logId));
        if (callerId == null || !callerId.equals(log.getOwnerId())) {
            throw new WorkoutLogNotFoundException(logId);
        }
        return log;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<WorkoutLog> list(ListWorkoutLogsQuery query) {
        return logRepository.search(query);
    }

    // ---------------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------------

    private void validateTemplateReference(UUID templateId, UUID callerId) {
        if (templateId == null) return;
        WorkoutTemplate template = templateRepository.findById(templateId)
                .filter(WorkoutTemplate::isActive)
                .orElseThrow(() -> new WorkoutTemplateNotFoundException(templateId));
        if (!isTemplateVisibleTo(template, callerId)) {
            throw new WorkoutTemplateNotFoundException(templateId);
        }
    }

    private static boolean isTemplateVisibleTo(WorkoutTemplate template, UUID callerId) {
        if (template.getSource() == ContentSource.PLATFORM) return true;
        if (template.getVisibility() == ContentVisibility.PUBLIC) return true;
        return callerId != null
                && template.getOwnerId().map(callerId::equals).orElse(false);
    }

    private List<WorkoutLogEntry> mapAndValidateEntries(
            List<WorkoutLogEntryInput> input, UUID callerId) {
        if (input == null) return List.of();
        List<WorkoutLogEntry> result = new ArrayList<>(input.size());
        for (WorkoutLogEntryInput entry : input) {
            Exercise exercise = exerciseRepository.findById(entry.exerciseId())
                    .filter(Exercise::isActive)
                    .orElseThrow(() -> new ExerciseNotFoundException(entry.exerciseId()));
            if (!isExerciseVisibleTo(exercise, callerId)) {
                throw new ExerciseNotFoundException(entry.exerciseId());
            }
            validateConfigKeys(exercise, entry.plannedConfig());
            validateConfigKeys(exercise, entry.actualConfig());
            result.add(new WorkoutLogEntry(
                    entry.position(),
                    entry.exerciseId(),
                    entry.status(),
                    entry.plannedConfig(),
                    entry.actualConfig(),
                    entry.notes()));
        }
        return result;
    }

    private static boolean isExerciseVisibleTo(Exercise exercise, UUID callerId) {
        if (exercise.getSource() == ContentSource.PLATFORM) return true;
        if (exercise.getVisibility() == ContentVisibility.PUBLIC) return true;
        return callerId != null
                && exercise.getOwnerId().map(callerId::equals).orElse(false);
    }

    private static void validateConfigKeys(Exercise exercise, Map<ParameterType, String> config) {
        if (config == null || config.isEmpty()) return;
        Set<ParameterType> allowed = exercise.getAllowedParameters();
        Set<ParameterType> unknown = new HashSet<>(config.keySet());
        unknown.removeAll(allowed);
        if (!unknown.isEmpty()) {
            throw new InvalidExerciseConfigException(
                    "Exercise " + exercise.getId() + " does not allow parameters: " + unknown);
        }
    }
}
