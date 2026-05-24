package app.onlyclimb.api.infrastructure.adapter.out.persistence.user;

import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.Height;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.UserProfile;
import app.onlyclimb.api.domain.model.Weight;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Import;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Import({UserJpaAdapter.class, UserProfileJpaAdapter.class})
@Testcontainers
class UserJpaAdapterIT {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:17-alpine");

    @Autowired UserJpaAdapter userAdapter;
    @Autowired UserProfileJpaAdapter profileAdapter;

    @Test
    void savesAndReloadsUser() {
        User user = User.register(AuthProvider.CLERK, "ext-" + UUID.randomUUID(),
                new Email("user-" + UUID.randomUUID() + "@example.com"));

        User saved = userAdapter.save(user);
        Optional<User> reloaded = userAdapter.findById(saved.getId());

        assertThat(reloaded).isPresent();
        assertThat(reloaded.get().getEmail().value()).isEqualTo(user.getEmail().value());
        assertThat(reloaded.get().getAuthProvider()).isEqualTo(AuthProvider.CLERK);
    }

    @Test
    void findsByAuthIdentity() {
        String externalId = "ext-" + UUID.randomUUID();
        User user = User.register(AuthProvider.CLERK, externalId,
                new Email("u-" + UUID.randomUUID() + "@example.com"));
        userAdapter.save(user);

        assertThat(userAdapter.findByAuthIdentity(AuthProvider.CLERK, externalId)).isPresent();
        assertThat(userAdapter.existsByAuthIdentity(AuthProvider.CLERK, externalId)).isTrue();
    }

    @Test
    void savesAndUpdatesProfile() {
        User user = userAdapter.save(User.register(AuthProvider.CLERK,
                "ext-" + UUID.randomUUID(),
                new Email("p-" + UUID.randomUUID() + "@example.com")));

        UserProfile saved = profileAdapter.save(UserProfile.empty(user.getId()));
        assertThat(profileAdapter.findByUserId(user.getId())).isPresent();

        saved.update("Alice", new Weight(new BigDecimal("65.50")),
                new Height(170), ClimbingDiscipline.SPORT, "es");
        profileAdapter.save(saved);

        UserProfile reloaded = profileAdapter.findByUserId(user.getId()).orElseThrow();
        assertThat(reloaded.getDisplayName()).contains("Alice");
        assertThat(reloaded.getWeight().orElseThrow().kg()).isEqualByComparingTo("65.50");
        assertThat(reloaded.getHeight().orElseThrow().cm()).isEqualTo(170);
        assertThat(reloaded.getPrimaryDiscipline()).contains(ClimbingDiscipline.SPORT);
        assertThat(reloaded.getLocale()).isEqualTo("es");
    }
}
