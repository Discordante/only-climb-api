package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.exception.AssessmentDefinitionNotFoundException;
import app.onlyclimb.api.domain.exception.AssessmentResultNotFoundException;
import app.onlyclimb.api.domain.exception.ContentOwnershipException;
import app.onlyclimb.api.domain.exception.InvalidAssessmentResultException;
import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.AssessmentMetric;
import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;
import app.onlyclimb.api.domain.port.in.AssessmentDefinitionUseCase;
import app.onlyclimb.api.domain.port.in.AssessmentMetricInput;
import app.onlyclimb.api.domain.port.in.DeleteAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.in.GetAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.in.ListAssessmentResultsQuery;
import app.onlyclimb.api.domain.port.in.ListAssessmentResultsUseCase;
import app.onlyclimb.api.domain.port.in.RecordAssessmentResultCommand;
import app.onlyclimb.api.domain.port.in.RecordAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.out.AssessmentDefinitionRepository;
import app.onlyclimb.api.domain.port.out.AssessmentResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AssessmentService implements
        AssessmentDefinitionUseCase,
        RecordAssessmentResultUseCase,
        ListAssessmentResultsUseCase,
        GetAssessmentResultUseCase,
        DeleteAssessmentResultUseCase {

    private final AssessmentDefinitionRepository definitionRepository;
    private final AssessmentResultRepository resultRepository;

    @Override
    public List<AssessmentDefinition> listActive(ClimbingDiscipline discipline) {
        return definitionRepository.findActive(discipline);
    }

    @Override
    public AssessmentDefinition getById(UUID id) {
        if (id == null) {
            throw new AssessmentDefinitionNotFoundException((UUID) null);
        }
        return definitionRepository.findById(id)
                .filter(AssessmentDefinition::isActive)
                .orElseThrow(() -> new AssessmentDefinitionNotFoundException(id));
    }

    @Override
    @Transactional
    public AssessmentResult record(RecordAssessmentResultCommand command) {
        AssessmentDefinition definition = definitionRepository.findById(command.definitionId())
                .filter(AssessmentDefinition::isActive)
                .orElseThrow(() -> new AssessmentDefinitionNotFoundException(command.definitionId()));

        if (command.metrics() == null || command.metrics().isEmpty()) {
            throw new InvalidAssessmentResultException("at least one metric is required");
        }

        Set<UUID> definitionTestIds = definition.testIds();
        Set<UUID> seen = new LinkedHashSet<>();
        List<AssessmentMetric> metrics = new ArrayList<>(command.metrics().size());
        for (AssessmentMetricInput input : command.metrics()) {
            if (input.testId() == null) {
                throw new InvalidAssessmentResultException("metric testId is required");
            }
            if (input.numericValue() == null) {
                throw new InvalidAssessmentResultException("metric numericValue is required");
            }
            if (!definitionTestIds.contains(input.testId())) {
                throw new InvalidAssessmentResultException(
                        "test " + input.testId() + " does not belong to definition "
                                + definition.getId());
            }
            if (!seen.add(input.testId())) {
                throw new InvalidAssessmentResultException(
                        "duplicate metric for test " + input.testId());
            }
            metrics.add(new AssessmentMetric(input.testId(), input.numericValue()));
        }

        AssessmentResult result = AssessmentResult.create(
                command.ownerId(),
                definition.getId(),
                command.performedAt(),
                command.userWeightKg(),
                command.notes(),
                metrics);
        return resultRepository.save(result);
    }

    @Override
    public AssessmentResultRepository.Page<AssessmentResult> list(ListAssessmentResultsQuery query) {
        return resultRepository.search(query);
    }

    @Override
    public AssessmentResult getOwned(UUID resultId, UUID callerId) {
        return requireOwned(resultId, callerId);
    }

    @Override
    @Transactional
    public void delete(UUID resultId, UUID callerId) {
        AssessmentResult result = resultRepository.findById(resultId)
                .orElseThrow(() -> new AssessmentResultNotFoundException(resultId));
        try {
            result.assertOwnedBy(callerId);
        } catch (ContentOwnershipException ex) {
            // Hide existence from non-owners.
            throw new AssessmentResultNotFoundException(resultId);
        }
        resultRepository.deleteById(resultId);
    }

    private AssessmentResult requireOwned(UUID resultId, UUID callerId) {
        AssessmentResult result = resultRepository.findById(resultId)
                .orElseThrow(() -> new AssessmentResultNotFoundException(resultId));
        if (callerId == null || !callerId.equals(result.getOwnerId())) {
            throw new AssessmentResultNotFoundException(resultId);
        }
        return result;
    }
}
