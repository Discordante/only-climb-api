---
description: "Use when creating or modifying application layer services: classes that implement use case interfaces and orchestrate domain logic. Application services wire input ports to output ports."
applyTo: "src/main/java/app/onlyclimb/api/application/**"
---

# Application Layer Rules

The application layer **orchestrates** domain logic. It knows the domain, but not the infrastructure.

## Application Services (`application/service/`)

- Annotate with `@Service` (the only Spring annotation allowed here).
- Use `@RequiredArgsConstructor` from Lombok for constructor injection.
- **Implement** one or more input port interfaces (`*UseCase`).
- **Depend on** output port interfaces (`*Repository`) — never on JPA repositories directly.
- No business logic here — delegate everything to domain entities and value objects.
- Handle transactions with `@Transactional` when needed.

```java
// CORRECT
@Service
@RequiredArgsConstructor
public class RouteService implements CreateRouteUseCase, FindRouteUseCase {

    private final RouteRepository routeRepository; // output port interface, not JPA

    @Override
    public Route createRoute(CreateRouteCommand command) {
        var route = new Route(new RouteGrade(command.grade())); // domain entity creation
        return routeRepository.save(route);
    }

    @Override
    public Route findRoute(Long id) {
        return routeRepository.findById(id)
                .orElseThrow(() -> new RouteNotFoundException(id));
    }
}

// WRONG — using JPA repository directly
@Service
public class RouteService {
    private final JpaRouteRepository jpaRepo; // breaks the dependency rule
}
```

## Command / Query Objects

- Use records for commands and queries passed into use cases.
- Place them alongside the use case interface in `domain/port/in/` or in `application/`.
- No Spring or JPA annotations.

```java
public record CreateRouteCommand(String grade, Long gymId) {}
```

## Rules

1. One service class may implement multiple related use case interfaces for the same aggregate.
2. Services must not know about HTTP, JSON, or any web concern.
3. Cross-aggregate coordination goes here, not in the domain.
4. If a service grows too large, split by use case grouping — not randomly.
