package app.onlyclimb.api.domain.port.in;

import app.onlyclimb.api.domain.model.ClimbingDiscipline;

import java.math.BigDecimal;

public record UpdateUserProfileCommand(
        String displayName,
        BigDecimal weightKg,
        Integer heightCm,
        ClimbingDiscipline primaryDiscipline,
        String locale
) {}
