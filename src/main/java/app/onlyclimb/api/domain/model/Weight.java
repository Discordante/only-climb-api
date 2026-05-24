package app.onlyclimb.api.domain.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

/**
 * Body weight in kilograms. Mandatory for hangboard plans (strength-to-weight
 * ratio is a core climbing metric). Range mirrors the DB CHECK constraint.
 */
public final class Weight {

    public static final BigDecimal MIN_KG = new BigDecimal("20.00");
    public static final BigDecimal MAX_KG = new BigDecimal("250.00");

    private final BigDecimal kg;

    public Weight(BigDecimal kg) {
        if (kg == null) {
            throw new IllegalArgumentException("Weight cannot be null");
        }
        BigDecimal scaled = kg.setScale(2, RoundingMode.HALF_UP);
        if (scaled.compareTo(MIN_KG) < 0 || scaled.compareTo(MAX_KG) > 0) {
            throw new IllegalArgumentException(
                    "Weight must be between " + MIN_KG + " and " + MAX_KG + " kg");
        }
        this.kg = scaled;
    }

    public BigDecimal kg() {
        return kg;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Weight other)) return false;
        return kg.compareTo(other.kg) == 0;
    }

    @Override
    public int hashCode() {
        return Objects.hash(kg.stripTrailingZeros());
    }
}
