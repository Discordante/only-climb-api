package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface AssessmentDefinitionRepository {

    Optional<AssessmentDefinition> findById(UUID id);

    /**
     * @param discipline optional filter; null returns all active definitions.
     */
    List<AssessmentDefinition> findActive(ClimbingDiscipline discipline);
}
