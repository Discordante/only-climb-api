package app.onlyclimb.api.domain.model;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class UserTest {

    @Test
    void registerCreatesActiveUserWithRoleUser() {
        User user = User.register(AuthProvider.CLERK, "ext-1", new Email("a@b.com"));

        assertThat(user.getId()).isNotNull();
        assertThat(user.getRole()).isEqualTo(UserRole.USER);
        assertThat(user.isActive()).isTrue();
        assertThat(user.getLastLoginAt()).isEmpty();
        assertThat(user.getCreatedAt()).isEqualTo(user.getUpdatedAt());
    }

    @Test
    void recordLoginUpdatesTimestamps() {
        User user = User.register(AuthProvider.CLERK, "ext-1", new Email("a@b.com"));
        user.recordLogin();
        assertThat(user.getLastLoginAt()).isPresent();
    }

    @Test
    void softDeletePreventsMutations() {
        User user = User.register(AuthProvider.CLERK, "ext-1", new Email("a@b.com"));
        user.softDelete();
        assertThat(user.isActive()).isFalse();
        assertThatThrownBy(user::recordLogin).isInstanceOf(IllegalStateException.class);
        assertThatThrownBy(() -> user.changeEmail(new Email("c@d.com")))
                .isInstanceOf(IllegalStateException.class);
    }

    @Test
    void rejectsBlankExternalUserId() {
        assertThatThrownBy(() -> User.register(AuthProvider.CLERK, "  ", new Email("a@b.com")))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
