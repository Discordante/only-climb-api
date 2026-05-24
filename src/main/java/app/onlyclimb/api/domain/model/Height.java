package app.onlyclimb.api.domain.model;

import java.util.Objects;

/**
 * Height in centimeters. Optional on the profile. Range matches the DB CHECK.
 */
public final class Height {

    public static final int MIN_CM = 80;
    public static final int MAX_CM = 250;

    private final int cm;

    public Height(int cm) {
        if (cm < MIN_CM || cm > MAX_CM) {
            throw new IllegalArgumentException(
                    "Height must be between " + MIN_CM + " and " + MAX_CM + " cm");
        }
        this.cm = cm;
    }

    public int cm() {
        return cm;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Height other)) return false;
        return cm == other.cm;
    }

    @Override
    public int hashCode() {
        return Objects.hash(cm);
    }
}
