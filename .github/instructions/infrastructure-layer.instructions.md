---
description: "Use when creating or modifying infrastructure layer: REST controllers, JPA entities, persistence adapters, mappers, exception handlers, or Spring configuration. This is where frameworks live."
applyTo: "src/main/java/app/onlyclimb/api/infrastructure/**"
---

# Infrastructure Layer Rules

Infrastructure is the outermost layer. Frameworks, JPA, HTTP — all of it lives here.

## REST Controllers (`infrastructure/adapter/in/web/`)

- Annotate with `@RestController` and `@RequestMapping`.
- Use `@RequiredArgsConstructor` for injection.
- **Inject input port interfaces** (`*UseCase`) — never application services directly.
- Accept **request DTOs** (`*Request`), return `ResponseEntity<*Response>`.
- Never return raw domain entities from controller methods.
- Validate request DTOs with Bean Validation (`@Valid`, `@NotBlank`, etc.).

```java
@RestController
@RequestMapping("/api/routes")
@RequiredArgsConstructor
public class RouteController {

    private final CreateRouteUseCase createRouteUseCase;
    private final FindRouteUseCase findRouteUseCase;

    @PostMapping
    public ResponseEntity<RouteResponse> create(@Valid @RequestBody CreateRouteRequest request) {
        var command = new CreateRouteCommand(request.grade(), request.gymId());
        var route = createRouteUseCase.createRoute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(RouteResponse.from(route));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RouteResponse> findById(@PathVariable Long id) {
        var route = findRouteUseCase.findRoute(id);
        return ResponseEntity.ok(RouteResponse.from(route));
    }
}
```

## Request / Response DTOs

- Use Java records.
- Annotate fields with Bean Validation constraints on Request DTOs.
- Response DTOs include a static factory `from(DomainEntity entity)` for mapping.

```java
public record CreateRouteRequest(
    @NotBlank String grade,
    @NotNull Long gymId
) {}

public record RouteResponse(Long id, String grade, String status) {
    public static RouteResponse from(Route route) {
        return new RouteResponse(route.getId(), route.getGrade().getValue(), route.getStatus().name());
    }
}
```

## JPA Persistence Adapters (`infrastructure/adapter/out/persistence/`)

- Create a JPA entity class (annotated with `@Entity`, `@Table`, etc.) — separate from the domain model.
- Create an adapter class that implements the output port (`*Repository`) interface.
- Use a Spring Data `JpaRepository` internally, but never expose it outside this adapter.
- Map between domain entity ↔ JPA entity in the adapter (or use a dedicated mapper).

### Identity Strategy (UUID + Long surrogate PK)

JPA entities use a **surrogate Long PK** for performance (joins, indexes) plus a **UUID column** as the public identity. The domain entity only knows the UUID.

```java
@Entity
@Table(name = "exercises")
@Getter @Setter @NoArgsConstructor
class ExerciseJpaEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;                         // internal, never exposed

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;                        // public identity, maps to domain id

    // ... other fields
}
```

The adapter maps UUID ↔ Long transparently:

```java
@Override
public Optional<Exercise> findById(UUID id) {
    return springRepo.findByUuid(id).map(this::toDomain);
}

private Exercise toDomain(ExerciseJpaEntity e) {
    return new Exercise(e.getUuid(), ...);
}
```

**Rule:** `Long id` never leaves the persistence adapter. UUID is the only identifier that flows through domain, application, and web layers.

### i18n — Translations Table Pattern

For translatable platform entities, create a companion `*TranslationJpaEntity`:

```java
@Entity
@Table(name = "exercise_translations",
       uniqueConstraints = @UniqueConstraint(columnNames = {"exercise_id", "locale", "field"}))
@Getter @Setter @NoArgsConstructor
class ExerciseTranslationJpaEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private ExerciseJpaEntity exercise;

    @Column(nullable = false, length = 10)
    private String locale;   // "en", "es"

    @Column(nullable = false, length = 50)
    private String field;    // "name", "description"

    @Column(nullable = false, columnDefinition = "TEXT")
    private String value;
}
```

**Never add `name_en`, `name_es` columns to the entity table.**

```java
@Entity
@Table(name = "routes")
@Getter @Setter @NoArgsConstructor
class RouteJpaEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String grade;
    // ...
}

interface SpringDataRouteRepository extends JpaRepository<RouteJpaEntity, Long> {}

@Component
@RequiredArgsConstructor
class RouteJpaAdapter implements RouteRepository {

    private final SpringDataRouteRepository springRepo;

    @Override
    public Route save(Route route) {
        var jpaEntity = toJpa(route);
        var saved = springRepo.save(jpaEntity);
        return toDomain(saved);
    }

    @Override
    public Optional<Route> findById(Long id) {
        return springRepo.findById(id).map(this::toDomain);
    }

    private RouteJpaEntity toJpa(Route route) { ... }
    private Route toDomain(RouteJpaEntity entity) { ... }
}
```

## Exception Handler (`infrastructure/adapter/in/web/`)

- One `@RestControllerAdvice` class maps domain exceptions to HTTP responses.
- Use `ProblemDetail` (Spring 6+) for RFC 9457-compliant error responses.

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RouteNotFoundException.class)
    public ProblemDetail handleRouteNotFound(RouteNotFoundException ex) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        var detail = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
        // add field errors as properties if needed
        return detail;
    }
}
```

## Spring Configuration (`infrastructure/config/`)

- `@Configuration` beans for cross-cutting concerns: security, CORS, OpenAPI, etc.
- No business logic in configuration classes.
