package app.onlyclimb.api.infrastructure.adapter.in.web.webhook;

import app.onlyclimb.api.infrastructure.config.ClerkProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;

/**
 * Verifies Svix-signed webhook payloads (the protocol Clerk uses for outgoing
 * webhooks). See <a href="https://docs.svix.com/receiving/verifying-payloads/how-manual">
 * Svix manual verification</a>.
 *
 * <p>The signed content is {@code "${svix-id}.${svix-timestamp}.${rawBody}"};
 * the signing key is the base64-decoded portion of the secret after the
 * {@code whsec_} prefix. The {@code svix-signature} header may contain one or
 * more {@code v1,<base64-hmac>} entries separated by spaces — any match is
 * accepted.</p>
 */
@Component
@RequiredArgsConstructor
public class SvixSignatureVerifier {

    private static final String HMAC_ALGO = "HmacSHA256";
    private static final String SECRET_PREFIX = "whsec_";
    private static final String SIGNATURE_VERSION = "v1";
    /** Reject payloads whose timestamp drifts more than this window. */
    static final Duration TOLERANCE = Duration.ofMinutes(5);

    private final ClerkProperties clerkProperties;

    public boolean verify(String svixId, String svixTimestamp, String svixSignature, byte[] rawBody) {
        if (svixId == null || svixTimestamp == null || svixSignature == null || rawBody == null) {
            return false;
        }
        String configuredSecret = clerkProperties.webhookSigningSecret();
        if (configuredSecret == null || configuredSecret.isBlank()) {
            return false;
        }
        if (!withinTolerance(svixTimestamp)) {
            return false;
        }

        byte[] keyBytes = decodeSecret(configuredSecret);
        byte[] expected = hmac(keyBytes, signedContent(svixId, svixTimestamp, rawBody));
        String expectedB64 = Base64.getEncoder().encodeToString(expected);

        for (String entry : svixSignature.split(" ")) {
            int comma = entry.indexOf(',');
            if (comma <= 0) {
                continue;
            }
            String version = entry.substring(0, comma);
            String sigB64 = entry.substring(comma + 1);
            if (!SIGNATURE_VERSION.equals(version)) {
                continue;
            }
            if (constantTimeEquals(expectedB64, sigB64)) {
                return true;
            }
        }
        return false;
    }

    private static boolean withinTolerance(String timestamp) {
        try {
            long ts = Long.parseLong(timestamp);
            long now = Instant.now().getEpochSecond();
            return Math.abs(now - ts) <= TOLERANCE.toSeconds();
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private static byte[] decodeSecret(String secret) {
        String body = secret.startsWith(SECRET_PREFIX) ? secret.substring(SECRET_PREFIX.length()) : secret;
        return Base64.getDecoder().decode(body);
    }

    private static byte[] signedContent(String svixId, String svixTimestamp, byte[] rawBody) {
        byte[] prefix = (svixId + "." + svixTimestamp + ".").getBytes(StandardCharsets.UTF_8);
        byte[] combined = new byte[prefix.length + rawBody.length];
        System.arraycopy(prefix, 0, combined, 0, prefix.length);
        System.arraycopy(rawBody, 0, combined, prefix.length, rawBody.length);
        return combined;
    }

    private static byte[] hmac(byte[] key, byte[] message) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGO);
            mac.init(new SecretKeySpec(key, HMAC_ALGO));
            return mac.doFinal(message);
        } catch (Exception ex) {
            throw new IllegalStateException("Failed to compute HMAC", ex);
        }
    }

    private static boolean constantTimeEquals(String a, String b) {
        return MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
