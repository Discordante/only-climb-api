package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;
import app.onlyclimb.api.domain.model.ClimbingGrade;
import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.port.out.CatalogReadRepository;
import app.onlyclimb.api.domain.port.out.ClimbingGradeRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.BDDMockito.given;

@ExtendWith(MockitoExtension.class)
class CatalogServiceTest {

    @Mock CatalogReadRepository catalogReadRepository;
    @Mock ClimbingGradeRepository climbingGradeRepository;
    @InjectMocks CatalogService service;

    @Test
    void listDelegatesToRepository() {
        CatalogEntry entry = new CatalogEntry(
                UUID.randomUUID(), "HANGBOARD", 10, Map.of(),
                List.of(new Translation("es", CatalogEntry.FIELD_NAME, "Hangboard")));
        given(catalogReadRepository.findAll(CatalogType.EQUIPMENT)).willReturn(List.of(entry));

        assertThat(service.list(CatalogType.EQUIPMENT)).containsExactly(entry);
    }

    @Test
    void listRejectsNullType() {
        assertThatThrownBy(() -> service.list((CatalogType) null))
                .isInstanceOf(NullPointerException.class);
    }

    @Test
    void listGradesPassesScaleThrough() {
        ClimbingGradeEntry french = new ClimbingGradeEntry(new ClimbingGrade(GradeScale.FRENCH, "7a"), 400);
        given(climbingGradeRepository.findAll(GradeScale.FRENCH)).willReturn(List.of(french));

        assertThat(service.list(GradeScale.FRENCH)).containsExactly(french);
    }

    @Test
    void listGradesAllowsNullScale() {
        given(climbingGradeRepository.findAll(null)).willReturn(List.of());

        assertThat(service.list((GradeScale) null)).isEmpty();
    }
}
