package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "assessment_results")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
class AssessmentResultJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "user_id", nullable = false, updatable = false)
    private Long userId;

    @Column(name = "definition_id", nullable = false, updatable = false)
    private Long definitionId;

    @Column(name = "performed_at", nullable = false)
    private Instant performedAt;

    @Column(name = "user_weight_kg", precision = 5, scale = 2)
    private BigDecimal userWeightKg;

    @Column(columnDefinition = "text")
    private String notes;
}
