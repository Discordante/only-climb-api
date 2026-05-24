package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "assessment_metrics", uniqueConstraints = @UniqueConstraint(
        name = "assessment_metrics_result_id_test_id_key",
        columnNames = {"result_id", "test_id"}))
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
class AssessmentMetricJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "result_id", nullable = false)
    private Long resultId;

    @Column(name = "test_id", nullable = false)
    private Long testId;

    @Column(name = "numeric_value", nullable = false, precision = 12, scale = 4)
    private BigDecimal numericValue;
}
