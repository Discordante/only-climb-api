package app.onlyclimb.api.infrastructure.adapter.out.persistence.user;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.UserRole;
import app.onlyclimb.api.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
class UserJpaAdapter implements UserRepository {

    private final SpringDataUserRepository springRepo;

    @Override
    public User save(User user) {
        UserJpaEntity entity = springRepo.findByUuid(user.getId())
                .orElseGet(UserJpaEntity::new);
        applyToEntity(user, entity);
        return toDomain(springRepo.save(entity));
    }

    @Override
    public Optional<User> findById(UUID id) {
        return springRepo.findByUuid(id).map(this::toDomain);
    }

    @Override
    public Optional<User> findByAuthIdentity(AuthProvider authProvider, String externalUserId) {
        return springRepo.findByAuthProviderAndExternalUserId(authProvider, externalUserId)
                .map(this::toDomain);
    }

    @Override
    public Optional<User> findByEmail(Email email) {
        return springRepo.findByEmail(email.value()).map(this::toDomain);
    }

    @Override
    public boolean existsByAuthIdentity(AuthProvider authProvider, String externalUserId) {
        return springRepo.existsByAuthProviderAndExternalUserId(authProvider, externalUserId);
    }

    @Override
    public boolean existsByEmail(Email email) {
        return springRepo.existsByEmail(email.value());
    }

    private void applyToEntity(User user, UserJpaEntity entity) {
        if (entity.getId() == null) {
            entity.setUuid(user.getId());
            entity.setCreatedAt(user.getCreatedAt());
            entity.setAuthProvider(user.getAuthProvider());
            entity.setExternalUserId(user.getExternalUserId());
        }
        entity.setEmail(user.getEmail().value());
        entity.setRole(user.getRole());
        entity.setUpdatedAt(user.getUpdatedAt());
        entity.setLastLoginAt(user.getLastLoginAt().orElse(null));
        entity.setDeletedAt(user.getDeletedAt().orElse(null));
    }

    User toDomain(UserJpaEntity entity) {
        return new User(
                entity.getUuid(),
                entity.getAuthProvider(),
                entity.getExternalUserId(),
                new Email(entity.getEmail()),
                entity.getRole() != null ? entity.getRole() : UserRole.USER,
                entity.getCreatedAt(),
                entity.getUpdatedAt(),
                entity.getLastLoginAt(),
                entity.getDeletedAt()
        );
    }
}
