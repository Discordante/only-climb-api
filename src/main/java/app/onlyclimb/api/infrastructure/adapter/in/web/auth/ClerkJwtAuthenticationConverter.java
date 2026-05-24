package app.onlyclimb.api.infrastructure.adapter.in.web.auth;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import app.onlyclimb.api.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

/**
 * Converts a verified Clerk JWT into a Spring {@link JwtAuthenticationToken}, and
 * performs Just-In-Time provisioning of the local {@code User} aggregate.
 *
 * <p>Webhooks are the canonical provisioning channel; JIT exists as a defensive
 * fallback for the case where the webhook has not yet been processed (or the
 * webhook configuration is missing). JIT requires the JWT to carry an
 * {@code email} claim — configure a JWT template in Clerk that adds
 * {@code "email": "{{user.primary_email_address}}"}.</p>
 *
 * <p>Authorities are derived from the local {@code UserRole} as
 * {@code ROLE_<NAME>} so that {@code @PreAuthorize("hasRole('ADMIN')")} works.
 * If JIT cannot run (missing email and no existing local user), the token is
 * still authenticated but has no role authorities — protected endpoints that
 * depend on the local user will fail with 403 via {@code @PreAuthorize}.</p>
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class ClerkJwtAuthenticationConverter
        implements Converter<Jwt, AbstractAuthenticationToken> {

    private final UserRepository userRepository;
    private final RegisterUserUseCase registerUserUseCase;

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        String externalId = jwt.getSubject();
        if (externalId == null || externalId.isBlank()) {
            return new JwtAuthenticationToken(jwt, List.of());
        }

        Optional<User> existing = userRepository.findByAuthIdentity(AuthProvider.CLERK, externalId);
        User user = existing.orElseGet(() -> jitProvision(jwt, externalId));

        if (user == null || !user.isActive()) {
            // Authenticated by Clerk but no usable local user — empty authorities.
            return new JwtAuthenticationToken(jwt, List.of(), externalId);
        }

        List<GrantedAuthority> authorities = List.of(
                new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
        return new JwtAuthenticationToken(jwt, authorities, externalId);
    }

    private User jitProvision(Jwt jwt, String externalId) {
        String email = jwt.getClaimAsString("email");
        if (email == null || email.isBlank()) {
            log.warn("JIT provisioning skipped for sub={}: missing 'email' claim. "
                    + "Configure a Clerk JWT template that includes email, or rely on the webhook.",
                    externalId);
            return null;
        }
        try {
            return registerUserUseCase.register(new RegisterUserCommand(
                    AuthProvider.CLERK, externalId, email));
        } catch (RuntimeException ex) {
            log.warn("JIT provisioning failed for sub={}: {}", externalId, ex.getMessage());
            return null;
        }
    }
}
