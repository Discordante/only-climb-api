package app.onlyclimb.api.infrastructure.adapter.in.web.assessment.dto;

/** Reusable translation DTO for inbound payloads (assessments slice). */
public record TranslationDto(String locale, String field, String value) {
}
