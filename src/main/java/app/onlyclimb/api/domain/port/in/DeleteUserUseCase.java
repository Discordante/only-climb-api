package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AuthProvider;

public interface DeleteUserUseCase {

    /**
     * Soft-deletes the local user matching the external identity, if any.
     * Idempotent: a missing user is a no-op.
     */
    void deleteByAuthIdentity(AuthProvider authProvider, String externalUserId);
}
