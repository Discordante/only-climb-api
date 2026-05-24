package app.onlyclimb.api.infrastructure.adapter.in.web.webhook;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.port.in.DeleteUserUseCase;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import app.onlyclimb.api.infrastructure.adapter.in.web.GlobalExceptionHandler;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.ClerkJwtAuthenticationConverter;
import app.onlyclimb.api.infrastructure.config.SecurityConfig;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ClerkWebhookController.class)
@Import({GlobalExceptionHandler.class, SecurityConfig.class})
class ClerkWebhookControllerTest {

    @Autowired MockMvc mockMvc;

    @MockitoBean SvixSignatureVerifier signatureVerifier;
    @MockitoBean RegisterUserUseCase registerUserUseCase;
    @MockitoBean DeleteUserUseCase deleteUserUseCase;
    @MockitoBean ClerkJwtAuthenticationConverter clerkJwtAuthenticationConverter;

    @Test
    void rejectsInvalidSignatureWith401() throws Exception {
        given(signatureVerifier.verify(eq("id-1"), eq("123"), eq("v1,bad"), org.mockito.ArgumentMatchers.any()))
                .willReturn(false);

        mockMvc.perform(post("/api/v1/webhooks/clerk")
                        .header("svix-id", "id-1")
                        .header("svix-timestamp", "123")
                        .header("svix-signature", "v1,bad")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"user.created\"}"))
                .andExpect(status().isUnauthorized());

        then(registerUserUseCase).should(never()).register(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void userCreatedTriggersRegister() throws Exception {
        given(signatureVerifier.verify(org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any())).willReturn(true);

        String body = """
                {
                  "type": "user.created",
                  "data": {
                    "id": "user_abc",
                    "primary_email_address_id": "ema_1",
                    "email_addresses": [
                      {"id": "ema_1", "email_address": "alice@example.com"},
                      {"id": "ema_2", "email_address": "alt@example.com"}
                    ]
                  }
                }
                """;

        mockMvc.perform(post("/api/v1/webhooks/clerk")
                        .header("svix-id", "id-1")
                        .header("svix-timestamp", "123")
                        .header("svix-signature", "v1,ok")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk());

        ArgumentCaptor<RegisterUserCommand> cmd = ArgumentCaptor.forClass(RegisterUserCommand.class);
        then(registerUserUseCase).should().register(cmd.capture());
        assertThat(cmd.getValue().authProvider()).isEqualTo(AuthProvider.CLERK);
        assertThat(cmd.getValue().externalUserId()).isEqualTo("user_abc");
        assertThat(cmd.getValue().email()).isEqualTo("alice@example.com");
    }

    @Test
    void userDeletedTriggersDelete() throws Exception {
        given(signatureVerifier.verify(org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any())).willReturn(true);

        String body = "{\"type\":\"user.deleted\",\"data\":{\"id\":\"user_abc\"}}";

        mockMvc.perform(post("/api/v1/webhooks/clerk")
                        .header("svix-id", "id-1")
                        .header("svix-timestamp", "123")
                        .header("svix-signature", "v1,ok")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk());

        then(deleteUserUseCase).should().deleteByAuthIdentity(AuthProvider.CLERK, "user_abc");
    }

    @Test
    void unknownEventTypeIsAcknowledgedWithoutSideEffects() throws Exception {
        given(signatureVerifier.verify(org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any())).willReturn(true);

        mockMvc.perform(post("/api/v1/webhooks/clerk")
                        .header("svix-id", "id-1")
                        .header("svix-timestamp", "123")
                        .header("svix-signature", "v1,ok")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"session.created\",\"data\":{}}"))
                .andExpect(status().isOk());

        then(registerUserUseCase).should(never()).register(org.mockito.ArgumentMatchers.any());
        then(deleteUserUseCase).should(never())
                .deleteByAuthIdentity(org.mockito.ArgumentMatchers.any(), org.mockito.ArgumentMatchers.any());
    }
}
