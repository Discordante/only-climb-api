package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AuthProvider;

public record RegisterUserCommand(
        AuthProvider authProvider,
        String externalUserId,
        String email
) {}
