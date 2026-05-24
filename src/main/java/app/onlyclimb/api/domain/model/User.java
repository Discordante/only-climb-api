package app.onlyclimb.api.domain.model;

import java.time.Instant;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * Aggregate root representing an authenticated user.
 * Identity is owned by an external auth provider; the local row is keyed by
 * (authProvider, externalUserId). Email is stored for lookups and notifications.
 * Soft-deletion is supported via {@code deletedAt}.
 */
public class User {

    private final UUID id;
    private final AuthProvider authProvider;
    private final String externalUserId;
    private Email email;
    private UserRole role;
    private final Instant createdAt;
    private Instant updatedAt;
    private Instant lastLoginAt;
    private Instant deletedAt;

    public User(
            UUID id,
            AuthProvider authProvider,
            String externalUserId,
            Email email,
            UserRole role,
            Instant createdAt,
            Instant updatedAt,
            Instant lastLoginAt,
            Instant deletedAt
    ) {
        this.id = Objects.requireNonNull(id, "User id is required");
        this.authProvider = Objects.requireNonNull(authProvider, "Auth provider is required");
        if (externalUserId == null || externalUserId.isBlank()) {
            throw new IllegalArgumentException("External user id is required");
        }
        if (externalUserId.length() > 255) {
            throw new IllegalArgumentException("External user id exceeds 255 characters");
        }
        this.externalUserId = externalUserId;
        this.email = Objects.requireNonNull(email, "Email is required");
        this.role = Objects.requireNonNull(role, "Role is required");
        this.createdAt = Objects.requireNonNull(createdAt, "createdAt is required");
        this.updatedAt = Objects.requireNonNull(updatedAt, "updatedAt is required");
        this.lastLoginAt = lastLoginAt;
        this.deletedAt = deletedAt;
    }

    /** Factory used when a brand-new user signs in for the first time. */
    public static User register(AuthProvider authProvider, String externalUserId, Email email) {
        Instant now = Instant.now();
        return new User(
                UUID.randomUUID(),
                authProvider,
                externalUserId,
                email,
                UserRole.USER,
                now,
                now,
                null,
                null
        );
    }

    public void recordLogin() {
        ensureActive();
        Instant now = Instant.now();
        this.lastLoginAt = now;
        this.updatedAt = now;
    }

    public void changeEmail(Email newEmail) {
        Objects.requireNonNull(newEmail, "Email is required");
        ensureActive();
        if (!newEmail.equals(this.email)) {
            this.email = newEmail;
            this.updatedAt = Instant.now();
        }
    }

    public void promoteToAdmin() {
        ensureActive();
        if (this.role != UserRole.ADMIN) {
            this.role = UserRole.ADMIN;
            this.updatedAt = Instant.now();
        }
    }

    public void softDelete() {
        if (this.deletedAt != null) return;
        Instant now = Instant.now();
        this.deletedAt = now;
        this.updatedAt = now;
    }

    public boolean isActive() {
        return deletedAt == null;
    }

    private void ensureActive() {
        if (!isActive()) {
            throw new IllegalStateException("Cannot modify a deleted user");
        }
    }

    public UUID getId() { return id; }
    public AuthProvider getAuthProvider() { return authProvider; }
    public String getExternalUserId() { return externalUserId; }
    public Email getEmail() { return email; }
    public UserRole getRole() { return role; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Optional<Instant> getLastLoginAt() { return Optional.ofNullable(lastLoginAt); }
    public Optional<Instant> getDeletedAt() { return Optional.ofNullable(deletedAt); }
}
