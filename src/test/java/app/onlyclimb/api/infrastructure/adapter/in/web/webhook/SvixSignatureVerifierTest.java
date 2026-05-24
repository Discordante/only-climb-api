package app.onlyclimb.api.infrastructure.adapter.in.web.webhook;

import app.onlyclimb.api.infrastructure.config.ClerkProperties;
import org.junit.jupiter.api.Test;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

import static org.assertj.core.api.Assertions.assertThat;

class SvixSignatureVerifierTest {

    private static final byte[] KEY_BYTES = "test-secret-bytes-32-chars-long!!".getBytes(StandardCharsets.UTF_8);
    private static final String SECRET = "whsec_" + Base64.getEncoder().encodeToString(KEY_BYTES);

    private final SvixSignatureVerifier verifier =
            new SvixSignatureVerifier(new ClerkProperties(null, null, SECRET));

    @Test
    void verifiesValidSignature() {
        String id = "msg_123";
        String ts = String.valueOf(Instant.now().getEpochSecond());
        byte[] body = "{\"type\":\"user.created\"}".getBytes(StandardCharsets.UTF_8);
        String sig = "v1," + sign(id, ts, body);

        assertThat(verifier.verify(id, ts, sig, body)).isTrue();
    }

    @Test
    void rejectsTamperedBody() {
        String id = "msg_123";
        String ts = String.valueOf(Instant.now().getEpochSecond());
        byte[] body = "{\"type\":\"user.created\"}".getBytes(StandardCharsets.UTF_8);
        String sig = "v1," + sign(id, ts, body);

        byte[] tampered = "{\"type\":\"user.deleted\"}".getBytes(StandardCharsets.UTF_8);
        assertThat(verifier.verify(id, ts, sig, tampered)).isFalse();
    }

    @Test
    void rejectsOldTimestamp() {
        String id = "msg_123";
        String ts = String.valueOf(Instant.now().minusSeconds(60 * 60).getEpochSecond());
        byte[] body = "{}".getBytes(StandardCharsets.UTF_8);
        String sig = "v1," + sign(id, ts, body);

        assertThat(verifier.verify(id, ts, sig, body)).isFalse();
    }

    @Test
    void rejectsWrongVersion() {
        String id = "msg_123";
        String ts = String.valueOf(Instant.now().getEpochSecond());
        byte[] body = "{}".getBytes(StandardCharsets.UTF_8);
        String sig = "v2," + sign(id, ts, body);

        assertThat(verifier.verify(id, ts, sig, body)).isFalse();
    }

    @Test
    void acceptsAnyMatchingEntryWhenMultiplePresent() {
        String id = "msg_123";
        String ts = String.valueOf(Instant.now().getEpochSecond());
        byte[] body = "{}".getBytes(StandardCharsets.UTF_8);
        String sig = "v1,bogus v1," + sign(id, ts, body);

        assertThat(verifier.verify(id, ts, sig, body)).isTrue();
    }

    private static String sign(String id, String ts, byte[] body) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(KEY_BYTES, "HmacSHA256"));
            byte[] prefix = (id + "." + ts + ".").getBytes(StandardCharsets.UTF_8);
            mac.update(prefix);
            mac.update(body);
            return Base64.getEncoder().encodeToString(mac.doFinal());
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }
}
