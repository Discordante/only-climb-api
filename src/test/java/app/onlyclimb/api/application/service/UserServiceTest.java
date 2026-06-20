package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.exception.DuplicateUserException;
import app.onlyclimb.api.domain.exception.UserNotFoundException;
import app.onlyclimb.api.domain.model.AuthProvider;
import app.onlyclimb.api.domain.model.Email;
import app.onlyclimb.api.domain.model.User;
import app.onlyclimb.api.domain.model.UserProfile;
import app.onlyclimb.api.domain.port.in.RegisterUserCommand;
import app.onlyclimb.api.domain.port.in.ProvisionFreeSubscriptionUseCase;
import app.onlyclimb.api.domain.port.out.UserProfileRepository;
import app.onlyclimb.api.domain.port.out.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock UserRepository userRepository;
    @Mock UserProfileRepository userProfileRepository;
    @Mock ProvisionFreeSubscriptionUseCase provisionFreeSubscriptionUseCase;
    @InjectMocks UserService service;

    private RegisterUserCommand cmd;

    @BeforeEach
    void setUp() {
        cmd = new RegisterUserCommand(AuthProvider.CLERK, "ext-1", "alice@example.com");
    }

    @Test
    void registerCreatesUserAndEmptyProfileWhenNewIdentity() {
        when(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-1"))
                .thenReturn(Optional.empty());
        when(userRepository.existsByEmail(any(Email.class))).thenReturn(false);
        when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

        User result = service.register(cmd);

        assertThat(result.getEmail().value()).isEqualTo("alice@example.com");
        verify(userProfileRepository).save(any(UserProfile.class));
    }

    @Test
    void registerIsIdempotentAndRecordsLoginWhenIdentityExists() {
        User existing = User.register(AuthProvider.CLERK, "ext-1", new Email("alice@example.com"));
        when(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-1"))
                .thenReturn(Optional.of(existing));
        when(userRepository.save(existing)).thenReturn(existing);

        User result = service.register(cmd);

        assertThat(result).isSameAs(existing);
        assertThat(existing.getLastLoginAt()).isPresent();
        verify(userProfileRepository, never()).save(any());
    }

    @Test
    void registerRejectsDuplicateEmailForDifferentIdentity() {
        when(userRepository.findByAuthIdentity(AuthProvider.CLERK, "ext-1"))
                .thenReturn(Optional.empty());
        when(userRepository.existsByEmail(any(Email.class))).thenReturn(true);

        assertThatThrownBy(() -> service.register(cmd))
                .isInstanceOf(DuplicateUserException.class);
        verify(userRepository, never()).save(any());
    }

    @Test
    void getByIdThrowsWhenMissing() {
        UUID id = UUID.randomUUID();
        when(userRepository.findById(id)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.getById(id))
                .isInstanceOf(UserNotFoundException.class);
    }
}
