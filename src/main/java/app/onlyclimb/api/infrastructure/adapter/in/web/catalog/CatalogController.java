package app.onlyclimb.api.infrastructure.adapter.in.web.catalog;

import app.onlyclimb.api.domain.model.CatalogType;
import app.onlyclimb.api.domain.model.GradeScale;
import app.onlyclimb.api.domain.port.in.ListCatalogUseCase;
import app.onlyclimb.api.domain.port.in.ListClimbingGradesUseCase;
import app.onlyclimb.api.infrastructure.adapter.in.web.catalog.dto.CatalogEntryResponse;
import app.onlyclimb.api.infrastructure.adapter.in.web.catalog.dto.ClimbingGradeEntryResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/catalogs")
@RequiredArgsConstructor
public class CatalogController {

    private final ListCatalogUseCase listCatalogUseCase;
    private final ListClimbingGradesUseCase listClimbingGradesUseCase;

    @GetMapping("/exercise-categories")
    public ResponseEntity<List<CatalogEntryResponse>> listExerciseCategories(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.EXERCISE_CATEGORY, locale);
    }

    @GetMapping("/muscle-groups")
    public ResponseEntity<List<CatalogEntryResponse>> listMuscleGroups(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.MUSCLE_GROUP, locale);
    }

    @GetMapping("/grip-types")
    public ResponseEntity<List<CatalogEntryResponse>> listGripTypes(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.GRIP_TYPE, locale);
    }

    @GetMapping("/parameter-types")
    public ResponseEntity<List<CatalogEntryResponse>> listParameterTypes(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.PARAMETER_TYPE, locale);
    }

    @GetMapping("/goal-types")
    public ResponseEntity<List<CatalogEntryResponse>> listGoalTypes(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.GOAL_TYPE, locale);
    }

    @GetMapping("/equipment")
    public ResponseEntity<List<CatalogEntryResponse>> listEquipment(
            @RequestParam(defaultValue = "es") String locale) {
        return list(CatalogType.EQUIPMENT, locale);
    }

    @GetMapping("/climbing-grades")
    public ResponseEntity<List<ClimbingGradeEntryResponse>> listClimbingGrades(
            @RequestParam(required = false) GradeScale scale) {
        List<ClimbingGradeEntryResponse> body = listClimbingGradesUseCase.list(scale).stream()
                .map(ClimbingGradeEntryResponse::from)
                .toList();
        return ResponseEntity.ok(body);
    }

    private ResponseEntity<List<CatalogEntryResponse>> list(CatalogType type, String locale) {
        List<CatalogEntryResponse> body = listCatalogUseCase.list(type).stream()
                .map(entry -> CatalogEntryResponse.from(entry, locale))
                .toList();
        return ResponseEntity.ok(body);
    }
}
