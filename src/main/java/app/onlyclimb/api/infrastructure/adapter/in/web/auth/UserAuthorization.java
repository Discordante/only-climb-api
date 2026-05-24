package app.onlyclimb.api.infrastructure.adapter.in.web.auth;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Authorization helper exposed to {@code @PreAuthorize} expressions as
 * {@code @userAuthz}. Decides whether the current authentication may act on a
 * given user id.
 */
@Component("userAuthz")
@RequiredArgsConstructor
public class UserAuthorization {

    private static final String ROLE_ADMIN = "ROLE_ADMIN";

    private final UserRepository userRepository;

    /**
     * Returns {@code true} when the authenticated principal is either an admin
     * or the owner of the user identified by {@code pathUserId}.
     */
    public boolean isSelfOrAdmin(UUID pathUserId, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        if (hasAdminRole(authentication)) {
            return true;
        }
        if (pathUserId == null) {
            return false;
        }
        return currentUserId(authentication)
                .map(currentId -> currentId.equals(pathUserId))
                .orElse(false);
    }

    private boolean hasAdminRole(Authentication authentication) {
        return authentication.getAuthorities().stream()
                .anyMatch(a -> ROLE_ADMIN.equals(a.getAuthority()));
    }

    private java.util.Optional<UUID> currentUserId(Authentication authentication) {
        if (!(authentication instanceof JwtAuthenticationToken jwt)) {
            return java.util.Optional.empty();
        }
        String externalId = jwt.getToken().getSubject();
        if (externalId == null || externalId.isBlank()) {
            return java.util.Optional.empty();
        }
        return userRepository.findByAuthIdentity(AuthProvider.CLERK, externalId)
                .map(user -> user.getId());
    }
}
