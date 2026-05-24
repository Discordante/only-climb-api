package app.onlyclimb.api.infrastructure.adapter.in.web.user;

import app.onlyclimb.api.domain.port.in.GetUserProfileUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileCommand;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileUseCase;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.RegisterUserRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UpdateUserProfileRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UserProfileResponse;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UserResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "Account & profile management")
public class UserController {

    private final RegisterUserUseCase registerUserUseCase;
    private final GetUserUseCase getUserUseCase;
    private final GetUserProfileUseCase getUserProfileUseCase;
    private final UpdateUserProfileUseCase updateUserProfileUseCase;

    @PostMapping
    @Operation(summary = "Register or refresh the current authenticated user (idempotent)")
    public ResponseEntity<UserResponse> register(@Valid @RequestBody RegisterUserRequest request) {
        var user = registerUserUseCase.register(new RegisterUserCommand(
                request.authProvider(),
                request.externalUserId(),
                request.email()
        ));
        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.from(user));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Find a user by UUID")
    public ResponseEntity<UserResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(UserResponse.from(getUserUseCase.getById(id)));
    }

    @GetMapping("/{id}/profile")
    @Operation(summary = "Get a user's profile")
    public ResponseEntity<UserProfileResponse> getProfile(@PathVariable UUID id) {
        return ResponseEntity.ok(UserProfileResponse.from(getUserProfileUseCase.getByUserId(id)));
    }

    @PutMapping("/{id}/profile")
    @Operation(summary = "Update a user's profile")
    public ResponseEntity<UserProfileResponse> updateProfile(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateUserProfileRequest request
    ) {
        var profile = updateUserProfileUseCase.updateProfile(id, new UpdateUserProfileCommand(
                request.displayName(),
                request.weightKg(),
                request.heightCm(),
                request.primaryDiscipline(),
                request.locale()
        ));
        return ResponseEntity.ok(UserProfileResponse.from(profile));
    }
}
