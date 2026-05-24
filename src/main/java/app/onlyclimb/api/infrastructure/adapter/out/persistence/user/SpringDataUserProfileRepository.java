package app.onlyclimb.api.infrastructure.adapter.out.persistence.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

interface SpringDataUserProfileRepository extends JpaRepository<UserProfileJpaEntity, Long> {

    Optional<UserProfileJpaEntity> findByUserInternalId(Long userInternalId);
}
