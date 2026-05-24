package app.onlyclimb.api.infrastructure.adapter.in.web.auth;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.port.out.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;

@ExtendWith(MockitoExtension.class)
class UserAuthorizationTest {

    @Mock UserRepository userRepository;

    @InjectMocks UserAuthorization userAuthorization;

    @Test
    void deniesWhenAuthenticationIsNull() {
        assertThat(userAuthorization.isSelfOrAdmin(UUID.randomUUID(), null)).isFalse();
    }

    @Test
    void deniesAnonymous() {
        Authentication anon = new AnonymousAuthenticationToken(
                "key", "anon", List.of(new SimpleGrantedAuthority("ROLE_ANONYMOUS")));
        anon.setAuthenticated(false);
        assertThat(userAuthorization.isSelfOrAdmin(UUID.randomUUID(), anon)).isFalse();
    }

    @Test
    void allowsAdminWithoutCheckingRepository() {
        Authentication adminAuth = jwtAuth("admin-sub", "ROLE_ADMIN");
        assertThat(userAuthorization.isSelfOrAdmin(UUID.randomUUID(), adminAuth)).isTrue();
    }

    @Test
    void allowsSelf() {
        UUID id = UUID.randomUUID();
        Instant now = Instant.now();
        User user = new User(
                id, AuthProvider.CLERK, "ext-1", new Email("u@example.com"),
                app.onlyclimb.api.domain.model.UserRole.USER, now, now, null, null);
        given(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-1"))
                .willReturn(Optional.of(user));

        assertThat(userAuthorization.isSelfOrAdmin(id, jwtAuth("ext-1", "ROLE_USER"))).isTrue();
    }

    @Test
    void deniesNonOwnerNonAdmin() {
        given(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-2"))
                .willReturn(Optional.empty());

        assertThat(userAuthorization.isSelfOrAdmin(UUID.randomUUID(), jwtAuth("ext-2", "ROLE_USER")))
                .isFalse();
    }

    private static Authentication jwtAuth(String subject, String role) {
        Jwt jwt = Jwt.withTokenValue("token")
                .header("alg", "none")
                .subject(subject)
                .issuedAt(Instant.now())
                .expiresAt(Instant.now().plusSeconds(60))
                .build();
        return new JwtAuthenticationToken(jwt, List.of(new SimpleGrantedAuthority(role)), subject);
    }
}
