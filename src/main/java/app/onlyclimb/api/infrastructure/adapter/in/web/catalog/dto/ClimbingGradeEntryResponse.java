package app.onlyclimb.api.infrastructure.adapter.in.web.catalog.dto;

import app.onlyclimb.api.domain.model.ClimbingGradeEntry;

public record ClimbingGradeEntryResponse(
        String scale,
        String value,
        int sortOrder) {

    public static ClimbingGradeEntryResponse from(ClimbingGradeEntry entry) {
        return new ClimbingGradeEntryResponse(
                entry.grade().getScale().name(),
                entry.grade().getValue(),
                entry.sortOrder());
    }
}
