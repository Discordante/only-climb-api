---
mode: agent
description: "Scaffold all files for a new feature following hexagonal architecture: domain entity, input/output ports, application service, JPA adapter, REST controller, request/response DTOs, and exception handler mapping."
---

# New Feature Scaffold

You are implementing a new feature in a **strict hexagonal architecture** Spring Boot application.

## Input Required

Ask the user for:
1. **Entity name** (e.g., `Route`, `ClimbingGym`) — PascalCase singular noun
2. **Fields** — name and type for each field of the domain entity
3. **Use cases** — which operations to implement (e.g., create, find by id, list all, update, delete)

## Files to Generate

For an entity called `{Entity}`, generate ALL of the following files:

### Domain Layer

**`domain/model/{Entity}.java`**
- Plain Java class, no framework annotations
- Constructor validates invariants
- Explicit getters, behavior methods where appropriate

**`domain/port/in/Create{Entity}UseCase.java`** (and other requested use cases)
- Plain Java interface
- Takes a `Create{Entity}Command` record

**`domain/port/in/Create{Entity}Command.java`** (record per command)

**`domain/port/out/{Entity}Repository.java`**
- Plain Java interface with domain-specific method signatures

**`domain/exception/{Entity}NotFoundException.java`**
- Extends `RuntimeException`

### Application Layer

**`application/service/{Entity}Service.java`**
- `@Service @RequiredArgsConstructor`
- Implements all requested use case interfaces
- Injects `{Entity}Repository` output port

### Infrastructure — Persistence

**`infrastructure/adapter/out/persistence/{Entity}JpaEntity.java`**
- `@Entity @Table` JPA entity, completely separate from domain model

**`infrastructure/adapter/out/persistence/SpringData{Entity}Repository.java`**
- `extends JpaRepository<{Entity}JpaEntity, Long>`

**`infrastructure/adapter/out/persistence/{Entity}JpaAdapter.java`**
- `@Component @RequiredArgsConstructor`
- Implements `{Entity}Repository`
- Contains `toJpa()` and `toDomain()` mapping methods

### Infrastructure — Web

**`infrastructure/adapter/in/web/{Entity}Controller.java`**
- `@RestController @RequestMapping @RequiredArgsConstructor`
- Injects use case interfaces (never the service directly)
- Returns `ResponseEntity<{Entity}Response>`

**`infrastructure/adapter/in/web/dto/Create{Entity}Request.java`** (record, with `@NotBlank`/`@NotNull`)

**`infrastructure/adapter/in/web/dto/{Entity}Response.java`** (record with `static from({Entity})` factory)

### Exception Mapping

If a `GlobalExceptionHandler` does not yet exist:
**`infrastructure/adapter/in/web/GlobalExceptionHandler.java`**
- `@RestControllerAdvice`
- Maps `{Entity}NotFoundException` → `404 NOT FOUND` using `ProblemDetail`

Otherwise, add the new mapping to the existing handler.

## Checklist Before Finishing

- [ ] Domain entity has zero Spring/JPA annotations
- [ ] All use cases are interfaces in `domain/port/in/`
- [ ] Application service injects output port *interfaces*, not Spring Data repos
- [ ] Controller injects use case *interfaces*, not the service class
- [ ] Request DTOs have Bean Validation annotations
- [ ] Response DTOs have a `static from()` factory method
- [ ] JPA entity is a separate class from the domain entity
- [ ] Exception handler maps domain exceptions to HTTP status codes
