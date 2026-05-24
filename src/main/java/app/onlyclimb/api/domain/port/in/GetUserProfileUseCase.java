package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.UserProfile;

import java.util.UUID;

public interface GetUserProfileUseCase {

    UserProfile getByUserId(UUID userId);
}
