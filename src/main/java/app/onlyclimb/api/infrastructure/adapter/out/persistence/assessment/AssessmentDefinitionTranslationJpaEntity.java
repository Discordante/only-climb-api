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

@Entity
@Table(name = "assessment_definition_translations", uniqueConstraints = @UniqueConstraint(
        name = "assessment_definition_translations_definition_id_locale_field_key",
        columnNames = {"definition_id", "locale", "field"}))
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
class AssessmentDefinitionTranslationJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "definition_id", nullable = false)
    private Long definitionId;

    @Column(nullable = false, length = 10)
    private String locale;

    @Column(nullable = false, length = 50)
    private String field;

    @Column(nullable = false, columnDefinition = "text")
    private String value;
}
