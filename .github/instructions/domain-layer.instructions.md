---
description: "Use when creating or modifying domain layer classes: entities, value objects, domain exceptions, input ports (UseCase interfaces), or output ports (Repository interfaces). Enforces pure Java with zero framework coupling."
applyTo: "src/main/java/app/onlyclimb/api/domain/**"
---

# Domain Layer Rules

The domain is the innermost layer. It must remain **completely framework-free**.

## Entities & Aggregates (`domain/model/`)

- Plain Java classes — no `@Entity`, no `@Table`, no Spring annotations.
- Use explicit constructors that validate invariants. Throw `IllegalArgumentException` or a domain exception if invariants are violated.
- Expose behavior through methods, not just getters. Example: `route.publish()` instead of `route.setStatus(PUBLISHED)`.
- Avoid Lombok on domain models — be explicit about what is exposed.
- Use `final` fields where possible to enforce immutability.

```java
// CORRECT
public class Route {
    private final RouteGrade grade;
    private RouteStatus status;

    public Route(RouteGrade grade) {
        if (grade == null) throw new IllegalArgumentException("Grade is required");
        this.grade = grade;
        this.status = RouteStatus.DRAFT;
    }

    public void publish() {
        if (this.status != RouteStatus.DRAFT) throw new RouteAlreadyPublishedException();
        this.status = RouteStatus.PUBLISHED;
    }
}

// WRONG — framework leak into domain
@Entity
public class Route { ... }
```

## Value Objects (`domain/model/`)

- Immutable. All fields `final`. No setters.
- Override `equals()` and `hashCode()` based on value, not identity.
- Validate on construction.

```java
public final class RouteGrade {
    private final String value;

    public RouteGrade(String value) {
        if (value == null || value.isBlank()) throw new IllegalArgumentException("Grade cannot be blank");
        this.value = value;
    }

    public String getValue() { return value; }

    @Override public boolean equals(Object o) { ... }
    @Override public int hashCode() { ... }
}
```

## Input Ports (`domain/port/in/`)

- Plain Java interfaces. One interface per use case.
- Name: `<Action><Entity>UseCase` (e.g., `CreateRouteUseCase`, `FindRouteUseCase`).
- Methods take **command/query objects** or primitives — never request DTOs from the web layer.

```java
public interface CreateRouteUseCase {
    Route createRoute(CreateRouteCommand command);
}
```

## Output Ports (`domain/port/out/`)

- Plain Java interfaces. Define what the domain NEEDS, not how it's stored.
- Name: `<Entity>Repository` (e.g., `RouteRepository`).
- No JPA-specific return types — use `Optional<>`, domain entities, or primitives.

```java
public interface RouteRepository {
    Route save(Route route);
    Optional<Route> findById(Long id);
    List<Route> findAll();
}
```

## Domain Exceptions (`domain/exception/`)

- Extend `RuntimeException`.
- Descriptive names: `RouteNotFoundException`, `RouteAlreadyPublishedException`.
- No HTTP status codes or Spring annotations here — mapping happens in infrastructure.
