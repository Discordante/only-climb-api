package app.onlyclimb.api.infrastructure.adapter.in.web.user.dto;

import app.onlyclimb.api.domain.model.ClimbingDiscipline;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record UpdateUserProfileRequest(
        @Size(max = 100) String displayName,
        @DecimalMin("20.00") @DecimalMax("250.00") BigDecimal weightKg,
        @Min(80) @Max(250) Integer heightCm,
        ClimbingDiscipline primaryDiscipline,
        @Size(max = 10) String locale
) {}
