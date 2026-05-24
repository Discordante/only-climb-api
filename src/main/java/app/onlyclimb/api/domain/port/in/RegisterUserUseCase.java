package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.User;

public interface RegisterUserUseCase {

    /**
     * Idempotent: if the user already exists for the given (authProvider, externalUserId),
     * the existing user is returned and {@code lastLoginAt} is refreshed. Otherwise a new
     * user (and empty profile) is created.
     */
    User register(RegisterUserCommand command);
}
