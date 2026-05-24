package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.UserProfile;

import java.util.UUID;

public interface UpdateUserProfileUseCase {

    UserProfile updateProfile(UUID userId, UpdateUserProfileCommand command);
}
