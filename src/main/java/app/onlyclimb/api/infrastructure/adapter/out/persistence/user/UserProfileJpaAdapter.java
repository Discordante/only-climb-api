package app.onlyclimb.api.infrastructure.adapter.out.persistence.user;

import app.onlyclimb.api.domain.exception.UserNotFoundException;
import app.onlyclimb.api.domain.model.Height;
import app.onlyclimb.api.domain.model.UserProfile;
import app.onlyclimb.api.domain.model.Weight;
import app.onlyclimb.api.domain.port.out.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
class UserProfileJpaAdapter implements UserProfileRepository {

    private final SpringDataUserProfileRepository springRepo;
    private final SpringDataUserRepository userSpringRepo;

    @Override
    public UserProfile save(UserProfile profile) {
        Long userInternalId = resolveUserInternalId(profile.getUserId());

        UserProfileJpaEntity entity = springRepo.findByUserInternalId(userInternalId)
                .orElseGet(UserProfileJpaEntity::new);

        if (entity.getId() == null) {
            entity.setUuid(profile.getId());
            entity.setCreatedAt(profile.getCreatedAt());
            entity.setUserInternalId(userInternalId);
        }
        entity.setUpdatedAt(profile.getUpdatedAt());
        entity.setDisplayName(profile.getDisplayName().orElse(null));
        entity.setWeightKg(profile.getWeight().map(Weight::kg).orElse(null));
        entity.setHeightCm(profile.getHeight().map(Height::cm).orElse(null));
        entity.setPrimaryDiscipline(profile.getPrimaryDiscipline().orElse(null));
        entity.setLocale(profile.getLocale());

        return toDomain(springRepo.save(entity), profile.getUserId());
    }

    @Override
    public Optional<UserProfile> findByUserId(UUID userId) {
        return userSpringRepo.findByUuid(userId)
                .flatMap(user -> springRepo.findByUserInternalId(user.getId())
                        .map(profile -> toDomain(profile, user.getUuid())));
    }

    private Long resolveUserInternalId(UUID userUuid) {
        return userSpringRepo.findByUuid(userUuid)
                .orElseThrow(() -> new UserNotFoundException(userUuid))
                .getId();
    }

    private UserProfile toDomain(UserProfileJpaEntity entity, UUID userUuid) {
        Weight weight = entity.getWeightKg() != null ? new Weight(entity.getWeightKg()) : null;
        Height height = entity.getHeightCm() != null ? new Height(entity.getHeightCm()) : null;
        return new UserProfile(
                entity.getUuid(),
                userUuid,
                entity.getDisplayName(),
                weight,
                height,
                entity.getPrimaryDiscipline(),
                entity.getLocale(),
                entity.getCreatedAt(),
                entity.getUpdatedAt()
        );
    }
}
