package app.onlyclimb.api.infrastructure.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Configuration for the Clerk integration.
 *
 * <ul>
 *   <li>{@code issuer}: the {@code iss} claim emitted by your Clerk instance,
 *       e.g. {@code https://clerk.your-domain.com}. Used for JWT validation.</li>
 *   <li>{@code jwksUri}: JWKS endpoint of your Clerk instance. Spring Security
 *       fetches the public keys lazily on the first authenticated request.</li>
 *   <li>{@code webhookSigningSecret}: the {@code whsec_*} secret from the Clerk
 *       webhook dashboard. Used to verify Svix-signed payloads.</li>
 *   <li>{@code secretKey}: the {@code sk_*} Backend API secret key. Used for
 *       server-to-server calls to {@code https://api.clerk.com}.</li>
 * </ul>
 */
@ConfigurationProperties(prefix = "onlyclimb.clerk")
public record ClerkProperties(
        String issuer,
        String jwksUri,
        String webhookSigningSecret,
        String secretKey) {
}
