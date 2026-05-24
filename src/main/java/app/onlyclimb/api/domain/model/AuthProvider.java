package app.onlyclimb.api.domain.model;

/**
 * External authentication provider that owns the user's identity.
 * The application never stores passwords; the JWT issued by the provider is
 * the source of truth. Adding a new provider is purely additive.
 */
public enum AuthProvider {
    CLERK
}
