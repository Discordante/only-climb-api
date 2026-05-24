package app.onlyclimb.api.domain.exception;

import java.util.UUID;

public class UserNotFoundException extends RuntimeException {

    public UserNotFoundException(UUID id) {
        super("User not found: " + id);
    }

    public UserNotFoundException(String externalUserId) {
        super("User not found: external id " + externalUserId);
    }
}
