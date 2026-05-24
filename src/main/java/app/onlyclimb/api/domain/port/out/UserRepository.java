package app.onlyclimb.api.domain.port.out;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository {

    User save(User user);

    Optional<User> findById(UUID id);

    Optional<User> findByAuthIdentity(AuthProvider authProvider, String externalUserId);

    Optional<User> findByEmail(Email email);

    boolean existsByAuthIdentity(AuthProvider authProvider, String externalUserId);

    boolean existsByEmail(Email email);
}
