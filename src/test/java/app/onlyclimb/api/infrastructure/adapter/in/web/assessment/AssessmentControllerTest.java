package app.onlyclimb.api.infrastructure.adapter.in.web.assessment;

import app.onlyclimb.api.domain.exception.AssessmentDefinitionNotFoundException;
import app.onlyclimb.api.domain.exception.InvalidAssessmentResultException;
import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.AssessmentMetric;
import app.onlyclimb.api.domain.model.AssessmentResult;
import app.onlyclimb.api.domain.model.AssessmentTest;
import app.onlyclimb.api.domain.model.AssessmentValueType;
import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.port.in.AssessmentDefinitionUseCase;
import app.onlyclimb.api.domain.port.in.DeleteAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.in.GetAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.ListAssessmentResultsUseCase;
import app.onlyclimb.api.domain.port.in.RecordAssessmentResultUseCase;
import app.onlyclimb.api.domain.port.out.AssessmentResultRepository;
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
import org.springframework.http.MediaType;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AssessmentController.class)
@Import({
        GlobalExceptionHandler.class,
        SecurityConfig.class,
        UserAuthorization.class,
        CurrentUserService.class
})
class AssessmentControllerTest {

    @Autowired MockMvc mockMvc;

    @MockitoBean AssessmentDefinitionUseCase definitionUseCase;
    @MockitoBean RecordAssessmentResultUseCase recordUseCase;
    @MockitoBean ListAssessmentResultsUseCase listUseCase;
    @MockitoBean GetAssessmentResultUseCase getUseCase;
    @MockitoBean DeleteAssessmentResultUseCase deleteUseCase;
    @MockitoBean GetUserUseCase getUserUseCase;
    @MockitoBean UserRepository userRepository;
    @MockitoBean ClerkJwtAuthenticationConverter clerkJwtAuthenticationConverter;

    private User authenticate() {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);
        return caller;
    }

    private AssessmentDefinition aDefinition(UUID id, UUID testId) {
        return new AssessmentDefinition(
                id, "DEF", null, true,
                List.of(new AssessmentTest(testId, "T1", 1, "kg",
                        AssessmentValueType.DECIMAL,
                        List.of(new Translation("en", "name", "Test 1")))),
                List.of(new Translation("en", "name", "My definition")),
                Instant.now(), Instant.now());
    }

    // -- Definitions ---------------------------------------------------------

    @Test
    void listDefinitions_unauthenticated_returnsData() throws Exception {
        // Definitions endpoint is read-only; security still requires auth on /api/v1/**.
        mockMvc.perform(get("/api/v1/assessments/definitions"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void listDefinitions_authenticated_returnsLocalizedData() throws Exception {
        authenticate();
        UUID defId = UUID.randomUUID();
        UUID testId = UUID.randomUUID();
        when(definitionUseCase.listActive(any())).thenReturn(List.of(aDefinition(defId, testId)));

        mockMvc.perform(get("/api/v1/assessments/definitions")
                        .header("Accept-Language", "en")
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(defId.toString()))
                .andExpect(jsonPath("$[0].name").value("My definition"))
                .andExpect(jsonPath("$[0].tests[0].name").value("Test 1"));
    }

    @Test
    void getDefinition_missing_returns404() throws Exception {
        authenticate();
        UUID id = UUID.randomUUID();
        when(definitionUseCase.getById(id))
                .thenThrow(new AssessmentDefinitionNotFoundException(id));

        mockMvc.perform(get("/api/v1/assessments/definitions/" + id)
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isNotFound());
    }

    // -- Results -------------------------------------------------------------

    @Test
    void recordResult_success_returns201WithLocation() throws Exception {
        User caller = authenticate();
        UUID defId = UUID.randomUUID();
        UUID testId = UUID.randomUUID();
        AssessmentResult created = AssessmentResult.create(
                caller.getId(), defId, Instant.parse("2024-05-01T10:00:00Z"),
                new BigDecimal("70.5"), null,
                List.of(new AssessmentMetric(testId, new BigDecimal("42.0"))));
        when(recordUseCase.record(any())).thenReturn(created);

        String body = """
                {
                  "definitionId": "%s",
                  "performedAt": "2024-05-01T10:00:00Z",
                  "userWeightKg": 70.5,
                  "metrics": [{"testId": "%s", "numericValue": 42.0}]
                }
                """.formatted(defId, testId);

        mockMvc.perform(post("/api/v1/assessments/results")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body)
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isCreated())
                .andExpect(header().string("Location",
                        "/api/v1/assessments/results/" + created.getId()))
                .andExpect(jsonPath("$.definitionId").value(defId.toString()));
    }

    @Test
    void recordResult_validationError_returns400() throws Exception {
        authenticate();
        // missing metrics
        String body = """
                {
                  "definitionId": "%s",
                  "performedAt": "2024-05-01T10:00:00Z"
                }
                """.formatted(UUID.randomUUID());

        mockMvc.perform(post("/api/v1/assessments/results")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body)
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isBadRequest());
    }

    @Test
    void recordResult_invalidDomain_returns400() throws Exception {
        authenticate();
        UUID defId = UUID.randomUUID();
        UUID testId = UUID.randomUUID();
        when(recordUseCase.record(any()))
                .thenThrow(new InvalidAssessmentResultException("nope"));

        String body = """
                {
                  "definitionId": "%s",
                  "performedAt": "2024-05-01T10:00:00Z",
                  "metrics": [{"testId": "%s", "numericValue": 1.0}]
                }
                """.formatted(defId, testId);

        mockMvc.perform(post("/api/v1/assessments/results")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body)
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listResults_returnsPage() throws Exception {
        User caller = authenticate();
        UUID defId = UUID.randomUUID();
        UUID testId = UUID.randomUUID();
        AssessmentResult r = AssessmentResult.create(
                caller.getId(), defId, Instant.now(), null, null,
                List.of(new AssessmentMetric(testId, BigDecimal.ONE)));
        when(listUseCase.list(any()))
                .thenReturn(new AssessmentResultRepository.Page<>(List.of(r), "cur"));

        mockMvc.perform(get("/api/v1/assessments/results")
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nextCursor").value("cur"))
                .andExpect(jsonPath("$.data[0].id").value(r.getId().toString()));
    }

    @Test
    void deleteResult_returns204() throws Exception {
        authenticate();
        mockMvc.perform(delete("/api/v1/assessments/results/" + UUID.randomUUID())
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isNoContent());
    }
}
