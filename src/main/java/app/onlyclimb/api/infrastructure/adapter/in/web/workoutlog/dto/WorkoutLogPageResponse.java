package app.onlyclimb.api.infrastructure.adapter.in.web.workoutlog.dto;

import java.util.List;

public record WorkoutLogPageResponse(List<WorkoutLogResponse> data, String nextCursor) {}
