package app.onlyclimb.api.infrastructure.adapter.in.web.user;

import app.onlyclimb.api.domain.port.in.GetUserProfileUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileCommand;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileUseCase;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.CurrentUserService;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UpdateUserProfileRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UserProfileResponse;
import app.onlyclimb.api.infrastructure.adapter.in.web.user.dto.UserResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

/**
 * User &amp; profile endpoints.
 *
 * <p>User creation/deletion is not exposed: identities are owned by Clerk and
 * provisioned via {@code /api/v1/webhooks/clerk} (canonical) or JIT on the
 * first authenticated request.</p>
 *
 * <p>{@code /me} endpoints resolve the local user from the JWT subject. The
 * {@code /{id}} endpoints require admin role or self-ownership.</p>
 */
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "Account & profile management")
public class UserController {

    private final GetUserUseCase getUserUseCase;
    private final GetUserProfileUseCase getUserProfileUseCase;
    private final UpdateUserProfileUseCase updateUserProfileUseCase;
    private final CurrentUserService currentUserService;

    // ----- /me (self-service) -----

    @GetMapping("/me")
    @Operation(summary = "Return the authenticated user")
    public ResponseEntity<UserResponse> getMe(Authentication authentication) {
        return ResponseEntity.ok(UserResponse.from(currentUserService.requireCurrent(authentication)));
    }

    @GetMapping("/me/profile")
    @Operation(summary = "Return the authenticated user's profile")
    public ResponseEntity<UserProfileResponse> getMyProfile(Authentication authentication) {
        var me = currentUserService.requireCurrent(authentication);
        return ResponseEntity.ok(UserProfileResponse.from(getUserProfileUseCase.getByUserId(me.getId())));
    }

    @PutMapping("/me/profile")
    @Operation(summary = "Update the authenticated user's profile")
    public ResponseEntity<UserProfileResponse> updateMyProfile(
            Authentication authentication,
            @Valid @RequestBody UpdateUserProfileRequest request
    ) {
        var me = currentUserService.requireCurrent(authentication);
        var profile = updateUserProfileUseCase.updateProfile(me.getId(), toCommand(request));
        return ResponseEntity.ok(UserProfileResponse.from(profile));
    }

    // ----- /{id} (admin or self) -----

    @GetMapping("/{id}")
    @PreAuthorize("@userAuthz.isSelfOrAdmin(#id, authentication)")
    @Operation(summary = "Find a user by UUID (admin or self)")
    public ResponseEntity<UserResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(UserResponse.from(getUserUseCase.getById(id)));
    }

    @GetMapping("/{id}/profile")
    @PreAuthorize("@userAuthz.isSelfOrAdmin(#id, authentication)")
    @Operation(summary = "Get a user's profile (admin or self)")
    public ResponseEntity<UserProfileResponse> getProfile(@PathVariable UUID id) {
        return ResponseEntity.ok(UserProfileResponse.from(getUserProfileUseCase.getByUserId(id)));
    }

    @PutMapping("/{id}/profile")
    @PreAuthorize("@userAuthz.isSelfOrAdmin(#id, authentication)")
    @Operation(summary = "Update a user's profile (admin or self)")
    public ResponseEntity<UserProfileResponse> updateProfile(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateUserProfileRequest request
    ) {
        var profile = updateUserProfileUseCase.updateProfile(id, toCommand(request));
        return ResponseEntity.ok(UserProfileResponse.from(profile));
    }

    private static UpdateUserProfileCommand toCommand(UpdateUserProfileRequest request) {
        return new UpdateUserProfileCommand(
                request.displayName(),
                request.weightKg(),
                request.heightCm(),
                request.primaryDiscipline(),
                request.locale()
        );
    }
}
