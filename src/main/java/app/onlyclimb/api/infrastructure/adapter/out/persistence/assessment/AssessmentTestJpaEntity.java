package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import app.onlyclimb.api.domain.model.AssessmentValueType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;

@Entity
@Table(name = "assessment_tests")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
class AssessmentTestJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;

    @Column(name = "definition_id", nullable = false)
    private Long definitionId;

    @Column(nullable = false, length = 80)
    private String code;

    @Column(nullable = false)
    private Integer position;

    @Column(nullable = false, length = 20)
    private String unit;

    @Enumerated(EnumType.STRING)
    @Column(name = "value_type", nullable = false, length = 20)
    private AssessmentValueType valueType;
}
