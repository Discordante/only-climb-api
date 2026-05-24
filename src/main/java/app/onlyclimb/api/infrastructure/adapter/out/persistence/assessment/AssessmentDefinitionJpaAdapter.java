package app.onlyclimb.api.infrastructure.adapter.out.persistence.assessment;

import app.onlyclimb.api.domain.model.AssessmentDefinition;
import app.onlyclimb.api.domain.model.AssessmentTest;
import app.onlyclimb.api.domain.model.ClimbingDiscipline;
import app.onlyclimb.api.domain.model.Translation;
import app.onlyclimb.api.domain.port.out.AssessmentDefinitionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Transactional(readOnly = true)
class AssessmentDefinitionJpaAdapter implements AssessmentDefinitionRepository {

    private final SpringDataAssessmentDefinitionRepository definitionRepo;
    private final SpringDataAssessmentTestRepository testRepo;
    private final SpringDataAssessmentDefinitionTranslationRepository defTranslationRepo;
    private final SpringDataAssessmentTestTranslationRepository testTranslationRepo;

    @Override
    public Optional<AssessmentDefinition> findById(UUID id) {
        return definitionRepo.findByUuid(id).map(e -> toDomain(List.of(e)).get(0));
    }

    @Override
    public List<AssessmentDefinition> findActive(ClimbingDiscipline discipline) {
        List<AssessmentDefinitionJpaEntity> all = definitionRepo.findByActiveTrueOrderByCodeAsc();
        if (discipline != null) {
            all = all.stream()
                    .filter(e -> e.getTargetDiscipline() == discipline)
                    .toList();
        }
        return toDomain(all);
    }

    // ------------------------------------------------------------------

    private List<AssessmentDefinition> toDomain(List<AssessmentDefinitionJpaEntity> definitions) {
        if (definitions.isEmpty()) return List.of();
        List<Long> defIds = definitions.stream()
                .map(AssessmentDefinitionJpaEntity::getId)
                .toList();

        List<AssessmentTestJpaEntity> testRows = testRepo.findByDefinitionIdIn(defIds);
        Map<Long, List<AssessmentTestJpaEntity>> testsByDef = new HashMap<>();
        for (AssessmentTestJpaEntity t : testRows) {
            testsByDef.computeIfAbsent(t.getDefinitionId(), k -> new ArrayList<>()).add(t);
        }

        List<Long> testIds = testRows.stream().map(AssessmentTestJpaEntity::getId).toList();
        Map<Long, List<AssessmentTestTranslationJpaEntity>> testTransByTestId = new HashMap<>();
        if (!testIds.isEmpty()) {
            for (AssessmentTestTranslationJpaEntity row : testTranslationRepo.findByTestIdIn(testIds)) {
                testTransByTestId.computeIfAbsent(row.getTestId(), k -> new ArrayList<>()).add(row);
            }
        }

        Map<Long, List<AssessmentDefinitionTranslationJpaEntity>> defTransByDefId = new HashMap<>();
        for (AssessmentDefinitionTranslationJpaEntity row : defTranslationRepo.findByDefinitionIdIn(defIds)) {
            defTransByDefId.computeIfAbsent(row.getDefinitionId(), k -> new ArrayList<>()).add(row);
        }

        List<AssessmentDefinition> result = new ArrayList<>(definitions.size());
        for (AssessmentDefinitionJpaEntity def : definitions) {
            List<AssessmentTestJpaEntity> testList = testsByDef.getOrDefault(def.getId(), List.of());
            testList = new ArrayList<>(testList);
            testList.sort(Comparator.comparingInt(AssessmentTestJpaEntity::getPosition));

            List<AssessmentTest> tests = new ArrayList<>(testList.size());
            for (AssessmentTestJpaEntity t : testList) {
                List<Translation> testTranslations = testTransByTestId
                        .getOrDefault(t.getId(), List.of()).stream()
                        .map(r -> new Translation(r.getLocale(), r.getField(), r.getValue()))
                        .toList();
                tests.add(new AssessmentTest(
                        t.getUuid(), t.getCode(), t.getPosition(), t.getUnit(),
                        t.getValueType(), testTranslations));
            }

            List<Translation> defTranslations = defTransByDefId
                    .getOrDefault(def.getId(), List.of()).stream()
                    .map(r -> new Translation(r.getLocale(), r.getField(), r.getValue()))
                    .toList();

            result.add(new AssessmentDefinition(
                    def.getUuid(), def.getCode(), def.getTargetDiscipline(), def.isActive(),
                    tests, defTranslations, def.getCreatedAt(), def.getUpdatedAt()));
        }
        return result;
    }
}
