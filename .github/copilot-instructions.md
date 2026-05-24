# Only Climb API — Project Guidelines

## Architecture: Hexagonal (Ports & Adapters)

This project follows **strict hexagonal architecture**. Every feature lives in one of three concentric layers:

```
src/main/java/app/onlyclimb/api/
├── domain/               ← The core. Pure business logic. NO framework dependencies.
│   ├── model/            ← Entities, Value Objects, Aggregates
│   ├── port/
│   │   ├── in/           ← Input ports (use case interfaces)
│   │   └── out/          ← Output ports (repository/service interfaces)
│   └── exception/        ← Domain-specific exceptions
│
├── application/          ← Orchestrates use cases. Depends only on domain.
│   └── service/          ← Implements input ports, uses output ports
│
└── infrastructure/       ← Frameworks, DB, HTTP, external services.
    ├── adapter/
    │   ├── in/
    │   │   └── web/      ← REST controllers (Spring MVC)
    │   └── out/
    │       └── persistence/ ← JPA repositories, entity mappers
    └── config/           ← Spring @Configuration beans
```

### The Golden Rule
**Domain has ZERO knowledge of infrastructure.** No Spring annotations (`@Service`, `@Repository`, `@Component`) inside `domain/`. No JPA entities inside `domain/model/`. Domain classes are plain Java objects.

### Dependency Rule
`infrastructure` → `application` → `domain` (arrows point inward only)

## Tech Stack
- Java 25, Spring Boot 4.x
- Spring MVC (Web), Spring Data JPA, Bean Validation
- PostgreSQL, Lombok
- Maven

## Naming Conventions

| Concept | Naming | Example |
|---|---|---|
| Input Port | `<Action><Entity>UseCase` | `CreateRouteUseCase` |
| Output Port | `<Entity>Repository` (interface) | `RouteRepository` |
| Application Service | `<Entity>Service` | `RouteService` |
| Web Adapter | `<Entity>Controller` | `RouteController` |
| JPA Adapter | `Jpa<Entity>Repository` | `JpaRouteRepository` |
| Domain Entity | PascalCase, no suffix | `Route`, `ClimbingGym` |
| Value Object | Descriptive noun | `RouteGrade`, `GymLocation` |
| DTO (web) | `<Entity><Action>Request/Response` | `CreateRouteRequest`, `RouteResponse` |

## Coding Standards

- Use **Lombok** (`@Getter`, `@Builder`, `@RequiredArgsConstructor`) on infrastructure and application classes. Avoid on domain models — keep them explicit.
- Domain entities use **plain constructors** and expose behavior via methods, not just getters/setters.
- **No `@Autowired` field injection** — always constructor injection (enforced by `@RequiredArgsConstructor`).
- All input ports are **interfaces** in `domain/port/in/`. Application services implement them.
- All output ports are **interfaces** in `domain/port/out/`. Infrastructure adapters implement them.
- Validate at the **web adapter boundary** (Bean Validation on request DTOs). Domain validates its own invariants in constructors.
- Use `ResponseEntity<>` in controllers. Never return raw domain objects from controllers — use response DTOs.
- Throw domain exceptions from the domain layer; map them to HTTP responses in a `@RestControllerAdvice`.

## Build & Test
```bash
./mvnw spring-boot:run          # Run the app
./mvnw test                     # Run all tests
./mvnw verify                   # Build + test
```
