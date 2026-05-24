package app.onlyclimb.api.domain.exception;

import java.util.UUID;

public class AssessmentDefinitionNotFoundException extends RuntimeException {
    public AssessmentDefinitionNotFoundException(UUID id) {
        super("Assessment definition not found: " + id);
    }

    public AssessmentDefinitionNotFoundException(String code) {
        super("Assessment definition not found: " + code);
    }
}
