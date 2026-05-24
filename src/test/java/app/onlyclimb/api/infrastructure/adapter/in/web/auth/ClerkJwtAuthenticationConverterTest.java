package app.onlyclimb.api.infrastructure.adapter.in.web.auth;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.UserRole;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import app.onlyclimb.api.domain.port.out.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.oauth2.jwt.Jwt;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;

@ExtendWith(MockitoExtension.class)
class ClerkJwtAuthenticationConverterTest {

    @Mock UserRepository userRepository;
    @Mock RegisterUserUseCase registerUserUseCase;

    @InjectMocks ClerkJwtAuthenticationConverter converter;

    @Test
    void mapsExistingUserRoleToAuthority() {
        UUID id = UUID.randomUUID();
        Instant now = Instant.now();
        User admin = new User(
                id, AuthProvider.CLERK, "ext-admin", new Email("a@example.com"),
                UserRole.ADMIN, now, now, null, null);
        given(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-admin"))
                .willReturn(Optional.of(admin));

        AbstractAuthenticationToken token = converter.convert(jwt("ext-admin", null));

        assertThat(token.getAuthorities())
                .extracting("authority")
                .containsExactly("ROLE_ADMIN");
        then(registerUserUseCase).should(never()).register(any());
    }

    @Test
    void jitProvisionsNewUserWhenEmailClaimPresent() {
        given(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-new"))
                .willReturn(Optional.empty());
        Instant now = Instant.now();
        User created = new User(
                UUID.randomUUID(), AuthProvider.CLERK, "ext-new", new Email("n@example.com"),
                UserRole.USER, now, now, null, null);
        given(registerUserUseCase.register(any())).willReturn(created);

        AbstractAuthenticationToken token = converter.convert(jwt("ext-new", "n@example.com"));

        assertThat(token.getAuthorities()).extracting("authority").containsExactly("ROLE_USER");
        ArgumentCaptor<RegisterUserCommand> cmd = ArgumentCaptor.forClass(RegisterUserCommand.class);
        then(registerUserUseCase).should().register(cmd.capture());
        assertThat(cmd.getValue().externalUserId()).isEqualTo("ext-new");
        assertThat(cmd.getValue().email()).isEqualTo("n@example.com");
    }

    @Test
    void returnsTokenWithoutAuthoritiesWhenNoLocalUserAndNoEmail() {
        given(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-no-email"))
                .willReturn(Optional.empty());

        AbstractAuthenticationToken token = converter.convert(jwt("ext-no-email", null));

        assertThat(token.getAuthorities()).isEmpty();
        then(registerUserUseCase).should(never()).register(any());
    }

    private static Jwt jwt(String subject, String email) {
        Jwt.Builder b = Jwt.withTokenValue("token")
                .header("alg", "none")
                .subject(subject)
                .issuedAt(Instant.now())
                .expiresAt(Instant.now().plusSeconds(60));
        if (email != null) {
            b.claim("email", email);
        }
        return b.build();
    }

    private static <T> T any() {
        return org.mockito.ArgumentMatchers.any();
    }
}
