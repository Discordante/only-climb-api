package app.onlyclimb.api.infrastructure.adapter.in.web.user.dto;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.UserRole;

import java.time.Instant;
import java.util.UUID;

public record UserResponse(
        UUID id,
        AuthProvider authProvider,
        String externalUserId,
        String email,
        UserRole role,
        Instant createdAt,
        Instant lastLoginAt
) {
    public static UserResponse from(User user) {
        return new UserResponse(
                user.getId(),
                user.getAuthProvider(),
                user.getExternalUserId(),
                user.getEmail().value(),
                user.getRole(),
                user.getCreatedAt(),
                user.getLastLoginAt().orElse(null)
        );
    }
}
