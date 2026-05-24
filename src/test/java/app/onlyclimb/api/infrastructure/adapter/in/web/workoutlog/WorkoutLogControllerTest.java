package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog;

import app.onlyclimb.api.domain.exception.InvalidExerciseConfigException;
import app.onlyclimb.api.domain.exception.WorkoutLogNotFoundException;
import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.ParameterType;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.model.WorkoutLogEntry;
import app.onlyclimb.api.domain.model.WorkoutLogEntryStatus;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.DeleteWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.GetWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsUseCase;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.out.UserRepository;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository;
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

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(WorkoutLogController.class)
@Import({
        GlobalExceptionHandler.class,
        SecurityConfig.class,
        UserAuthorization.class,
        CurrentUserService.class
})
class WorkoutLogControllerTest {

    @Autowired MockMvc mockMvc;

    @MockitoBean CreateWorkoutLogUseCase createUseCase;
    @MockitoBean UpdateWorkoutLogUseCase updateUseCase;
    @MockitoBean DeleteWorkoutLogUseCase deleteUseCase;
    @MockitoBean GetWorkoutLogUseCase getUseCase;
    @MockitoBean ListWorkoutLogsUseCase listUseCase;
    @MockitoBean GetUserUseCase getUserUseCase;
    @MockitoBean UserRepository userRepository;
    @MockitoBean ClerkJwtAuthenticationConverter clerkJwtAuthenticationConverter;

    private static final UUID EXERCISE_ID = UUID.randomUUID();

    private WorkoutLog sampleLog(UUID ownerId) {
        return WorkoutLog.create(
                ownerId, null, Instant.parse("2025-01-15T10:00:00Z"),
                40, 6, "ok",
                List.of(new WorkoutLogEntry(1, EXERCISE_ID,
                        WorkoutLogEntryStatus.COMPLETED,
                        Map.of(ParameterType.REPS, "5"),
                        Map.of(ParameterType.REPS, "4"),
                        null)));
    }

    @Test
    void listWithoutJwtIsUnauthorized() throws Exception {
        mockMvc.perform(get("/api/v1/workout-logs"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void listWithJwtReturnsData() throws Exception {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);
        when(listUseCase.list(any()))
                .thenReturn(new WorkoutLogRepository.Page<>(List.of(sampleLog(caller.getId())), null));

        mockMvc.perform(get("/api/v1/workout-logs")
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].perceivedEffort").value(6));
    }

    @Test
    void getByIdReturns404WhenMissing() throws Exception {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);
        UUID id = UUID.randomUUID();
        when(getUseCase.getOwned(any(), any())).thenThrow(new WorkoutLogNotFoundException(id));

        mockMvc.perform(get("/api/v1/workout-logs/{id}", id)
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isNotFound());
    }

    @Test
    void postWithJwtCreatesLog() throws Exception {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);
        when(createUseCase.create(any())).thenReturn(sampleLog(caller.getId()));

        String body = """
            {
              "performedAt": "2025-01-15T10:00:00Z",
              "durationMinutes": 40,
              "perceivedEffort": 6,
              "notes": "ok",
              "entries": [
                {"position":1,"exerciseId":"%s","status":"COMPLETED",
                 "plannedConfig":{"REPS":"5"},"actualConfig":{"REPS":"4"}}
              ]
            }
            """.formatted(EXERCISE_ID);

        mockMvc.perform(post("/api/v1/workout-logs")
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER")))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.entries[0].position").value(1));
    }

    @Test
    void postWithInvalidConfigReturns400() throws Exception {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);
        when(createUseCase.create(any()))
                .thenThrow(new InvalidExerciseConfigException("Unknown config keys: [WEIGHT_KG]"));

        String body = """
            {
              "performedAt": "2025-01-15T10:00:00Z",
              "entries": [
                {"position":1,"exerciseId":"%s","status":"COMPLETED",
                 "plannedConfig":{"WEIGHT_KG":"20"},"actualConfig":{}}
              ]
            }
            """.formatted(EXERCISE_ID);

        mockMvc.perform(post("/api/v1/workout-logs")
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER")))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest());
    }

    @Test
    void deleteRequiresJwt_andReturns204() throws Exception {
        User caller = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(getUserUseCase.getByAuthIdentity(AuthProvider.CLERK, "ext-1")).thenReturn(caller);

        mockMvc.perform(delete("/api/v1/workout-logs/{id}", UUID.randomUUID())
                        .with(jwt().jwt(j -> j.subject("ext-1"))
                                .authorities(new SimpleGrantedAuthority("ROLE_USER"))))
                .andExpect(status().isNoContent());
    }

    @Test
    void deleteWithoutJwtIsUnauthorized() throws Exception {
        mockMvc.perform(delete("/api/v1/workout-logs/{id}", UUID.randomUUID()))
                .andExpect(status().isUnauthorized());
    }
}
