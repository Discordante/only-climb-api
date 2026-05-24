package app.onlyclimb.api.infrastructure.adapter.in.web.user.dto;

import app.onlyclimb.api.domain.model.AuthProvider;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record RegisterUserRequest(
        @NotNull AuthProvider authProvider,
        @NotBlank @Size(max = 255) String externalUserId,
        @NotBlank @Email @Size(max = 320) String email
) {}
