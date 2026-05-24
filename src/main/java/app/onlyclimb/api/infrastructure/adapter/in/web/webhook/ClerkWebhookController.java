package app.onlyclimb.api.infrastructure.adapter.in.web.webhook;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.port.in.DeleteUserUseCase;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.RegisterUserUseCase;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Public endpoint for Clerk → backend webhooks. Authenticity is enforced by
 * Svix signature verification (see {@link SvixSignatureVerifier}); a missing
 * or invalid signature is answered with {@code 401}.
 *
 * <p>Supported events:</p>
 * <ul>
 *   <li>{@code user.created} / {@code user.updated} → idempotent ensure/update of the local user.</li>
 *   <li>{@code user.deleted} → soft-delete the local user.</li>
 * </ul>
 * Any other event is acknowledged with 200 and ignored.
 */
@RestController
@RequestMapping("/api/v1/webhooks/clerk")
@RequiredArgsConstructor
@Slf4j
public class ClerkWebhookController {

    private final SvixSignatureVerifier signatureVerifier;
    private final RegisterUserUseCase registerUserUseCase;
    private final DeleteUserUseCase deleteUserUseCase;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @PostMapping
    public ResponseEntity<Void> handle(
            @RequestHeader("svix-id") String svixId,
            @RequestHeader("svix-timestamp") String svixTimestamp,
            @RequestHeader("svix-signature") String svixSignature,
            @RequestBody byte[] rawBody) {

        if (!signatureVerifier.verify(svixId, svixTimestamp, svixSignature, rawBody)) {
            log.warn("Clerk webhook rejected: invalid signature (svix-id={})", svixId);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        JsonNode root;
        try {
            root = objectMapper.readTree(rawBody);
        } catch (Exception ex) {
            log.warn("Clerk webhook rejected: malformed JSON (svix-id={})", svixId);
            return ResponseEntity.badRequest().build();
        }

        String type = root.path("type").asText("");
        JsonNode data = root.path("data");

        switch (type) {
            case "user.created", "user.updated" -> handleUpsert(data);
            case "user.deleted" -> handleDelete(data);
            default -> log.debug("Ignoring unhandled Clerk event type={}", type);
        }
        return ResponseEntity.ok().build();
    }

    private void handleUpsert(JsonNode data) {
        String externalId = data.path("id").asText(null);
        String email = primaryEmail(data);
        if (externalId == null || email == null) {
            log.warn("Clerk webhook upsert skipped: missing id or primary email");
            return;
        }
        registerUserUseCase.register(new RegisterUserCommand(AuthProvider.CLERK, externalId, email));
    }

    private void handleDelete(JsonNode data) {
        String externalId = data.path("id").asText(null);
        if (externalId == null) {
            log.warn("Clerk webhook delete skipped: missing id");
            return;
        }
        deleteUserUseCase.deleteByAuthIdentity(AuthProvider.CLERK, externalId);
    }

    private static String primaryEmail(JsonNode data) {
        String primaryId = data.path("primary_email_address_id").asText(null);
        JsonNode addresses = data.path("email_addresses");
        if (!addresses.isArray()) {
            return null;
        }
        String fallback = null;
        for (JsonNode entry : addresses) {
            String address = entry.path("email_address").asText(null);
            if (address == null) {
                continue;
            }
            if (fallback == null) {
                fallback = address;
            }
            if (primaryId != null && primaryId.equals(entry.path("id").asText(null))) {
                return address;
            }
        }
        return fallback;
    }
}
