package app.onlyclimb.api.infrastructure.adapter.in.web.user;

import app.onlyclimb.api.domain.exception.UserNotFoundException;
import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.port.in.GetUserProfileUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileUseCase;
import app.onlyclimb.api.domain.port.out.UserRepository;
import app.onlyclimb.api.infrastructure.adapter.in.web.GlobalExceptionHandler;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.ClerkJwtAuthenticationConverter;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.CurrentUserService;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.UserAuthorization;
import app.onlyclimb.api.infrastructure.config.SecurityConfig;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(UserController.class)
@Import({
        GlobalExceptionHandler.class,
        SecurityConfig.class,
        UserAuthorization.class,
        CurrentUserService.class
})
class UserControllerTest {

    @Autowired MockMvc mockMvc;

    @MockitoBean GetUserUseCase getUserUseCase;
    @MockitoBean GetUserProfileUseCase getUserProfileUseCase;
    @MockitoBean UpdateUserProfileUseCase updateUserProfileUseCase;
    @MockitoBean ClerkJwtAuthenticationConverter clerkJwtAuthenticationConverter;
    @MockitoBean UserRepository userRepository;

    @Test
    void unauthenticatedRequestIsRejected() throws Exception {
        mockMvc.perform(get("/api/v1/users/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void getMeReturnsAuthenticatedUser() throws Exception {
        User user = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(user);

        mockMvc.perform(get("/api/v1/users/me")
                        .with(jwt().jwt(j -> j.subject("ext-1").claim("email", "alice@example.com"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("alice@example.com"))
                .andExpect(jsonPath("$.role").value("USER"));
    }

    @Test
    void getByIdAsAdminReturnsNotFoundWhenMissing() throws Exception {
        UUID id = UUID.randomUUID();
        when(getUserUseCase.getById(id)).thenThrow(new UserNotFoundException(id));

        mockMvc.perform(get("/api/v1/users/{id}", id)
                        .with(jwt().jwt(j -> j.subject("admin-ext"))
                                .authorities(new SimpleGrantedAuthority("ROLE_ADMIN"))))
                .andExpect(status().isNotFound());
    }

    @Test
    void getByIdAsOtherUserIsForbidden() throws Exception {
        UUID otherId = UUID.randomUUID();
        when(userRepository.findByAuthIdentity(any(), any())).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/v1/users/{id}", otherId)
                        .with(jwt().jwt(j -> j.subject("ext-other"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isForbidden());
    }
}
