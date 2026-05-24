package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.exception.AssessmentDefinitionNotFoundException;
import app.onlyclimb.api.domain.exception.AssessmentResultNotFoundException;
import app.onlyclimb.api.domain.exception.InvalidAssessmentResultException;
import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.AssessmentMetric;
import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.model.AssessmentTest;
import app.onlyclimb.api.domain.model.AssessmentValueType;
import app.onlyclimb.api.domain.port.in.AssessmentMetricInput;
import app.onlyclimb.api.domain.port.in.RecordAssessmentResultCommand;
import app.onlyclimb.api.domain.port.out.AssessmentDefinitionRepository;
import app.onlyclimb.api.domain.port.out.AssessmentResultRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class AssessmentServiceTest {

    private static final UUID OWNER = UUID.randomUUID();
    private static final UUID STRANGER = UUID.randomUUID();
    private static final UUID DEF_ID = UUID.randomUUID();
    private static final UUID TEST_1 = UUID.randomUUID();
    private static final UUID TEST_2 = UUID.randomUUID();

    @Mock AssessmentDefinitionRepository definitionRepository;
    @Mock AssessmentResultRepository resultRepository;
    @InjectMocks AssessmentService service;

    private AssessmentDefinition definition(boolean active) {
        return new AssessmentDefinition(
                DEF_ID, "DEF", null, active,
                List.of(
                        new AssessmentTest(TEST_1, "A", 1, "kg",
                                AssessmentValueType.DECIMAL, List.of()),
                        new AssessmentTest(TEST_2, "B", 2, "s",
                                AssessmentValueType.INTEGER, List.of())),
                List.of(),
                Instant.now(), Instant.now());
    }

    @Test
    void getById_missing_throws() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.empty());
        assertThatThrownBy(() -> service.getById(DEF_ID))
                .isInstanceOf(AssessmentDefinitionNotFoundException.class);
    }

    @Test
    void getById_inactive_throws() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.of(definition(false)));
        assertThatThrownBy(() -> service.getById(DEF_ID))
                .isInstanceOf(AssessmentDefinitionNotFoundException.class);
    }

    @Test
    void record_unknownDefinition_throws() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.empty());
        assertThatThrownBy(() -> service.record(new RecordAssessmentResultCommand(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(new AssessmentMetricInput(TEST_1, BigDecimal.ONE)))))
                .isInstanceOf(AssessmentDefinitionNotFoundException.class);
        verify(resultRepository, never()).save(any());
    }

    @Test
    void record_unknownTestId_throws() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.of(definition(true)));
        assertThatThrownBy(() -> service.record(new RecordAssessmentResultCommand(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(new AssessmentMetricInput(UUID.randomUUID(), BigDecimal.ONE)))))
                .isInstanceOf(InvalidAssessmentResultException.class);
    }

    @Test
    void record_duplicateTestId_throws() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.of(definition(true)));
        assertThatThrownBy(() -> service.record(new RecordAssessmentResultCommand(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(
                        new AssessmentMetricInput(TEST_1, BigDecimal.ONE),
                        new AssessmentMetricInput(TEST_1, BigDecimal.TEN)))))
                .isInstanceOf(InvalidAssessmentResultException.class);
    }

    @Test
    void record_success_savesResult() {
        given(definitionRepository.findById(DEF_ID)).willReturn(Optional.of(definition(true)));
        given(resultRepository.save(any())).willAnswer(inv -> inv.getArgument(0));

        AssessmentResult created = service.record(new RecordAssessmentResultCommand(
                OWNER, DEF_ID, Instant.now(), new BigDecimal("72.5"), "felt strong",
                List.of(
                        new AssessmentMetricInput(TEST_1, new BigDecimal("45.5")),
                        new AssessmentMetricInput(TEST_2, new BigDecimal("7")))));

        assertThat(created.getOwnerId()).isEqualTo(OWNER);
        assertThat(created.getDefinitionId()).isEqualTo(DEF_ID);
        assertThat(created.getMetrics())
                .extracting(AssessmentMetric::testId)
                .containsExactly(TEST_1, TEST_2);
    }

    @Test
    void getOwned_strangerSees404() {
        UUID id = UUID.randomUUID();
        AssessmentResult owned = AssessmentResult.create(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(new AssessmentMetric(TEST_1, BigDecimal.ONE)));
        given(resultRepository.findById(owned.getId())).willReturn(Optional.of(owned));

        assertThatThrownBy(() -> service.getOwned(owned.getId(), STRANGER))
                .isInstanceOf(AssessmentResultNotFoundException.class);

        given(resultRepository.findById(id)).willReturn(Optional.empty());
        assertThatThrownBy(() -> service.getOwned(id, OWNER))
                .isInstanceOf(AssessmentResultNotFoundException.class);
    }

    @Test
    void delete_owner_invokesRepository() {
        AssessmentResult owned = AssessmentResult.create(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(new AssessmentMetric(TEST_1, BigDecimal.ONE)));
        given(resultRepository.findById(owned.getId())).willReturn(Optional.of(owned));

        service.delete(owned.getId(), OWNER);
        verify(resultRepository).deleteById(owned.getId());
    }

    @Test
    void delete_stranger_throwsNotFound() {
        AssessmentResult owned = AssessmentResult.create(
                OWNER, DEF_ID, Instant.now(), null, null,
                List.of(new AssessmentMetric(TEST_1, BigDecimal.ONE)));
        given(resultRepository.findById(owned.getId())).willReturn(Optional.of(owned));

        assertThatThrownBy(() -> service.delete(owned.getId(), STRANGER))
                .isInstanceOf(AssessmentResultNotFoundException.class);
        verify(resultRepository, never()).deleteById(any());
    }
}
