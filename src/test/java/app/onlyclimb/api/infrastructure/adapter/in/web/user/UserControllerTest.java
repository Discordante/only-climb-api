package app.onlyclimb.api.infrastructure.adapter.in.web.user;

import app.onlyclimb.api.domain.exception.UserNotFoundException;
import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.port.in.GetUserProfileUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import app.onlyclimb.api.domain.port.in.UpdateUserProfileUseCase;
import app.onlyclimb.api.infrastructure.adapter.in.web.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(UserController.class)
@Import(GlobalExceptionHandler.class)
class UserControllerTest {

    @Autowired MockMvc mockMvc;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @MockitoBean RegisterUserUseCase registerUserUseCase;
    @MockitoBean GetUserUseCase getUserUseCase;
    @MockitoBean GetUserProfileUseCase getUserProfileUseCase;
    @MockitoBean UpdateUserProfileUseCase updateUserProfileUseCase;

    @Test
    void registerReturns201() throws Exception {
        User user = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(registerUserUseCase.register(any())).thenReturn(user);

        var body = Map.of(
                "authProvider", "CLERK",
                "externalUserId", "ext-1",
                "email", "alice@example.com");

        mockMvc.perform(post("/api/v1/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.email").value("alice@example.com"))
                .andExpect(jsonPath("$.role").value("USER"));
    }

    @Test
    void registerReturns400OnValidationError() throws Exception {
        var body = Map.of(
                "authProvider", "CLERK",
                "externalUserId", "",
                "email", "not-an-email");

        mockMvc.perform(post("/api/v1/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getByIdReturns404WhenMissing() throws Exception {
        UUID id = UUID.randomUUID();
        when(getUserUseCase.getById(id)).thenThrow(new UserNotFoundException(id));

        mockMvc.perform(get("/api/v1/users/{id}", id))
                .andExpect(status().isNotFound());
    }
}
