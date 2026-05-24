package app.onlyclimb.api.domain.model;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class EmailTest {

    @Test
    void normalizesByTrimmingAndLowercasing() {
        Email email = new Email("  ALICE@Example.COM ");
        assertThat(email.value()).isEqualTo("alice@example.com");
    }

    @Test
    void equalsByNormalizedValue() {
        assertThat(new Email("a@b.com")).isEqualTo(new Email("A@B.COM"));
    }

    @Test
    void rejectsInvalidFormat() {
        assertThatThrownBy(() -> new Email("not-an-email"))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void rejectsNull() {
        assertThatThrownBy(() -> new Email(null))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
