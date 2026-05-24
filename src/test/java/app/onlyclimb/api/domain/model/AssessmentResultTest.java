package app.onlyclimb.api.domain.model;

import app.onlyclimb.api.domain.exception.ContentOwnershipException;
import app.onlyclimb.api.domain.exception.InvalidAssessmentResultException;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class AssessmentResultTest {

    private static final UUID OWNER = UUID.randomUUID();
    private static final UUID DEFINITION = UUID.randomUUID();
    private static final UUID TEST_1 = UUID.randomUUID();
    private static final UUID TEST_2 = UUID.randomUUID();

    @Test
    void create_setsRandomIdAndCreatedAt() {
        AssessmentResult r = AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), null, null,
                List.of(new AssessmentMetric(TEST_1, new BigDecimal("12.5"))));

        assertThat(r.getId()).isNotNull();
        assertThat(r.getCreatedAt()).isNotNull();
        assertThat(r.getOwnerId()).isEqualTo(OWNER);
        assertThat(r.getMetrics()).hasSize(1);
    }

    @Test
    void create_withEmptyMetrics_throws() {
        assertThatThrownBy(() -> AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), null, null, List.of()))
                .isInstanceOf(InvalidAssessmentResultException.class);
    }

    @Test
    void create_withDuplicateTestId_throws() {
        assertThatThrownBy(() -> AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), null, null,
                List.of(
                        new AssessmentMetric(TEST_1, new BigDecimal("1")),
                        new AssessmentMetric(TEST_1, new BigDecimal("2")))))
                .isInstanceOf(InvalidAssessmentResultException.class);
    }

    @Test
    void create_withNegativeUserWeight_throws() {
        assertThatThrownBy(() -> AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), new BigDecimal("-1"), null,
                List.of(new AssessmentMetric(TEST_1, new BigDecimal("1")))))
                .isInstanceOf(InvalidAssessmentResultException.class);
    }

    @Test
    void assertOwnedBy_strangerThrows() {
        AssessmentResult r = AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), null, null,
                List.of(new AssessmentMetric(TEST_1, BigDecimal.ONE)));

        assertThatThrownBy(() -> r.assertOwnedBy(UUID.randomUUID()))
                .isInstanceOf(ContentOwnershipException.class);
        assertThatThrownBy(() -> r.assertOwnedBy(null))
                .isInstanceOf(ContentOwnershipException.class);
    }

    @Test
    void assertOwnedBy_ownerPasses() {
        AssessmentResult r = AssessmentResult.create(
                OWNER, DEFINITION, Instant.now(), null, "  ",
                List.of(
                        new AssessmentMetric(TEST_1, BigDecimal.ONE),
                        new AssessmentMetric(TEST_2, BigDecimal.TEN)));

        r.assertOwnedBy(OWNER);
        // blank notes normalised to absent
        assertThat(r.getNotes()).isEmpty();
    }
}
