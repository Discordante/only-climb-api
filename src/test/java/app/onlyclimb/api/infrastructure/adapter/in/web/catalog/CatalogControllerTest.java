package app.onlyclimb.api.infrastructure.adapter.in.web.catalog;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;
import app.onlyclimb.api.domain.model.ClimbingGrade;
import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.port.in.GetUserUseCase;
import app.onlyclimb.api.domain.port.in.ListCatalogUseCase;
import app.onlyclimb.api.domain.port.in.ListClimbingGradesUseCase;
import app.onlyclimb.api.domain.port.out.UserRepository;
import app.onlyclimb.api.infrastructure.adapter.in.web.GlobalExceptionHandler;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.ClerkJwtAuthenticationConverter;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.CurrentUserService;
import app.onlyclimb.api.infrastructure.adapter.in.web.auth.UserAuthorization;
import app.onlyclimb.api.infrastructure.config.SecurityConfig;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(CatalogController.class)
@Import({
        GlobalExceptionHandler.class,
        SecurityConfig.class,
        UserAuthorization.class,
        CurrentUserService.class
})
class CatalogControllerTest {

    @Autowired MockMvc mockMvc;

    @MockitoBean ListCatalogUseCase listCatalogUseCase;
    @MockitoBean ListClimbingGradesUseCase listClimbingGradesUseCase;
    @MockitoBean GetUserUseCase getUserUseCase;
    @MockitoBean UserRepository userRepository;
    @MockitoBean ClerkJwtAuthenticationConverter clerkJwtAuthenticationConverter;

    @Test
    void listsEquipmentInSpanishByDefault() throws Exception {
        CatalogEntry hangboard = new CatalogEntry(
                UUID.randomUUID(), "HANGBOARD", 10, Map.of(),
                List.of(
                        new Translation("es", CatalogEntry.FIELD_NAME, "Hangboard ES"),
                        new Translation("en", CatalogEntry.FIELD_NAME, "Hangboard EN")));
        given(listCatalogUseCase.list(CatalogType.EQUIPMENT)).willReturn(List.of(hangboard));

        mockMvc.perform(get("/api/v1/catalogs/equipment"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].code").value("HANGBOARD"))
                .andExpect(jsonPath("$[0].name").value("Hangboard ES"));
    }

    @Test
    void honorsRequestedLocale() throws Exception {
        CatalogEntry hangboard = new CatalogEntry(
                UUID.randomUUID(), "HANGBOARD", 10, Map.of(),
                List.of(
                        new Translation("es", CatalogEntry.FIELD_NAME, "Hangboard ES"),
                        new Translation("en", CatalogEntry.FIELD_NAME, "Hangboard EN")));
        given(listCatalogUseCase.list(CatalogType.EQUIPMENT)).willReturn(List.of(hangboard));

        mockMvc.perform(get("/api/v1/catalogs/equipment").param("locale", "en"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("Hangboard EN"));
    }

    @Test
    void exposesMetadataForParameterTypes() throws Exception {
        CatalogEntry reps = new CatalogEntry(
                UUID.randomUUID(), "REPS", 10,
                Map.of("unit", "count", "valueType", "INTEGER"),
                List.of(new Translation("es", CatalogEntry.FIELD_NAME, "Repeticiones")));
        given(listCatalogUseCase.list(CatalogType.PARAMETER_TYPE)).willReturn(List.of(reps));

        mockMvc.perform(get("/api/v1/catalogs/parameter-types"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].metadata.unit").value("count"))
                .andExpect(jsonPath("$[0].metadata.valueType").value("INTEGER"));
    }

    @Test
    void climbingGradesFilteredByScale() throws Exception {
        ClimbingGradeEntry seven = new ClimbingGradeEntry(
                new ClimbingGrade(GradeScale.FRENCH, "7a"), 400);
        given(listClimbingGradesUseCase.list(GradeScale.FRENCH)).willReturn(List.of(seven));

        mockMvc.perform(get("/api/v1/catalogs/climbing-grades").param("scale", "FRENCH"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].scale").value("FRENCH"))
                .andExpect(jsonPath("$[0].value").value("7a"));
    }

    @Test
    void climbingGradesAreReadablePublicly() throws Exception {
        given(listClimbingGradesUseCase.list(null)).willReturn(List.of());

        mockMvc.perform(get("/api/v1/catalogs/climbing-grades"))
                .andExpect(status().isOk());
    }
}
