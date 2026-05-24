package app.onlyclimb.api.infrastructure.adapter.in.web.user.dto;

import app.onlyclimb.api.domain.model.ClimbingDiscipline;
import app.onlyclimb.api.domain.model.Height;
import app.onlyclimb.api.domain.model.UserProfile;
import app.onlyclimb.api.domain.model.Weight;

import java.math.BigDecimal;
import java.util.UUID;

public record UserProfileResponse(
        UUID id,
        UUID userId,
        String displayName,
        BigDecimal weightKg,
        Integer heightCm,
        ClimbingDiscipline primaryDiscipline,
        String locale
) {
    public static UserProfileResponse from(UserProfile profile) {
        return new UserProfileResponse(
                profile.getId(),
                profile.getUserId(),
                profile.getDisplayName().orElse(null),
                profile.getWeight().map(Weight::kg).orElse(null),
                profile.getHeight().map(Height::cm).orElse(null),
                profile.getPrimaryDiscipline().orElse(null),
                profile.getLocale()
        );
    }
}
