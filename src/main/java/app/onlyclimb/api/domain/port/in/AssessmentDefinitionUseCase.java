package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;

import java.util.List;
import java.util.UUID;

public interface AssessmentDefinitionUseCase {

    /**
     * @param discipline optional filter; null returns all active definitions.
     */
    List<AssessmentDefinition> listActive(ClimbingDiscipline discipline);

    AssessmentDefinition getById(UUID id);
}
