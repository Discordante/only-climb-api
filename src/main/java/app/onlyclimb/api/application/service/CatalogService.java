package app.onlyclimb.api.application.service;

import app.onlyclimb.api.domain.model.CatalogEntry;
import app.onlyclimb.api.domain.model.CatalogType;
import app.onlyclimb.api.domain.model.ClimbingGradeEntry;
import app.onlyclimb.api.domain.model.GradeScale;
import app.onlyclimb.api.domain.port.in.ListCatalogUseCase;
import app.onlyclimb.api.domain.port.in.ListClimbingGradesUseCase;
import app.onlyclimb.api.domain.port.out.CatalogReadRepository;
import app.onlyclimb.api.domain.port.out.ClimbingGradeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class CatalogService implements ListCatalogUseCase, ListClimbingGradesUseCase {

    private final CatalogReadRepository catalogReadRepository;
    private final ClimbingGradeRepository climbingGradeRepository;

    @Override
    public List<CatalogEntry> list(CatalogType type) {
        Objects.requireNonNull(type, "type is required");
        return catalogReadRepository.findAll(type);
    }

    @Override
    public List<ClimbingGradeEntry> list(GradeScale scale) {
        return climbingGradeRepository.findAll(scale);
    }
}
