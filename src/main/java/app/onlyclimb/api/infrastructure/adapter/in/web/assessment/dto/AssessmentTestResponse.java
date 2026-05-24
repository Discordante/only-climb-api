package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

import app.onlyclimb.api.domain.model.AssessmentTest;
import app.onlyclimb.api.domain.model.AssessmentValueType;

import java.util.UUID;

public record AssessmentTestResponse(
        UUID id,
        String code,
        int position,
        String unit,
        AssessmentValueType valueType,
        String name,
        String description,
        String protocol) {

    public static AssessmentTestResponse from(AssessmentTest test, String locale) {
        return new AssessmentTestResponse(
                test.getId(),
                test.getCode(),
                test.getPosition(),
                test.getUnit(),
                test.getValueType(),
                test.resolveField(AssessmentTest.FIELD_NAME, locale).orElse(null),
                test.resolveField(AssessmentTest.FIELD_DESCRIPTION, locale).orElse(null),
                test.resolveField(AssessmentTest.FIELD_PROTOCOL, locale).orElse(null));
    }
}
