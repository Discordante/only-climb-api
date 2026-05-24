package app.onlyclimb.api.domain.model;

import java.util.Objects;
import java.util.regex.Pattern;

/**
 * Email value object. Trims and lowercases the input to keep equality
 * consistent with the case-insensitive uniqueness enforced at the DB level.
 */
public final class Email {

    // Pragmatic regex: not RFC 5322, but covers >99% of real-world emails.
    private static final Pattern PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private final String value;

    public Email(String value) {
        if (value == null) {
            throw new IllegalArgumentException("Email cannot be null");
        }
        String normalized = value.trim().toLowerCase();
        if (normalized.isEmpty()) {
            throw new IllegalArgumentException("Email cannot be blank");
        }
        if (normalized.length() > 320) {
            throw new IllegalArgumentException("Email exceeds 320 characters");
        }
        if (!PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("Email format is invalid");
        }
        this.value = normalized;
    }

    public String value() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Email other)) return false;
        return value.equals(other.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public String toString() {
        return value;
    }
}
