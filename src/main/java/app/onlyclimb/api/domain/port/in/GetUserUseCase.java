package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.User;

import java.util.UUID;

public interface GetUserUseCase {

    User getById(UUID id);

    User getByAuthIdentity(AuthProvider authProvider, String externalUserId);
}
