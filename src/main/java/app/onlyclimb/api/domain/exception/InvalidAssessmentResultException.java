package app.onlyclimb.api.domain.exception;

/**
 * Thrown when an attempt to record an assessment result violates structural
 * invariants (unknown tests, duplicated tests, missing values, ...).
 */
public class InvalidAssessmentResultException extends RuntimeException {
    public InvalidAssessmentResultException(String message) {
        super(message);
    }
}
