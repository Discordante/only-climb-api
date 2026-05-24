-- =============================================================================
-- V12 — Seed platform-curated assessment definitions.
-- Initial bundle: a single finger-strength assessment with three tests.
-- =============================================================================

INSERT INTO assessment_definitions (code, target_discipline, is_active)
VALUES ('LATTICE_FINGER_STRENGTH_V1', NULL, TRUE);

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'name', 'Lattice Finger Strength'
FROM assessment_definitions WHERE code = 'LATTICE_FINGER_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'description',
       'Measure absolute and relative finger strength on a 20 mm edge.'
FROM assessment_definitions WHERE code = 'LATTICE_FINGER_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'protocol',
       'Warm up 15 minutes. Perform three maximal 7-second hangs with full recovery.'
FROM assessment_definitions WHERE code = 'LATTICE_FINGER_STRENGTH_V1';

-- Tests --------------------------------------------------------------------

WITH def AS (SELECT id FROM assessment_definitions WHERE code = 'LATTICE_FINGER_STRENGTH_V1')
INSERT INTO assessment_tests (definition_id, code, position, unit, value_type)
SELECT def.id, t.code, t.position, t.unit, t.value_type
FROM def
CROSS JOIN (VALUES
    ('MAX_HANG_20MM_HALF_CRIMP', 1, 'kg', 'DECIMAL'),
    ('MAX_HANG_20MM_OPEN_HAND',  2, 'kg', 'DECIMAL'),
    ('BODYWEIGHT',               3, 'kg', 'DECIMAL')
) AS t(code, position, unit, value_type);

-- Test translations --------------------------------------------------------

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_HANG_20MM_HALF_CRIMP', 'Max hang 20 mm — half crimp'),
    ('MAX_HANG_20MM_OPEN_HAND',  'Max hang 20 mm — open hand'),
    ('BODYWEIGHT',               'Bodyweight')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'LATTICE_FINGER_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_HANG_20MM_HALF_CRIMP',
     'Add weight progressively. Record the maximum extra load held for 7 seconds.'),
    ('MAX_HANG_20MM_OPEN_HAND',
     'Add weight progressively. Record the maximum extra load held for 7 seconds.'),
    ('BODYWEIGHT',
     'Body mass at moment of testing, used to normalise other measurements.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'LATTICE_FINGER_STRENGTH_V1';
