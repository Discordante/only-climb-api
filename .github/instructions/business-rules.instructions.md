---
description: "Use when implementing any feature, endpoint, or domain entity. Contains the business rules, domain concepts, and key design decisions specific to the Only Climb application. Read this before generating any domain model, use case, or API endpoint."
applyTo: "src/main/**"
---

# Only Climb — Business Rules & Domain Knowledge

## What is Only Climb?

A platform for climbing gyms and climbers. Gyms manage their climbing routes; climbers track their sessions and progress.

## Core Domain Concepts

### ClimbingGym
- A gym is the top-level aggregate. All routes belong to a gym.
- A gym has a slug (unique, URL-friendly identifier) and a physical location.
- Gyms are managed by users with the `GYM_MANAGER` role.

### Route
- Represents a physical climbing route set on a wall inside a gym.
- Has a `RouteGrade` (e.g., `6a`, `7b+` in French scale) and a `RouteColor` (the color of the holds).
- Lifecycle: `DRAFT` → `PUBLISHED` → `ARCHIVED`. Only published routes are visible to climbers.
- Routes are created and managed by gym staff, not by climbers.

### ClimberSession (future)
- A climber's record of completing routes in a session.
- Belongs to a climber (identified by `userId`), not to a gym.

## Identity & Authentication

- Identity is managed externally by **Clerk**.
- The `userId` (Clerk's subject) arrives in the JWT as the `sub` claim.
- **Never store passwords.** The API trusts the JWT from Clerk.
- User roles (`CLIMBER`, `GYM_MANAGER`) are stored in our database, not in the JWT.
- A `userId` string maps to our internal user concept — always treat it as an opaque string, never as an integer.

## API Design Rules

- All endpoints are prefixed with `/api/v1/`.
- Gym-scoped resources follow the pattern: `/api/v1/gyms/{gymSlug}/routes`.
- Endpoints that mutate state require authentication. Read-only public endpoints (e.g., listing published routes) may be unauthenticated.
- Pagination: use cursor-based pagination for lists, not offset. Return `{ data: [...], nextCursor: "..." }`.

## Grade System

- Use the **French/European sport climbing scale**: `3`, `4`, `4+`, `5`, `5+`, `6a`, `6a+`, `6b`, ..., `9c`.
- Store grades as strings, not enums — the scale evolves.
- Validate that the submitted grade is a recognized value from the official scale.

## Invariants to Enforce in the Domain

| Entity | Invariant |
|---|---|
| `Route` | Cannot be published without a grade and a color |
| `Route` | Cannot transition from `ARCHIVED` back to any other status |
| `RouteGrade` | Must be a valid French scale value |
| `ClimbingGym` | Slug must be unique, lowercase, alphanumeric + hyphens |

## What NOT to Do

- Do not model gym staff accounts as a separate entity — a user becomes a manager via role assignment.
- Do not use `Long` IDs externally in the API — expose UUIDs to clients, keep surrogate Long PKs internal for JPA.
- Do not couple routes to a specific wall or sector in this iteration — that is future scope.
