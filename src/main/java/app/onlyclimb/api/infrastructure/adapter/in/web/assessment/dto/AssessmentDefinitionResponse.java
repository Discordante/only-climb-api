package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record AssessmentDefinitionResponse(
        UUID id,
        String code,
        ClimbingDiscipline targetDiscipline,
        boolean active,
        List<AssessmentTestResponse> tests,
        String name,
        String description,
        String protocol,
        Instant createdAt,
        Instant updatedAt) {

    public static AssessmentDefinitionResponse from(AssessmentDefinition def, String locale) {
        return new AssessmentDefinitionResponse(
                def.getId(),
                def.getCode(),
                def.getTargetDiscipline().orElse(null),
                def.isActive(),
                def.getTests().stream().map(t -> AssessmentTestResponse.from(t, locale)).toList(),
                def.resolveField(AssessmentDefinition.FIELD_NAME, locale).orElse(null),
                def.resolveField(AssessmentDefinition.FIELD_DESCRIPTION, locale).orElse(null),
                def.resolveField(AssessmentDefinition.FIELD_PROTOCOL, locale).orElse(null),
                def.getCreatedAt(),
                def.getUpdatedAt());
    }
}
