package app.onlyclimb.api.domain.exception;

import java.util.UUID;

public class AssessmentResultNotFoundException extends RuntimeException {
    public AssessmentResultNotFoundException(UUID id) {
        super("Assessment result not found: " + id);
    }
}
