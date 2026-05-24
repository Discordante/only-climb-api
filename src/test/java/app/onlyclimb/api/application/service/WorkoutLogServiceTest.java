package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.exception.InvalidExerciseConfigException;
import app.onlyclimb.api.domain.exception.WorkoutLogNotFoundException;
import app.onlyclimb.api.domain.exception.WorkoutTemplateNotFoundException;
import app.onlyclimb.api.domain.model.ContentVisibility;
import app.onlyclimb.api.domain.model.DifficultyLevel;
import app.onlyclimb.api.domain.model.Exercise;
import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.SafetyWarningLevel;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.model.WorkoutLogEntry;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;
import app.onlyclimb.api.domain.model.WorkoutTemplate;
import app.onlyclimb.api.domain.model.WorkoutTemplateExercise;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.WorkoutLogEntryInput;
import app.onlyclimb.api.domain.port.out.ExerciseRepository;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository;
import app.onlyclimb.api.domain.port.out.WorkoutTemplateRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class WorkoutLogServiceTest {

    private static final UUID OWNER = UUID.randomUUID();
    private static final UUID STRANGER = UUID.randomUUID();

    @Mock WorkoutLogRepository logRepository;
    @Mock ExerciseRepository exerciseRepository;
    @Mock WorkoutTemplateRepository templateRepository;
    @InjectMocks WorkoutLogService service;

    private Exercise publicExercise;

    @BeforeEach
    void setUp() {
        publicExercise = Exercise.createUserExercise(
                OWNER, "HANGBOARD", "FINGERS",
                DifficultyLevel.INTERMEDIATE, SafetyWarningLevel.MODERATE,
                true, false, null,
                Set.of(ParameterType.REPS, ParameterType.SETS),
                List.of(new Translation("en", Exercise.FIELD_NAME, "Repeaters")),
                ContentVisibility.PUBLIC);
    }

    private WorkoutLogEntryInput validInput() {
        return new WorkoutLogEntryInput(
                1, publicExercise.getId(), WorkoutLogEntryStatus.COMPLETED,
                Map.of(ParameterType.REPS, "5"),
                Map.of(ParameterType.REPS, "4"),
                null);
    }

    @Test
    void create_withoutTemplate_validatesAndSaves() {
        given(exerciseRepository.findById(publicExercise.getId())).willReturn(Optional.of(publicExercise));
        given(logRepository.save(any())).willAnswer(inv -> inv.getArgument(0));

        WorkoutLog result = service.create(new CreateWorkoutLogCommand(
                OWNER, null, Instant.parse("2025-01-15T10:00:00Z"),
                40, 6, "fine", List.of(validInput())));

        assertThat(result.getOwnerId()).isEqualTo(OWNER);
        assertThat(result.getEntries()).hasSize(1);
        verify(logRepository).save(any(WorkoutLog.class));
    }

    @Test
    void create_withInvisibleTemplate_rejects() {
        UUID templateId = UUID.randomUUID();
        WorkoutTemplate privateTpl = WorkoutTemplate.createUserTemplate(
                STRANGER, ContentVisibility.PRIVATE, DifficultyLevel.BEGINNER, null, null,
                List.of(new WorkoutTemplateExercise(1, publicExercise.getId(), Map.of(), List.of())),
                List.of(new Translation("en", WorkoutTemplate.FIELD_NAME, "Secret")));
        given(templateRepository.findById(any())).willReturn(Optional.of(privateTpl));

        assertThatThrownBy(() -> service.create(new CreateWorkoutLogCommand(
                OWNER, privateTpl.getId(), Instant.now(), null, null, null,
                List.of(validInput()))))
                .isInstanceOf(WorkoutTemplateNotFoundException.class);
        verify(logRepository, never()).save(any());
    }

    @Test
    void create_rejectsUnknownConfigKey_inPlannedOrActual() {
        given(exerciseRepository.findById(publicExercise.getId())).willReturn(Optional.of(publicExercise));

        WorkoutLogEntryInput badPlanned = new WorkoutLogEntryInput(
                1, publicExercise.getId(), WorkoutLogEntryStatus.COMPLETED,
                Map.of(ParameterType.WEIGHT_KG, "20"), Map.of(), null);
        assertThatThrownBy(() -> service.create(new CreateWorkoutLogCommand(
                OWNER, null, Instant.now(), null, null, null, List.of(badPlanned))))
                .isInstanceOf(InvalidExerciseConfigException.class)
                .hasMessageContaining("WEIGHT_KG");

        WorkoutLogEntryInput badActual = new WorkoutLogEntryInput(
                1, publicExercise.getId(), WorkoutLogEntryStatus.COMPLETED,
                Map.of(), Map.of(ParameterType.EDGE_DEPTH_MM, "10"), null);
        assertThatThrownBy(() -> service.create(new CreateWorkoutLogCommand(
                OWNER, null, Instant.now(), null, null, null, List.of(badActual))))
                .isInstanceOf(InvalidExerciseConfigException.class)
                .hasMessageContaining("EDGE_DEPTH_MM");
    }

    @Test
    void update_rejectsNonOwnerAsNotFound() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null,
                List.of(new WorkoutLogEntry(1, publicExercise.getId(),
                        WorkoutLogEntryStatus.COMPLETED, Map.of(), Map.of(), null)));
        given(logRepository.findById(log.getId())).willReturn(Optional.of(log));

        UpdateWorkoutLogCommand cmd = new UpdateWorkoutLogCommand(
                log.getId(), STRANGER, null, Instant.now(), null, null, null,
                List.of(validInput()));

        assertThatThrownBy(() -> service.update(cmd))
                .isInstanceOf(app.onlyclimb.api.domain.exception.ContentOwnershipException.class);
    }

    @Test
    void delete_byOwner_invokesRepository() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null,
                List.of(new WorkoutLogEntry(1, publicExercise.getId(),
                        WorkoutLogEntryStatus.COMPLETED, Map.of(), Map.of(), null)));
        given(logRepository.findById(log.getId())).willReturn(Optional.of(log));

        service.delete(log.getId(), OWNER);

        verify(logRepository).deleteById(log.getId());
    }

    @Test
    void delete_byStranger_returnsNotFound() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null,
                List.of(new WorkoutLogEntry(1, publicExercise.getId(),
                        WorkoutLogEntryStatus.COMPLETED, Map.of(), Map.of(), null)));
        given(logRepository.findById(log.getId())).willReturn(Optional.of(log));

        assertThatThrownBy(() -> service.delete(log.getId(), STRANGER))
                .isInstanceOf(WorkoutLogNotFoundException.class);
        verify(logRepository, never()).deleteById(any());
    }

    @Test
    void getOwned_rejectsStrangerAsNotFound() {
        WorkoutLog log = WorkoutLog.create(OWNER, null, Instant.now(),
                null, null, null,
                List.of(new WorkoutLogEntry(1, publicExercise.getId(),
                        WorkoutLogEntryStatus.COMPLETED, Map.of(), Map.of(), null)));
        given(logRepository.findById(log.getId())).willReturn(Optional.of(log));

        assertThatThrownBy(() -> service.getOwned(log.getId(), STRANGER))
                .isInstanceOf(WorkoutLogNotFoundException.class);
    }
}
