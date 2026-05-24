package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog;

import app.onlyclimb.api.domain.model.WorkoutLog;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.CreateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.DeleteWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.GetWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsQuery;
import app.onlyclimb.api.domain.port.in.ListWorkoutLogsUseCase;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogCommand;
import app.onlyclimb.api.domain.port.in.UpdateWorkoutLogUseCase;
import app.onlyclimb.api.domain.port.in.WorkoutLogEntryInput;
import app.onlyclimb.api.domain.port.out.WorkoutLogRepository.Page;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.CurrentUserService;
import app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto.CreateWorkoutLogRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto.UpdateWorkoutLogRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto.WorkoutLogEntryRequest;
import app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto.WorkoutLogPageResponse;
import app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto.WorkoutLogResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/workout-logs")
@RequiredArgsConstructor
@Tag(name = "Workout logs", description = "Personal records of performed workout sessions")
public class WorkoutLogController {

    private final CreateWorkoutLogUseCase createUseCase;
    private final UpdateWorkoutLogUseCase updateUseCase;
    private final DeleteWorkoutLogUseCase deleteUseCase;
    private final GetWorkoutLogUseCase getUseCase;
    private final ListWorkoutLogsUseCase listUseCase;
    private final CurrentUserService currentUserService;

    @GetMapping
    @Operation(summary = "List the caller's workout logs")
    public ResponseEntity<WorkoutLogPageResponse> list(
            @RequestParam(required = false) UUID templateId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to,
            @RequestParam(required = false) String cursor,
            @RequestParam(required = false, defaultValue = "20") int limit,
            Authentication authentication) {
        var caller = currentUserService.requireCurrent(authentication);
        Page<WorkoutLog> page = listUseCase.list(new ListWorkoutLogsQuery(
                caller.getId(), templateId, from, to, cursor, limit));
        List<WorkoutLogResponse> data = page.items().stream()
                .map(WorkoutLogResponse::from)
                .toList();
        return ResponseEntity.ok(new WorkoutLogPageResponse(data, page.nextCursor()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get one of the caller's workout logs by UUID")
    public ResponseEntity<WorkoutLogResponse> getById(
            @PathVariable UUID id, Authentication authentication) {
        var caller = currentUserService.requireCurrent(authentication);
        WorkoutLog log = getUseCase.getOwned(id, caller.getId());
        return ResponseEntity.ok(WorkoutLogResponse.from(log));
    }

    @PostMapping
    @Operation(summary = "Create a new workout log for the caller")
    public ResponseEntity<WorkoutLogResponse> create(
            @Valid @RequestBody CreateWorkoutLogRequest request,
            Authentication authentication) {
        var caller = currentUserService.requireCurrent(authentication);
        WorkoutLog created = createUseCase.create(new CreateWorkoutLogCommand(
                caller.getId(),
                request.workoutTemplateId(),
                request.performedAt(),
                request.durationMinutes(),
                request.perceivedEffort(),
                request.notes(),
                toDomainEntries(request.entries())));
        return ResponseEntity
                .created(URI.create("/api/v1/workout-logs/" + created.getId()))
                .body(WorkoutLogResponse.from(created));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update one of the caller's workout logs")
    public ResponseEntity<WorkoutLogResponse> update(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateWorkoutLogRequest request,
            Authentication authentication) {
        var caller = currentUserService.requireCurrent(authentication);
        WorkoutLog updated = updateUseCase.update(new UpdateWorkoutLogCommand(
                id,
                caller.getId(),
                request.workoutTemplateId(),
                request.performedAt(),
                request.durationMinutes(),
                request.perceivedEffort(),
                request.notes(),
                toDomainEntries(request.entries())));
        return ResponseEntity.ok(WorkoutLogResponse.from(updated));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Hard-delete one of the caller's workout logs")
    public ResponseEntity<Void> delete(@PathVariable UUID id, Authentication authentication) {
        var caller = currentUserService.requireCurrent(authentication);
        deleteUseCase.delete(id, caller.getId());
        return ResponseEntity.noContent().build();
    }

    private static List<WorkoutLogEntryInput> toDomainEntries(List<WorkoutLogEntryRequest> input) {
        if (input == null) return List.of();
        return input.stream()
                .map(r -> new WorkoutLogEntryInput(
                        r.position(),
                        r.exerciseId(),
                        r.status(),
                        r.plannedConfig() == null ? Map.of() : r.plannedConfig(),
                        r.actualConfig() == null ? Map.of() : r.actualConfig(),
                        r.notes()))
                .toList();
    }
}
