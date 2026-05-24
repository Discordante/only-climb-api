package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.UserProfile;

import java.util.Optional;
import java.util.UUID;

public interface UserProfileRepository {

    UserProfile save(UserProfile profile);

    Optional<UserProfile> findByUserId(UUID userId);
}
