-- =============================================================================
-- V18 — Mega-seed: complete platform content feed
-- =============================================================================
-- Populates ALL master / catalog tables with a rich, production-grade dataset.
--
-- Sections:
--   1. Enhanced translations for existing catalogs (descriptions)
--   2. Additional assessment definitions + tests
--   3. Platform media assets (placeholder references)
--   4. Platform exercises (20 exercises across all categories)
--   5. Platform workout templates (5 templates with exercises)
--   6. Platform training plans (4 plans with weeks + sessions)
--
-- Locales: ES (default) + EN (fallback). Every piece of content has both.
-- UUID namespaces:
--   a0* = assessment definitions     b0* = assessment tests
--   m0* = media assets               e0* = exercises
--   w0* = workout templates          p0* = training plans
--   k0* = training plan weeks        s0* = training plan sessions
-- =============================================================================

-- =============================================================================
-- 1. ENHANCED CATALOG TRANSLATIONS — add missing 'description' fields
-- =============================================================================

-- Muscle group descriptions ------------------------------------------------

INSERT INTO muscle_group_translations (muscle_group_id, locale, field, value)
SELECT m.id, t.locale, t.field, t.value FROM muscle_groups m
JOIN (VALUES
    ('FINGERS',   'es', 'description', 'Músculos flexores y lumbricales de los dedos.'),
    ('FINGERS',   'en', 'description', 'Finger flexors and lumbricals.'),
    ('FOREARM',   'es', 'description', 'Flexores y extensores del antebrazo.'),
    ('FOREARM',   'en', 'description', 'Forearm flexors and extensors.'),
    ('BACK',      'es', 'description', 'Dorsales, trapecio y romboides.'),
    ('BACK',      'en', 'description', 'Lats, traps and rhomboids.'),
    ('SHOULDERS', 'es', 'description', 'Deltoides y manguito rotador.'),
    ('SHOULDERS', 'en', 'description', 'Deltoids and rotator cuff.'),
    ('CORE',      'es', 'description', 'Abdominales, oblicuos y lumbar.'),
    ('CORE',      'en', 'description', 'Abs, obliques and lower back.'),
    ('CHEST',     'es', 'description', 'Pectoral mayor y menor.'),
    ('CHEST',     'en', 'description', 'Pectoralis major and minor.'),
    ('ARMS',      'es', 'description', 'Bíceps, tríceps y braquial.'),
    ('ARMS',      'en', 'description', 'Biceps, triceps and brachialis.'),
    ('LEGS',      'es', 'description', 'Cuádriceps, isquios y gemelos.'),
    ('LEGS',      'en', 'description', 'Quads, hamstrings and calves.'),
    ('FULL_BODY', 'es', 'description', 'Cadenas cinéticas completas del cuerpo.'),
    ('FULL_BODY', 'en', 'description', 'Full-body kinetic chains.')
) AS t(code, locale, field, value) ON m.code = t.code;

-- Parameter type descriptions -----------------------------------------------

INSERT INTO parameter_type_translations (parameter_type_id, locale, field, value)
SELECT p.id, t.locale, t.field, t.value FROM parameter_types p
JOIN (VALUES
    ('REPS',              'es', 'description', 'Número de repeticiones por serie.'),
    ('REPS',              'en', 'description', 'Number of repetitions per set.'),
    ('SETS',              'es', 'description', 'Número de series o rondas.'),
    ('SETS',              'en', 'description', 'Number of sets or rounds.'),
    ('REST_SECONDS',      'es', 'description', 'Tiempo de descanso entre series, en segundos.'),
    ('REST_SECONDS',      'en', 'description', 'Rest time between sets, in seconds.'),
    ('DURATION_SECONDS',  'es', 'description', 'Tiempo bajo tensión o duración del ejercicio.'),
    ('DURATION_SECONDS',  'en', 'description', 'Time under tension or exercise duration.'),
    ('WEIGHT_KG',         'es', 'description', 'Carga añadida o asistida en kilogramos.'),
    ('WEIGHT_KG',         'en', 'description', 'Added or assisted weight in kilograms.'),
    ('INTENSITY_PERCENT', 'es', 'description', 'Porcentaje respecto a la carga máxima.'),
    ('INTENSITY_PERCENT', 'en', 'description', 'Percentage of maximum load.'),
    ('EDGE_DEPTH_MM',     'es', 'description', 'Profundidad del canto de la regleta en milímetros.'),
    ('EDGE_DEPTH_MM',     'en', 'description', 'Hangboard edge depth in millimetres.'),
    ('GRIP_TYPE',         'es', 'description', 'Tipo de agarre a utilizar durante el ejercicio.'),
    ('GRIP_TYPE',         'en', 'description', 'Grip type to use during the exercise.'),
    ('RPE',               'es', 'description', 'Esfuerzo percibido en escala 1-10 (Borg CR10).'),
    ('RPE',               'en', 'description', 'Perceived exertion on 1-10 scale (Borg CR10).')
) AS t(code, locale, field, value) ON p.code = t.code;

-- Equipment descriptions ----------------------------------------------------

INSERT INTO equipment_translations (equipment_id, locale, field, value)
SELECT e.id, t.locale, t.field, t.value FROM equipment e
JOIN (VALUES
    ('HANGBOARD',       'es', 'description', 'Tabla de entrenamiento con regletas para colgar.'),
    ('HANGBOARD',       'en', 'description', 'Fingerboard for hanging exercises.'),
    ('PULLUP_BAR',      'es', 'description', 'Barra fija para dominadas y suspensiones.'),
    ('PULLUP_BAR',      'en', 'description', 'Fixed bar for pull-ups and hangs.'),
    ('WEIGHTED_BELT',   'es', 'description', 'Cinturón para añadir lastre con discos o pesas.'),
    ('WEIGHTED_BELT',   'en', 'description', 'Belt to add weight plates.'),
    ('RESISTANCE_BAND', 'es', 'description', 'Banda elástica de resistencia variable.'),
    ('RESISTANCE_BAND', 'en', 'description', 'Elastic band with variable resistance.'),
    ('CAMPUS_BOARD',    'es', 'description', 'Tabla inclinada con listones para pliometría de brazos.'),
    ('CAMPUS_BOARD',    'en', 'description', 'Inclined board with rungs for arm plyometrics.'),
    ('SLINGS',          'es', 'description', 'Anillas de gimnasia para ejercicios de suspensión.'),
    ('SLINGS',          'en', 'description', 'Gymnastics rings for suspension exercises.'),
    ('MOON_BOARD',      'es', 'description', 'Sistema estandarizado de presas LED con app.'),
    ('MOON_BOARD',      'en', 'description', 'Standardised LED hold system with companion app.'),
    ('KILTER_BOARD',    'es', 'description', 'Sistema de presas LED con app y ajuste de inclinación.'),
    ('KILTER_BOARD',    'en', 'description', 'LED hold system with app and adjustable angle.'),
    ('TINDEQ',          'es', 'description', 'Dinamómetro portátil para medir fuerza.'),
    ('TINDEQ',          'en', 'description', 'Portable dynamometer for strength measurement.'),
    ('FOAM_ROLLER',     'es', 'description', 'Rodillo de espuma para liberación miofascial.'),
    ('FOAM_ROLLER',     'en', 'description', 'Foam cylinder for myofascial release.')
) AS t(code, locale, field, value) ON e.code = t.code;


-- =============================================================================
-- 2. ADDITIONAL ASSESSMENT DEFINITIONS
-- =============================================================================

-- 2.1 Endurance Repeaters ----------------------------------------------------

INSERT INTO assessment_definitions (uuid, code, target_discipline, is_active)
VALUES ('09da2c07-8b57-4798-9755-7ed451b36c74', 'ENDURANCE_REPEATERS_V1', 'SPORT', TRUE);

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'name', 'Resistencia — Repetidores'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'description',
       'Mide la capacidad de resistencia de fuerza mediante un protocolo de repetidores (7 s colgado / 3 s descanso) al 70 % de la carga máxima.'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'protocol',
       'Calienta 15 min. Usa el 70 % de tu carga máxima en 20 mm medida en el test de fuerza. Realiza bloques de 6 repeticiones (7 s on / 3 s off) con 2 min de descanso entre bloques. Añade bloques hasta el fallo.'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'name', 'Endurance — Repeaters'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'description',
       'Measures power-endurance capacity through a repeaters protocol (7 s hang / 3 s rest) at 70 % of maximum load.'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'protocol',
       'Warm up 15 min. Use 70 % of your 20 mm max load from the strength test. Perform blocks of 6 reps (7 s on / 3 s off) with 2 min rest between blocks. Add blocks until failure.'
FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1';

-- Tests
WITH def AS (SELECT id FROM assessment_definitions WHERE code = 'ENDURANCE_REPEATERS_V1')
INSERT INTO assessment_tests (uuid, definition_id, code, position, unit, value_type)
SELECT gen_random_uuid(),
       def.id, t.code, t.pos, t.unit, t.value_type
FROM def
CROSS JOIN (VALUES
    ('HALF_CRIMP_BLOCKS_COMPLETED', 1, 'count',   'INTEGER'),
    ('OPEN_HAND_BLOCKS_COMPLETED',  2, 'count',   'INTEGER'),
    ('HALF_CRIMP_TOTAL_SECONDS',    3, 'seconds', 'INTEGER'),
    ('OPEN_HAND_TOTAL_SECONDS',     4, 'seconds', 'INTEGER'),
    ('REFERENCE_MAX_LOAD_KG',       5, 'kg',      'DECIMAL')
) AS t(code, pos, unit, value_type);

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('HALF_CRIMP_BLOCKS_COMPLETED', 'Bloques completados — semi-arqueo'),
    ('OPEN_HAND_BLOCKS_COMPLETED',  'Bloques completados — mano abierta'),
    ('HALF_CRIMP_TOTAL_SECONDS',    'Tiempo total bajo tensión — semi-arqueo'),
    ('OPEN_HAND_TOTAL_SECONDS',     'Tiempo total bajo tensión — mano abierta'),
    ('REFERENCE_MAX_LOAD_KG',       'Carga máxima de referencia (20 mm)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('HALF_CRIMP_BLOCKS_COMPLETED', 'Blocks completed — half crimp'),
    ('OPEN_HAND_BLOCKS_COMPLETED',  'Blocks completed — open hand'),
    ('HALF_CRIMP_TOTAL_SECONDS',    'Total time under tension — half crimp'),
    ('OPEN_HAND_TOTAL_SECONDS',     'Total time under tension — open hand'),
    ('REFERENCE_MAX_LOAD_KG',       'Reference max load (20 mm)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('HALF_CRIMP_BLOCKS_COMPLETED',
     'Número de bloques de 6 repeticiones completados en semi-arqueo antes del fallo.'),
    ('OPEN_HAND_BLOCKS_COMPLETED',
     'Número de bloques de 6 repeticiones completados en mano abierta antes del fallo.'),
    ('HALF_CRIMP_TOTAL_SECONDS',
     'Suma del tiempo total bajo tensión (7 s × reps × bloques) en semi-arqueo.'),
    ('OPEN_HAND_TOTAL_SECONDS',
     'Suma del tiempo total bajo tensión (7 s × reps × bloques) en mano abierta.'),
    ('REFERENCE_MAX_LOAD_KG',
     'Carga máxima en 20 mm del test de fuerza de dedos, usada para calcular el 70 %.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'ENDURANCE_REPEATERS_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('HALF_CRIMP_BLOCKS_COMPLETED',
     'Number of 6-rep blocks completed in half crimp before failure.'),
    ('OPEN_HAND_BLOCKS_COMPLETED',
     'Number of 6-rep blocks completed in open hand before failure.'),
    ('HALF_CRIMP_TOTAL_SECONDS',
     'Total time under tension (7 s × reps × blocks) in half crimp.'),
    ('OPEN_HAND_TOTAL_SECONDS',
     'Total time under tension (7 s × reps × blocks) in open hand.'),
    ('REFERENCE_MAX_LOAD_KG',
     'Max load on 20 mm from the finger strength test, used to compute 70 %.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'ENDURANCE_REPEATERS_V1';

-- 2.2 Pull Strength ----------------------------------------------------------

INSERT INTO assessment_definitions (uuid, code, target_discipline, is_active)
VALUES ('cc9b044d-259e-448b-89fe-c73586366200', 'PULL_STRENGTH_V1', NULL, TRUE);

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'name', 'Fuerza de tracción'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'description',
       'Evalúa la fuerza máxima de tracción mediante dominadas lastradas y test isométrico de bloqueo.'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'protocol',
       'Calienta 10 min con movilidad escapular. Mide tu peso corporal antes del test. Realiza máximas dominadas sin lastre y después test incremental con lastre hasta tu 1RM. Finaliza con un test de bloqueo isométrico a 90° con la carga de tu 1RM − 5 kg.'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'name', 'Pull Strength'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'description',
       'Evaluates maximum pulling strength through weighted pull-ups and an isometric lock-off test.'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'protocol',
       'Warm up 10 min with scapular mobility. Measure bodyweight beforehand. Perform max unweighted pull-ups, then incremental weighted test to find your 1RM. Finish with an isometric lock-off test at 90° using your 1RM − 5 kg.'
FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1';

-- Tests
WITH def AS (SELECT id FROM assessment_definitions WHERE code = 'PULL_STRENGTH_V1')
INSERT INTO assessment_tests (uuid, definition_id, code, position, unit, value_type)
SELECT gen_random_uuid(),
       def.id, t.code, t.pos, t.unit, t.value_type
FROM def
CROSS JOIN (VALUES
    ('MAX_PULLUPS_NO_WEIGHT',        1, 'count',   'INTEGER'),
    ('MAX_WEIGHTED_PULLUP_1RM_KG',   2, 'kg',      'DECIMAL'),
    ('LOCKOFF_90DEG_SECONDS',        3, 'seconds', 'INTEGER'),
    ('BODYWEIGHT_KG',                4, 'kg',      'DECIMAL')
) AS t(code, pos, unit, value_type);

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_PULLUPS_NO_WEIGHT',      'Máximo de dominadas sin lastre'),
    ('MAX_WEIGHTED_PULLUP_1RM_KG', 'Dominada lastrada — 1RM (kg)'),
    ('LOCKOFF_90DEG_SECONDS',      'Bloqueo isométrico a 90° (s)'),
    ('BODYWEIGHT_KG',              'Peso corporal (kg)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_PULLUPS_NO_WEIGHT',      'Max unweighted pull-ups'),
    ('MAX_WEIGHTED_PULLUP_1RM_KG', 'Weighted pull-up — 1RM (kg)'),
    ('LOCKOFF_90DEG_SECONDS',      'Isometric lock-off at 90° (s)'),
    ('BODYWEIGHT_KG',              'Bodyweight (kg)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_PULLUPS_NO_WEIGHT',
     'Realiza tantas dominadas completas como puedas sin pausa. Barbilla sobre la barra, codos extendidos abajo.'),
    ('MAX_WEIGHTED_PULLUP_1RM_KG',
     'Añade lastre progresivamente hasta encontrar la carga máxima con la que puedes completar una dominada.'),
    ('LOCKOFF_90DEG_SECONDS',
     'Con la carga de 1RM − 5 kg, mantén el bloqueo a 90° de flexión de codo el máximo tiempo posible.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'PULL_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('MAX_PULLUPS_NO_WEIGHT',
     'Perform as many full pull-ups as possible without pause. Chin over bar, full elbow extension at bottom.'),
    ('MAX_WEIGHTED_PULLUP_1RM_KG',
     'Add weight progressively to find the maximum load for a single full pull-up.'),
    ('LOCKOFF_90DEG_SECONDS',
     'With 1RM − 5 kg, hold the lock-off at 90° elbow flexion for as long as possible.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'PULL_STRENGTH_V1';

-- 2.3 Pinch Strength ---------------------------------------------------------

INSERT INTO assessment_definitions (uuid, code, target_discipline, is_active)
VALUES ('8887f4a7-8bf6-4191-a8ee-ac77953a277e', 'PINCH_STRENGTH_V1', 'BOULDER', TRUE);

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'name', 'Fuerza de pinza'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'description',
       'Mide la fuerza de pinza en bloque de 25 mm con lastre progresivo.'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'protocol',
       'Calienta 10 min. Usa un bloque de madera o plástico de 25 mm de ancho suspendido de una cuerda. Añade lastre progresivamente hasta el fallo. Registra la carga máxima sostenida 5 segundos.'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'name', 'Pinch Strength'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'description',
       'Measures pinch grip strength on a 25 mm block with progressive weight.'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'protocol',
       'Warm up 10 min. Use a 25 mm wood or plastic pinch block suspended from a cord. Add weight progressively until failure. Record the maximum load held for 5 seconds.'
FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1';

-- Tests
WITH def AS (SELECT id FROM assessment_definitions WHERE code = 'PINCH_STRENGTH_V1')
INSERT INTO assessment_tests (uuid, definition_id, code, position, unit, value_type)
SELECT gen_random_uuid(),
       def.id, t.code, t.pos, t.unit, t.value_type
FROM def
CROSS JOIN (VALUES
    ('PINCH_25MM_LEFT_KG',   1, 'kg', 'DECIMAL'),
    ('PINCH_25MM_RIGHT_KG',  2, 'kg', 'DECIMAL'),
    ('BODYWEIGHT_KG',        3, 'kg', 'DECIMAL')
) AS t(code, pos, unit, value_type);

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('PINCH_25MM_LEFT_KG',  'Pinza 25 mm — mano izquierda (kg)'),
    ('PINCH_25MM_RIGHT_KG', 'Pinza 25 mm — mano derecha (kg)'),
    ('BODYWEIGHT_KG',       'Peso corporal (kg)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('PINCH_25MM_LEFT_KG',  'Pinch 25 mm — left hand (kg)'),
    ('PINCH_25MM_RIGHT_KG', 'Pinch 25 mm — right hand (kg)'),
    ('BODYWEIGHT_KG',       'Bodyweight (kg)')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('PINCH_25MM_LEFT_KG',
     'Carga máxima sostenida 5 segundos con la mano izquierda en pinza de 25 mm.'),
    ('PINCH_25MM_RIGHT_KG',
     'Carga máxima sostenida 5 segundos con la mano derecha en pinza de 25 mm.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'PINCH_STRENGTH_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('PINCH_25MM_LEFT_KG',
     'Max load held for 5 seconds with the left hand on a 25 mm pinch.'),
    ('PINCH_25MM_RIGHT_KG',
     'Max load held for 5 seconds with the right hand on a 25 mm pinch.')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'PINCH_STRENGTH_V1';

-- 2.4 Body Composition -------------------------------------------------------

INSERT INTO assessment_definitions (uuid, code, target_discipline, is_active)
VALUES ('3e3e9376-8594-44d3-a99f-bcf1dcbd546f', 'BODY_COMPOSITION_V1', NULL, TRUE);

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'name', 'Composición corporal'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'description',
       'Registra métricas corporales básicas usadas para normalizar los tests de fuerza y calcular ratios fuerza/peso.'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'es', 'protocol',
       'Pésate por la mañana en ayunas con ropa ligera. Mide tu altura descalzo. Mide la envergadura de punta a punta con brazos extendidos en cruz. Usa siempre las mismas condiciones para seguimiento fiable.'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'name', 'Body Composition'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'description',
       'Records basic body metrics used to normalise strength tests and compute strength-to-weight ratios.'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_definition_translations (definition_id, locale, field, value)
SELECT id, 'en', 'protocol',
       'Weigh yourself in the morning fasted with light clothing. Measure height barefoot. Measure armspan fingertip to fingertip with arms outstretched. Always use the same conditions for reliable tracking.'
FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1';

-- Tests
WITH def AS (SELECT id FROM assessment_definitions WHERE code = 'BODY_COMPOSITION_V1')
INSERT INTO assessment_tests (uuid, definition_id, code, position, unit, value_type)
SELECT gen_random_uuid(),
       def.id, t.code, t.pos, t.unit, t.value_type
FROM def
CROSS JOIN (VALUES
    ('WEIGHT_KG',       1, 'kg',  'DECIMAL'),
    ('HEIGHT_CM',       2, 'cm',  'DECIMAL'),
    ('ARMSPAN_CM',      3, 'cm',  'DECIMAL'),
    ('BMI',             4, 'bmi', 'DECIMAL'),
    ('APE_INDEX',       5, 'ratio','DECIMAL')
) AS t(code, pos, unit, value_type);

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('WEIGHT_KG',   'Peso (kg)'),
    ('HEIGHT_CM',   'Altura (cm)'),
    ('ARMSPAN_CM',  'Envergadura (cm)'),
    ('BMI',         'Índice de Masa Corporal'),
    ('APE_INDEX',   'Índice de envergadura')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'name', n.name
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('WEIGHT_KG',   'Weight (kg)'),
    ('HEIGHT_CM',   'Height (cm)'),
    ('ARMSPAN_CM',  'Armspan (cm)'),
    ('BMI',         'Body Mass Index'),
    ('APE_INDEX',   'Ape index')
) AS n(code, name) ON n.code = t.code
WHERE d.code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'es', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('WEIGHT_KG',   'Peso corporal en ayunas, con ropa ligera, en báscula digital.'),
    ('HEIGHT_CM',   'Altura descalzo de pie contra la pared, con tallímetro o cinta.'),
    ('ARMSPAN_CM',  'Distancia de punta a punta de los dedos con brazos en cruz.'),
    ('BMI',         'Calculado automáticamente como peso (kg) / altura² (m).'),
    ('APE_INDEX',   'Calculado automáticamente como envergadura (cm) − altura (cm).')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'BODY_COMPOSITION_V1';

INSERT INTO assessment_test_translations (test_id, locale, field, value)
SELECT t.id, 'en', 'protocol', p.protocol
FROM assessment_tests t
JOIN assessment_definitions d ON d.id = t.definition_id
JOIN (VALUES
    ('WEIGHT_KG',   'Bodyweight fasted, with light clothing, on a digital scale.'),
    ('HEIGHT_CM',   'Height barefoot standing against a wall, with stadiometer or tape.'),
    ('ARMSPAN_CM',  'Distance from fingertip to fingertip with arms outstretched.'),
    ('BMI',         'Automatically computed as weight (kg) / height² (m).'),
    ('APE_INDEX',   'Automatically computed as armspan (cm) − height (cm).')
) AS p(code, protocol) ON p.code = t.code
WHERE d.code = 'BODY_COMPOSITION_V1';


-- =============================================================================
-- 3. PLATFORM MEDIA ASSETS — placeholder references for exercises
-- =============================================================================
-- These use EXTERNAL_URL provider pointing to placeholder images so the
-- platform always has visual content for exercises.

INSERT INTO media_assets (uuid, uploader_id, type, storage_provider, storage_key,
                          mime_type, size_bytes, width_px, height_px,
                          processing_status, visibility, alt_text)
VALUES
    ('0dacdcd0-647c-439f-af96-7886c1fedfc9', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/hangboard-half-crimp.jpg',
     'image/jpeg', 45000, 800, 600, 'READY', 'PUBLIC', 'Half crimp hang on a 20 mm edge'),
    ('81fcdb79-1664-42cb-bc8a-62732ca71709', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/hangboard-open-hand.jpg',
     'image/jpeg', 42000, 800, 600, 'READY', 'PUBLIC', 'Open hand hang on a 20 mm edge'),
    ('d236fdc8-d225-4d48-b0f5-ec24a18ecffc', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/pullup-weighted.jpg',
     'image/jpeg', 48000, 800, 600, 'READY', 'PUBLIC', 'Weighted pull-up demonstration'),
    ('76e38792-cac6-45f6-9fa2-5492ce9f4563', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/front-lever-progression.jpg',
     'image/jpeg', 44000, 800, 600, 'READY', 'PUBLIC', 'Front lever progression tuck position'),
    ('00b226f3-3edc-47a5-b00e-8ef95926449f', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/hollow-body.jpg',
     'image/jpeg', 38000, 800, 600, 'READY', 'PUBLIC', 'Hollow body hold position'),
    ('181bf1e7-3a38-4cac-a709-fb668211ed66', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/wrist-reverse-curl.jpg',
     'image/jpeg', 36000, 800, 600, 'READY', 'PUBLIC', 'Reverse wrist curl with dumbbell'),
    ('6a20a813-9a4e-4a8e-a708-e2bb394830be', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/shoulder-external-rotation.jpg',
     'image/jpeg', 35000, 800, 600, 'READY', 'PUBLIC', 'Shoulder external rotation with band'),
    ('be06779b-651b-434a-a7d1-de1bd27509d4', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/thoracic-mobility.jpg',
     'image/jpeg', 40000, 800, 600, 'READY', 'PUBLIC', 'Thoracic spine mobility drill'),
    ('d3489d7f-7c2c-4c0c-b6d4-b1907470ddb1', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/arc-training.jpg',
     'image/jpeg', 46000, 800, 600, 'READY', 'PUBLIC', 'ARC training on a spray wall'),
    ('e5b36595-532b-4082-9735-f8bb35e3a951', NULL, 'IMAGE', 'EXTERNAL_URL',
     'https://assets.onlyclimb.app/placeholder/campus-board.jpg',
     'image/jpeg', 50000, 800, 600, 'READY', 'PUBLIC', 'Campus board basic ladder');

-- Media translations (ES + EN alt_text)
INSERT INTO media_asset_translations (media_id, locale, field, value)
SELECT m.id, t.locale, t.field, t.value FROM media_assets m
JOIN (VALUES
    ('0dacdcd0-647c-439f-af96-7886c1fedfc9', 'es', 'alt_text', 'Suspensión en semi-arqueo sobre regleta de 20 mm'),
    ('0dacdcd0-647c-439f-af96-7886c1fedfc9', 'en', 'alt_text', 'Half crimp hang on 20 mm edge'),
    ('81fcdb79-1664-42cb-bc8a-62732ca71709', 'es', 'alt_text', 'Suspensión en mano abierta sobre regleta de 20 mm'),
    ('81fcdb79-1664-42cb-bc8a-62732ca71709', 'en', 'alt_text', 'Open hand hang on 20 mm edge'),
    ('d236fdc8-d225-4d48-b0f5-ec24a18ecffc', 'es', 'alt_text', 'Demostración de dominada lastrada'),
    ('d236fdc8-d225-4d48-b0f5-ec24a18ecffc', 'en', 'alt_text', 'Weighted pull-up demonstration'),
    ('76e38792-cac6-45f6-9fa2-5492ce9f4563', 'es', 'alt_text', 'Progresión de front lever en posición agrupada'),
    ('76e38792-cac6-45f6-9fa2-5492ce9f4563', 'en', 'alt_text', 'Front lever progression in tuck position'),
    ('00b226f3-3edc-47a5-b00e-8ef95926449f', 'es', 'alt_text', 'Posición de hollow body hold'),
    ('00b226f3-3edc-47a5-b00e-8ef95926449f', 'en', 'alt_text', 'Hollow body hold position'),
    ('181bf1e7-3a38-4cac-a709-fb668211ed66', 'es', 'alt_text', 'Curl de muñeca inverso con mancuerna'),
    ('181bf1e7-3a38-4cac-a709-fb668211ed66', 'en', 'alt_text', 'Reverse wrist curl with dumbbell'),
    ('6a20a813-9a4e-4a8e-a708-e2bb394830be', 'es', 'alt_text', 'Rotación externa de hombro con banda elástica'),
    ('6a20a813-9a4e-4a8e-a708-e2bb394830be', 'en', 'alt_text', 'Shoulder external rotation with band'),
    ('be06779b-651b-434a-a7d1-de1bd27509d4', 'es', 'alt_text', 'Ejercicio de movilidad de columna torácica'),
    ('be06779b-651b-434a-a7d1-de1bd27509d4', 'en', 'alt_text', 'Thoracic spine mobility drill'),
    ('d3489d7f-7c2c-4c0c-b6d4-b1907470ddb1', 'es', 'alt_text', 'Entrenamiento ARC en plafón de travesías'),
    ('d3489d7f-7c2c-4c0c-b6d4-b1907470ddb1', 'en', 'alt_text', 'ARC training on a spray wall'),
    ('e5b36595-532b-4082-9735-f8bb35e3a951', 'es', 'alt_text', 'Escalera básica en campus board'),
    ('e5b36595-532b-4082-9735-f8bb35e3a951', 'en', 'alt_text', 'Campus board basic ladder')
) AS t(media_uuid, locale, field, value) ON m.uuid = t.media_uuid::uuid;


-- =============================================================================
-- 4. PLATFORM EXERCISES — 20 exercises across all 7 categories
-- =============================================================================
-- Each exercise gets: metadata row, ES+EN translations (name, short_description,
-- description, execution_instructions, common_mistakes, progressions, safety_notes),
-- allowed_parameters, secondary_muscles, equipment, and media reference.

-- Helper: insert an exercise and return its row. We use a sequence of INSERTs
-- with sub-selects for category and muscle group lookups.

-- 4.1 HANGBOARD exercises ----------------------------------------------------

-- E01: Max Hang 20mm Half Crimp
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 20, 'HIGH'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'HANGBOARD' AND mg.code = 'FINGERS';

-- E01 translations ES
INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Suspensión máxima en semi-arqueo — 20 mm'),
    ('short_description', 'Colgada máxima en regleta de 20 mm con agarre de semi-arqueo.'),
    ('description', 'Ejercicio fundamental para medir y desarrollar la fuerza máxima de los dedos. Se realiza en una regleta de 20 mm añadiendo lastre progresivamente. La suspensión dura 7 segundos con recuperación completa (2-3 minutos) entre series. Es el ejercicio de referencia para tests de fuerza de dedos.'),
    ('execution_instructions', '1. Calienta progresivamente en la regleta 15 min.\n2. Añade lastre hasta llegar a tu carga de trabajo (~85-90 % RM).\n3. Colócate en posición de semi-arqueo: falanges a 90°, pulgar sin bloquear.\n4. Suspende 7 segundos manteniendo los hombros activos.\n5. Reposa 2-3 minutos.\n6. Repite 4-6 series.'),
    ('common_mistakes', '• Colapsar el arco y pasar a arqueo completo sin darse cuenta.\n• No activar los hombros (colgarse pasivamente).\n• Usar demasiado lastre demasiado pronto.\n• Acortar el descanso entre series.'),
    ('progressions', '• Aumenta la carga un 2.5 % cuando completes todas las series con calidad.\n• Reduce el canto a 15 mm para mayor intensidad.\n• Progresa a colgadas a un brazo con polea de asistencia.'),
    ('safety_notes', '• ALTO riesgo de lesión en poleas. No hagas este ejercicio más de 2 veces por semana.\n• Para inmediatamente si sientes dolor agudo.\n• No combines con bloqueos de campus el mismo día.\n• Usa cinta de poleas si tienes molestias previas.')
) AS f(field, value)
WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

-- E01 translations EN
INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Max Hang 20 mm — Half Crimp'),
    ('short_description', 'Maximum hang on a 20 mm edge using a half-crimp grip.'),
    ('description', 'Core exercise to measure and develop maximum finger strength. Performed on a 20 mm edge with progressively added weight. The hang lasts 7 seconds with full recovery (2-3 minutes) between sets. This is the reference exercise for finger strength tests.'),
    ('execution_instructions', '1. Warm up progressively on the edge for 15 min.\n2. Add weight until reaching your working load (~85-90 % 1RM).\n3. Assume half-crimp position: fingers at 90°, no thumb wrap.\n4. Hang for 7 seconds keeping shoulders engaged.\n5. Rest 2-3 minutes.\n6. Repeat for 4-6 sets.'),
    ('common_mistakes', '• Collapsing into a full crimp without noticing.\n• Not engaging shoulders (passive hang).\n• Using too much weight too soon.\n• Cutting rest between sets short.'),
    ('progressions', '• Increase load by 2.5 % when all sets are completed with good form.\n• Reduce edge to 15 mm for greater intensity.\n• Progress to one-arm hangs with pulley assistance.'),
    ('safety_notes', '• HIGH pulley injury risk. Do not perform more than twice per week.\n• Stop immediately if you feel sharp pain.\n• Do not combine with campus board on the same day.\n• Use pulley tape if you have prior discomfort.')
) AS f(field, value)
WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

-- E01 allowed parameters
INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS',  TRUE,  '7'),
    ('SETS',              TRUE,  '5'),
    ('REST_SECONDS',      TRUE,  '180'),
    ('WEIGHT_KG',         TRUE,  '0'),
    ('EDGE_DEPTH_MM',     TRUE,  '20'),
    ('GRIP_TYPE',         TRUE,  'HALF_CRIMP'),
    ('RPE',               FALSE, NULL)
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

-- E01 secondary muscles
INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9' AND mg.code IN ('FOREARM', 'SHOULDERS', 'BACK');

-- E01 equipment
INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9' AND eq.code = 'HANGBOARD';

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9' AND eq.code = 'WEIGHTED_BELT';

-- E01 media
INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND m.uuid = '0dacdcd0-647c-439f-af96-7886c1fedfc9';


-- E02: Max Hang 20mm Open Hand
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'bd985851-6a9e-4838-99d2-732a04010a49',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 20, 'HIGH'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'HANGBOARD' AND mg.code = 'FINGERS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Suspensión máxima en mano abierta — 20 mm'),
    ('short_description', 'Colgada máxima en regleta de 20 mm con agarre de mano abierta (extensión).'),
    ('description', 'Variante del ejercicio de fuerza máxima usando el agarre de mano abierta. La mano abierta distribuye la carga de forma diferente al semi-arqueo, reduciendo el estrés en las poleas A2 y A4 a costa de mayor exigencia en los músculos intrínsecos. Fundamental para desarrollar perfiles de fuerza completos.'),
    ('execution_instructions', '1. Calienta 15 min progresivamente.\n2. Coloca los dedos en la regleta con las falanges extendidas.\n3. Suspende 7 segundos con los hombros activos.\n4. Descansa 2-3 minutos entre series.\n5. Realiza 4-6 series.'),
    ('common_mistakes', '• Dejar que los dedos se flexionen hacia semi-arqueo al fatigarse.\n• No activar la musculatura intrínseca de la mano.\n• Usar el mismo lastre que en semi-arqueo (suele ser menor).'),
    ('progressions', '• Compara tus cargas en semi-arqueo vs mano abierta. El ratio ideal es > 85 %.\n• Si la mano abierta está muy por debajo, dedica más volumen a este agarre.'),
    ('safety_notes', '• Mismo riesgo que la variante en semi-arqueo.\n• No entrenes ambos agarres al máximo el mismo día.')
) AS f(field, value)
WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Max Hang 20 mm — Open Hand'),
    ('short_description', 'Maximum hang on a 20 mm edge using an open-hand grip.'),
    ('description', 'Variant of the max strength exercise using the open-hand grip. The open hand distributes load differently than half crimp, reducing stress on the A2 and A4 pulleys at the cost of greater demand on intrinsic hand muscles. Essential for developing complete strength profiles.'),
    ('execution_instructions', '1. Warm up progressively for 15 min.\n2. Place fingers on the edge with extended phalanges.\n3. Hang for 7 seconds keeping shoulders engaged.\n4. Rest 2-3 minutes between sets.\n5. Perform 4-6 sets.'),
    ('common_mistakes', '• Letting fingers flex into a half crimp as fatigue sets in.\n• Not engaging intrinsic hand muscles.\n• Using the same weight as half crimp (typically lower).'),
    ('progressions', '• Compare your half-crimp vs open-hand loads. The ideal ratio is > 85 %.\n• If open hand is significantly lower, dedicate more volume to this grip.'),
    ('safety_notes', '• Same risk as the half-crimp variant.\n• Do not train both grips at max on the same day.')
) AS f(field, value)
WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS',  TRUE,  '7'),
    ('SETS',              TRUE,  '5'),
    ('REST_SECONDS',      TRUE,  '180'),
    ('WEIGHT_KG',         TRUE,  '0'),
    ('EDGE_DEPTH_MM',     TRUE,  '20'),
    ('GRIP_TYPE',         TRUE,  'OPEN_HAND'),
    ('RPE',               FALSE, NULL)
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49' AND mg.code IN ('FOREARM', 'SHOULDERS');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49' AND eq.code = 'HANGBOARD';

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49' AND eq.code = 'WEIGHTED_BELT';

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
  AND m.uuid = '81fcdb79-1664-42cb-bc8a-62732ca71709';


-- E03: Repeaters — 20mm Half Crimp
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '0d5487ca-afc2-44ff-a5b0-b0e2713f2874',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 25, 'MODERATE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'HANGBOARD' AND mg.code = 'FINGERS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Repetidores — 20 mm semi-arqueo'),
    ('short_description', 'Protocolo de repetidores (7 s on / 3 s off) para resistencia de fuerza en regleta de 20 mm.'),
    ('description', 'Protocolo clásico de repetidores que desarrolla resistencia de fuerza específica para escalada. Se realizan bloques de 6 repeticiones (7 segundos colgado, 3 segundos de descanso) con 2 minutos entre bloques. La carga es del 70-80 % de la RM en 20 mm. Ideal para resistir el bombeo en vías largas.'),
    ('execution_instructions', '1. Calcula tu carga al 70 % de tu RM en 20 mm semi-arqueo.\n2. Calienta 15 min.\n3. Realiza 6 repeticiones de 7 s on / 3 s off (1 bloque).\n4. Descansa 2 min entre bloques.\n5. Completa 4-8 bloques según tu nivel.'),
    ('common_mistakes', '• Perder el ritmo 7/3 al fatigarse.\n• Usar una carga demasiado alta y fallar en el segundo bloque.\n• No contar mentalmente los segundos (usa un timer específico).'),
    ('progressions', '• Añade 1 bloque por semana hasta llegar a 8.\n• Sube la carga un 2.5 % cada 2 semanas.\n• Reduce el canto a 15 mm para mayor especificidad.'),
    ('safety_notes', '• El fallo en repetidores puede ser brusco; ten una silla o suelo cerca.\n• No hagas repetidores y máximos el mismo día.')
) AS f(field, value)
WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Repeaters — 20 mm Half Crimp'),
    ('short_description', 'Repeaters protocol (7 s on / 3 s off) for power endurance on a 20 mm edge.'),
    ('description', 'Classic repeaters protocol that builds climbing-specific power endurance. Blocks of 6 reps (7 seconds on, 3 seconds off) are performed with 2 minutes between blocks. Load is 70-80 % of 20 mm 1RM. Ideal for resisting pump on long routes.'),
    ('execution_instructions', '1. Calculate your load at 70 % of your 20 mm half-crimp 1RM.\n2. Warm up 15 min.\n3. Perform 6 reps of 7 s on / 3 s off (1 block).\n4. Rest 2 min between blocks.\n5. Complete 4-8 blocks depending on level.'),
    ('common_mistakes', '• Losing the 7/3 rhythm as fatigue sets in.\n• Using too high a load and failing on the second block.\n• Not counting seconds mentally (use a dedicated timer).'),
    ('progressions', '• Add 1 block per week until reaching 8.\n• Increase load by 2.5 % every 2 weeks.\n• Reduce edge to 15 mm for greater specificity.'),
    ('safety_notes', '• Failure on repeaters can be sudden; have a chair or floor nearby.\n• Do not combine repeaters and max hangs on the same day.')
) AS f(field, value)
WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS',  TRUE,  '7'),
    ('SETS',              TRUE,  '6'),
    ('REST_SECONDS',      TRUE,  '120'),
    ('WEIGHT_KG',         TRUE,  '0'),
    ('EDGE_DEPTH_MM',     TRUE,  '20'),
    ('GRIP_TYPE',         TRUE,  'HALF_CRIMP'),
    ('RPE',               FALSE, '7')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874' AND mg.code IN ('FOREARM', 'SHOULDERS', 'BACK');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874' AND eq.code = 'HANGBOARD';

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874' AND eq.code = 'WEIGHTED_BELT';


-- E04: Density Hangs — 30mm
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '82b2d80b-a34b-488b-b831-e141727628a9',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, TRUE, FALSE, 15, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'HANGBOARD' AND mg.code = 'FINGERS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Colgadas de densidad — 30 mm'),
    ('short_description', 'Suspensiones largas de 30 segundos en canto grande para fortalecer tejido conectivo.'),
    ('description', 'Ejercicio de baja intensidad y larga duración orientado a fortalecer las poleas y tendones. Se usa un canto de 30 mm o superior y se suspende durante 30 segundos con poco o ningún lastre. Es ideal para principiantes y para fases de rehabilitación o mantenimiento.'),
    ('execution_instructions', '1. Sin calentamiento extenso, colócate en una regleta de 30 mm.\n2. Suspende 30 segundos en semi-arqueo suave.\n3. Descansa 1-2 minutos.\n4. Repite 3-5 series.\n5. No añadas lastre hasta que completes 5 × 30 s con facilidad.'),
    ('common_mistakes', '• Usar cantos demasiado pequeños.\n• Añadir lastre prematuramente.\n• No completar los 30 segundos (descansa y vuelve a intentarlo).'),
    ('progressions', '• Reduce el canto de 30 → 25 → 20 mm progresivamente.\n• Añade 2.5 kg cuando 5 × 30 s sea trivial.'),
    ('safety_notes', '• Ejercicio muy seguro. Ideal para días de recuperación activa.\n• Si sientes molestias, aumenta el canto.')
) AS f(field, value)
WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Density Hangs — 30 mm'),
    ('short_description', 'Long 30-second hangs on a large edge to strengthen connective tissue.'),
    ('description', 'Low-intensity, long-duration exercise aimed at strengthening pulleys and tendons. Uses a 30 mm or larger edge with little to no added weight. Ideal for beginners and for rehabilitation or maintenance phases.'),
    ('execution_instructions', '1. Without extensive warm-up, position yourself on a 30 mm edge.\n2. Hang for 30 seconds in a gentle half crimp.\n3. Rest 1-2 minutes.\n4. Repeat 3-5 sets.\n5. Do not add weight until you can comfortably complete 5 × 30 s.'),
    ('common_mistakes', '• Using edges that are too small.\n• Adding weight prematurely.\n• Not completing the 30 seconds (rest and try again).'),
    ('progressions', '• Reduce edge from 30 → 25 → 20 mm progressively.\n• Add 2.5 kg when 5 × 30 s becomes trivial.'),
    ('safety_notes', '• Very safe exercise. Ideal for active recovery days.\n• If you feel discomfort, increase the edge size.')
) AS f(field, value)
WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS',  TRUE,  '30'),
    ('SETS',              TRUE,  '4'),
    ('REST_SECONDS',      TRUE,  '90'),
    ('WEIGHT_KG',         FALSE, '0'),
    ('EDGE_DEPTH_MM',     TRUE,  '30'),
    ('GRIP_TYPE',         TRUE,  'HALF_CRIMP'),
    ('RPE',               FALSE, '3')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '82b2d80b-a34b-488b-b831-e141727628a9' AND mg.code IN ('FOREARM');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '82b2d80b-a34b-488b-b831-e141727628a9' AND eq.code = 'HANGBOARD';


-- 4.2 PULL exercises --------------------------------------------------------

-- E05: Weighted Pull-Ups
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '0e2fb513-2655-471d-9811-c8f0d55b4a78',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 15, 'MODERATE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'PULL' AND mg.code = 'BACK';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Dominadas lastradas'),
    ('short_description', 'Dominadas con lastre añadido mediante cinturón o chaleco.'),
    ('description', 'Ejercicio compuesto principal para desarrollar fuerza de tracción en escalada. Se añade lastre progresivo mediante cinturón de discos o chaleco lastrado. El rango de movimiento completo (codos extendidos a barbilla sobre barra) es obligatorio. Fundamental para bloqueos y desplomes.'),
    ('execution_instructions', '1. Calienta con 2-3 series sin lastre.\n2. Añade el lastre objetivo.\n3. Realiza dominadas completas y controladas (2 s subida, 2 s bajada).\n4. Series de 3-5 repeticiones con alta carga.\n5. Descansa 2-3 min entre series.'),
    ('common_mistakes', '• No completar el rango (media dominada).\n• Usar impulso o balanceo.\n• Encoger los hombros al inicio (prioriza la depresión escapular).'),
    ('progressions', '• Añade 2.5 kg cuando completes 5 × 5 con buena técnica.\n• Progresa a dominadas a un brazo con polea de asistencia.'),
    ('safety_notes', '• Evita este ejercicio si tienes epicondilitis activa.\n• Asegura bien los discos al cinturón.')
) AS f(field, value)
WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Weighted Pull-Ups'),
    ('short_description', 'Pull-ups with added weight via belt or vest.'),
    ('description', 'Primary compound exercise for developing pulling strength for climbing. Weight is added progressively via a dip belt or weighted vest. Full range of motion (elbows extended to chin over bar) is mandatory. Essential for lock-offs and overhangs.'),
    ('execution_instructions', '1. Warm up with 2-3 unweighted sets.\n2. Add your target weight.\n3. Perform full, controlled pull-ups (2 s up, 2 s down).\n4. Sets of 3-5 reps at high load.\n5. Rest 2-3 min between sets.'),
    ('common_mistakes', '• Not completing the range of motion (half rep).\n• Using momentum or kipping.\n• Shrugging at the start (prioritise scapular depression).'),
    ('progressions', '• Add 2.5 kg when you can complete 5 × 5 with good form.\n• Progress to one-arm pull-ups with pulley assistance.'),
    ('safety_notes', '• Avoid this exercise if you have active epicondylitis.\n• Secure weight plates properly to the belt.')
) AS f(field, value)
WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',        TRUE,  '5'),
    ('SETS',        TRUE,  '5'),
    ('REST_SECONDS',TRUE,  '180'),
    ('WEIGHT_KG',   TRUE,  '0'),
    ('RPE',         FALSE, '8')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78' AND mg.code IN ('ARMS', 'SHOULDERS', 'CORE');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78' AND eq.code = 'PULLUP_BAR';

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78' AND eq.code = 'WEIGHTED_BELT';

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND m.uuid = 'd236fdc8-d225-4d48-b0f5-ec24a18ecffc';


-- E06: Offset Pull-Ups
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'ebefaac4-873e-40da-81da-a9f44ba1917b',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'ADVANCED', mg.id, TRUE, TRUE, 15, 'MODERATE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'PULL' AND mg.code = 'BACK';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Dominadas con desnivel'),
    ('short_description', 'Dominadas con una mano en la barra y la otra en una toalla o anilla más baja.'),
    ('description', 'Ejercicio asimétrico que prepara para la dominada a un brazo. Una mano agarra la barra directamente; la otra se apoya en una toalla, cuerda o anilla situada 30-50 cm más abajo. La mano baja asiste progresivamente menos. Desarrolla fuerza unilateral y corrige desequilibrios.'),
    ('execution_instructions', '1. Coloca una toalla o anilla colgando de la barra.\n2. Agarra la barra con una mano y la toalla con la otra a la altura deseada.\n3. Realiza la dominada con control (3 s subida, 3 s bajada).\n4. 3-5 repeticiones por brazo.\n5. Descansa 2-3 min entre series.'),
    ('common_mistakes', '• Usar demasiada asistencia de la mano baja.\n• Rotar el torso en lugar de mantenerlo recto.\n• No alternar el brazo dominante.'),
    ('progressions', '• Baja la toalla 5-10 cm cada 2 semanas.\n• Reduce dedos de la mano asistente hasta usar solo 2 dedos.'),
    ('safety_notes', '• Comienza con la toalla alta (poca asimetría).\n• No intentes la dominada a un brazo hasta dominar este ejercicio con la toalla muy baja.')
) AS f(field, value)
WHERE uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Offset Pull-Ups'),
    ('short_description', 'Pull-ups with one hand on the bar and the other lower on a towel or ring.'),
    ('description', 'Asymmetric exercise that prepares for the one-arm pull-up. One hand grips the bar directly; the other rests on a towel, cord or ring placed 30-50 cm lower. The lower hand assists progressively less. Develops unilateral strength and corrects imbalances.'),
    ('execution_instructions', '1. Hang a towel or ring from the bar.\n2. Grip the bar with one hand and the towel with the other at the desired height.\n3. Perform the pull-up with control (3 s up, 3 s down).\n4. 3-5 reps per arm.\n5. Rest 2-3 min between sets.'),
    ('common_mistakes', '• Using too much assistance from the lower hand.\n• Rotating the torso instead of keeping it straight.\n• Not alternating the dominant arm.'),
    ('progressions', '• Lower the towel 5-10 cm every 2 weeks.\n• Reduce fingers on the assisting hand until using only 2 fingers.'),
    ('safety_notes', '• Start with the towel high (little asymmetry).\n• Do not attempt one-arm pull-ups until this exercise is mastered with the towel very low.')
) AS f(field, value)
WHERE uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '4'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '180'),
    ('RPE',          FALSE, '8')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b' AND mg.code IN ('ARMS', 'SHOULDERS', 'CORE');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b' AND eq.code = 'PULLUP_BAR';

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = 'ebefaac4-873e-40da-81da-a9f44ba1917b' AND eq.code = 'SLINGS';


-- E07: Front Lever Progressions
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'PULL' AND mg.code = 'BACK';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Progresiones de front lever'),
    ('short_description', 'Progresiones del front lever: agrupado, semi-abierto, a una pierna y completo.'),
    ('description', 'El front lever es un ejercicio isométrico de tracción que desarrolla una fuerza de espalda y core extrema. Se progresa desde la posición agrupada (rodillas al pecho) hasta la posición completamente extendida. Cada progresión se mantiene como isométrico de 5-15 segundos.'),
    ('execution_instructions', '1. Cuélgate de una barra con los brazos extendidos.\n2. Lleva las rodillas al pecho (posición agrupada).\n3. Extiende la cadera hasta que el cuerpo esté paralelo al suelo.\n4. Mantén la posición isométrica el tiempo objetivo.\n5. Descansa 1-2 min entre series.'),
    ('common_mistakes', '• Arquear la espalda (debe estar redondeada hacia atrás).\n• Flexionar los codos.\n• Mirar al techo en lugar de al frente.'),
    ('progressions', 'Agrupado → semi-abierto (una pierna extendida) → straddle → completo. Domina 3 × 15 s antes de pasar a la siguiente.'),
    ('safety_notes', '• Ejercicio seguro si se progresa gradualmente.\n• No intentes la posición completa sin dominar las anteriores.')
) AS f(field, value)
WHERE uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Front Lever Progressions'),
    ('short_description', 'Front lever progressions: tuck, advanced tuck, one-leg, and full.'),
    ('description', 'The front lever is an isometric pulling exercise that builds extreme back and core strength. Progress from tuck position (knees to chest) to fully extended. Each progression is held as a 5-15 second isometric.'),
    ('execution_instructions', '1. Hang from a bar with arms extended.\n2. Bring knees to chest (tuck position).\n3. Extend hips until body is parallel to the floor.\n4. Hold the isometric for the target time.\n5. Rest 1-2 min between sets.'),
    ('common_mistakes', '• Arching the back (should be rounded backward).\n• Bending the elbows.\n• Looking at the ceiling instead of forward.'),
    ('progressions', 'Tuck → advanced tuck (one leg extended) → straddle → full. Master 3 × 15 s before moving on.'),
    ('safety_notes', '• Safe exercise when progressed gradually.\n• Do not attempt the full position without mastering the prior progressions.')
) AS f(field, value)
WHERE uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS', TRUE,  '10'),
    ('SETS',             TRUE,  '4'),
    ('REST_SECONDS',     TRUE,  '90'),
    ('RPE',              FALSE, '7')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5' AND mg.code IN ('CORE', 'SHOULDERS', 'ARMS');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5' AND eq.code = 'PULLUP_BAR';

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5'
  AND m.uuid = '76e38792-cac6-45f6-9fa2-5492ce9f4563';


-- 4.3 CORE exercises --------------------------------------------------------

-- E08: Hollow Body Hold
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'CORE' AND mg.code = 'CORE';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Hollow body hold'),
    ('short_description', 'Isométrico de core en posición de «cuenco» para desarrollar tensión corporal.'),
    ('description', 'Ejercicio fundamental de gimnasia para desarrollar la tensión corporal necesaria en escalada. Tumbado boca arriba, se elevan piernas y hombros manteniendo la zona lumbar pegada al suelo. Se progresa extendiendo brazos y piernas. La tensión de hollow body se transfiere directamente a la escalada en desplomes.'),
    ('execution_instructions', '1. Túmbate boca arriba con brazos y piernas extendidos.\n2. Eleva piernas y hombros 15-20 cm del suelo.\n3. Mantén la zona lumbar completamente pegada al suelo.\n4. Brazos extendidos hacia atrás, mirada al ombligo.\n5. Aguanta la posición 20-60 segundos.'),
    ('common_mistakes', '• Despegar la zona lumbar del suelo (reduce la dificultad bajando piernas).\n• Encoger el cuello.\n• Flexionar los codos o rodillas.'),
    ('progressions', '• Brazos y piernas recogidos → un brazo extendido → ambos extendidos.\n• Añade balanceos lentos de piernas para mayor dificultad.'),
    ('safety_notes', '• Si sientes dolor lumbar, flexiona las rodillas.')
) AS f(field, value)
WHERE uuid = 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Hollow Body Hold'),
    ('short_description', 'Core isometric in a hollow position to develop body tension.'),
    ('description', 'Fundamental gymnastics exercise to build the body tension needed in climbing. Lying face up, lift legs and shoulders while keeping the lower back pressed into the floor. Progress by extending arms and legs. Hollow body tension transfers directly to overhanging climbing.'),
    ('execution_instructions', '1. Lie face up with arms and legs extended.\n2. Lift legs and shoulders 15-20 cm off the floor.\n3. Keep the lower back completely pressed into the floor.\n4. Arms extended backward, gaze toward navel.\n5. Hold the position 20-60 seconds.'),
    ('common_mistakes', '• Lifting the lower back off the floor (reduce difficulty by lowering legs).\n• Tucking the neck.\n• Bending elbows or knees.'),
    ('progressions', '• Arms and legs tucked → one arm extended → both extended.\n• Add slow leg swings for greater challenge.'),
    ('safety_notes', '• If you feel lower back pain, bend your knees.')
) AS f(field, value)
WHERE uuid = 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS', TRUE,  '30'),
    ('SETS',             TRUE,  '4'),
    ('REST_SECONDS',     TRUE,  '60'),
    ('RPE',              FALSE, '6')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7' AND mg.code IN ('FULL_BODY');

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7'
  AND m.uuid = '00b226f3-3edc-47a5-b00e-8ef95926449f';


-- E09: Toes to Bar
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '4a21745d-c715-4d52-9785-5befa2eb3e7b',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'CORE' AND mg.code = 'CORE';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Puntas a la barra'),
    ('short_description', 'Elevación de piernas colgado hasta tocar la barra con las puntas de los pies.'),
    ('description', 'Ejercicio de core en suspensión que trabaja la cadena anterior completa. Colgado de una barra, se elevan las piernas extendidas hasta tocar la barra con los pies. Implica fuerza de core, compresión de cadera y estabilidad escapular. Muy específico para escalada en desplomes severos.'),
    ('execution_instructions', '1. Cuélgate de una barra con brazos extendidos.\n2. Con las piernas estiradas, elévalas hasta tocar la barra.\n3. Baja controladamente (2-3 s).\n4. Evita el balanceo.\n5. 5-10 repeticiones por serie.'),
    ('common_mistakes', '• Balancearse para subir (usa solo el core).\n• Flexionar las rodillas.\n• Bajar sin control.'),
    ('progressions', '• Rodillas al pecho → piernas extendidas a 90° → puntas a la barra.\n• Añade pausa de 2 s arriba.'),
    ('safety_notes', '• Calienta los hombros antes. La suspensión pasiva puede irritar el manguito rotador.')
) AS f(field, value)
WHERE uuid = '4a21745d-c715-4d52-9785-5befa2eb3e7b';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Toes to Bar'),
    ('short_description', 'Hanging leg raise until toes touch the bar.'),
    ('description', 'Hanging core exercise that works the entire anterior chain. Hanging from a bar, lift extended legs until feet touch the bar. Involves core strength, hip compression and scapular stability. Highly specific for severely overhanging climbing.'),
    ('execution_instructions', '1. Hang from a bar with arms extended.\n2. With legs straight, lift them until touching the bar.\n3. Lower under control (2-3 s).\n4. Avoid swinging.\n5. 5-10 reps per set.'),
    ('common_mistakes', '• Swinging to gain momentum (use core only).\n• Bending the knees.\n• Lowering without control.'),
    ('progressions', '• Knees to chest → legs extended to 90° → toes to bar.\n• Add a 2 s pause at the top.'),
    ('safety_notes', '• Warm up shoulders first. Passive hanging can irritate the rotator cuff.')
) AS f(field, value)
WHERE uuid = '4a21745d-c715-4d52-9785-5befa2eb3e7b';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '8'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '90'),
    ('RPE',          FALSE, '7')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '4a21745d-c715-4d52-9785-5befa2eb3e7b';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '4a21745d-c715-4d52-9785-5befa2eb3e7b' AND mg.code IN ('SHOULDERS', 'LEGS');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '4a21745d-c715-4d52-9785-5befa2eb3e7b' AND eq.code = 'PULLUP_BAR';


-- E10: Dragon Flag
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '3bd00087-7512-4aa9-b7bc-833547be79b4',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'ADVANCED', mg.id, TRUE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'CORE' AND mg.code = 'CORE';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Dragon flag'),
    ('short_description', 'Isométrico avanzado de core popularizado por Bruce Lee.'),
    ('description', 'Ejercicio icónico de core que requiere tensión corporal total. Tumbado en un banco, agarrándote por detrás de la cabeza, elevas el cuerpo completamente recto desde los hombros hasta los pies. Se mantiene la posición o se baja lentamente. Nivel avanzado.'),
    ('execution_instructions', '1. Túmbate en un banco plano y sujétate del borde detrás de tu cabeza.\n2. Eleva el cuerpo recto como una tabla, apoyado solo en la parte alta de la espalda.\n3. Mantén la posición 3-10 segundos o baja lentamente en excéntrico.\n4. 3-5 repeticiones.'),
    ('common_mistakes', '• Doblar las caderas (el cuerpo debe ser una línea recta).\n• Arquear la espalda.\n• Usar impulso.'),
    ('progressions', '• Comienza con piernas recogidas y extiende progresivamente.\n• Haz solo la fase excéntrica (bajada) al principio.'),
    ('safety_notes', '• Requiere buena base de core. No intentar sin dominar hollow body y front lever tuck.')
) AS f(field, value)
WHERE uuid = '3bd00087-7512-4aa9-b7bc-833547be79b4';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Dragon Flag'),
    ('short_description', 'Advanced core isometric popularised by Bruce Lee.'),
    ('description', 'Iconic core exercise requiring total body tension. Lying on a bench, gripping behind your head, raise your body completely straight from shoulders to feet. Hold the position or lower slowly. Advanced level.'),
    ('execution_instructions', '1. Lie on a flat bench and grip the edge behind your head.\n2. Raise your body straight as a plank, supported only by your upper back.\n3. Hold for 3-10 seconds or lower slowly as a negative.\n4. 3-5 reps.'),
    ('common_mistakes', '• Bending at the hips (body must be a straight line).\n• Arching the back.\n• Using momentum.'),
    ('progressions', '• Start with knees tucked and progressively extend.\n• Do only the eccentric phase (lowering) at first.'),
    ('safety_notes', '• Requires a solid core foundation. Do not attempt without mastering hollow body and front lever tuck.')
) AS f(field, value)
WHERE uuid = '3bd00087-7512-4aa9-b7bc-833547be79b4';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS', TRUE,  '5'),
    ('REPS',             TRUE,  '4'),
    ('SETS',             TRUE,  '3'),
    ('REST_SECONDS',     TRUE,  '120'),
    ('RPE',              FALSE, '9')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '3bd00087-7512-4aa9-b7bc-833547be79b4';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '3bd00087-7512-4aa9-b7bc-833547be79b4' AND mg.code IN ('FULL_BODY', 'BACK');


-- 4.4 ANTAGONIST exercises --------------------------------------------------

-- E11: Reverse Wrist Curls
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '1e85588f-3bba-4bff-8e9f-acfd1590d467',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, TRUE, FALSE, 5, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ANTAGONIST' AND mg.code = 'FOREARM';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Curl de muñeca inverso'),
    ('short_description', 'Fortalecimiento de extensores de muñeca para prevenir epicondilitis.'),
    ('description', 'Ejercicio de prevención de lesiones que fortalece los extensores de muñeca, el grupo muscular antagonista a los flexores que más se usan en escalada. Usa una mancuerna ligera o banda elástica. Altas repeticiones con poco peso. Esencial para prevenir codo de escalador (epicondilitis lateral).'),
    ('execution_instructions', '1. Apoya el antebrazo en un banco o muslo con la muñeca fuera del borde.\n2. Con una mancuerna ligera (1-3 kg), palma hacia abajo.\n3. Extiende la muñeca hacia arriba lentamente (2 s).\n4. Baja controladamente (2 s).\n5. 15-20 repeticiones × 3 series.'),
    ('common_mistakes', '• Usar demasiado peso (esto es prevención, no fuerza).\n• Hacer el movimiento rápido.\n• No apoyar bien el antebrazo.'),
    ('progressions', '• Aumenta a 20-25 repeticiones antes de subir peso.\n• Haz el ejercicio de pie para implicar más estabilidad.'),
    ('safety_notes', '• Si sientes dolor en el codo, reduce el peso o consulta a un fisio.')
) AS f(field, value)
WHERE uuid = '1e85588f-3bba-4bff-8e9f-acfd1590d467';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Reverse Wrist Curls'),
    ('short_description', 'Wrist extensor strengthening to prevent epicondylitis.'),
    ('description', 'Injury-prevention exercise that strengthens wrist extensors, the antagonist muscle group to the flexors most used in climbing. Uses a light dumbbell or resistance band. High reps, low weight. Essential for preventing climber''s elbow (lateral epicondylitis).'),
    ('execution_instructions', '1. Rest your forearm on a bench or thigh with the wrist off the edge.\n2. With a light dumbbell (1-3 kg), palm facing down.\n3. Extend the wrist upward slowly (2 s).\n4. Lower under control (2 s).\n5. 15-20 reps × 3 sets.'),
    ('common_mistakes', '• Using too much weight (this is prevention, not strength).\n• Moving too fast.\n• Not supporting the forearm properly.'),
    ('progressions', '• Increase to 20-25 reps before adding weight.\n• Perform standing to involve more stability.'),
    ('safety_notes', '• If you feel elbow pain, reduce weight or consult a physio.')
) AS f(field, value)
WHERE uuid = '1e85588f-3bba-4bff-8e9f-acfd1590d467';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '15'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '60'),
    ('WEIGHT_KG',    TRUE,  '1'),
    ('RPE',          FALSE, '3')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '1e85588f-3bba-4bff-8e9f-acfd1590d467';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '1e85588f-3bba-4bff-8e9f-acfd1590d467' AND mg.code IN ('ARMS');

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = '1e85588f-3bba-4bff-8e9f-acfd1590d467'
  AND m.uuid = '181bf1e7-3a38-4cac-a709-fb668211ed66';


-- E12: Shoulder External Rotation
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'e469bc65-5cdd-4e6d-bc3a-b163c896c577',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, TRUE, TRUE, 5, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ANTAGONIST' AND mg.code = 'SHOULDERS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Rotación externa de hombro'),
    ('short_description', 'Fortalecimiento del manguito rotador con banda elástica.'),
    ('description', 'Ejercicio de prevención fundamental para la salud del hombro en escaladores. Fortalece el manguito rotador (supraespinoso, infraespinoso, redondo menor), músculos que estabilizan la cabeza humeral. Se realiza con banda elástica de baja resistencia y altas repeticiones.'),
    ('execution_instructions', '1. Fija una banda elástica a la altura del codo.\n2. De pie, codo pegado al costado y flexionado 90°.\n3. Sujeta la banda con la mano y rota el brazo hacia fuera.\n4. Vuelve a la posición inicial con control.\n5. 12-15 repeticiones × 3 series por brazo.'),
    ('common_mistakes', '• Separar el codo del cuerpo.\n• Rotar el tronco en lugar del hombro.\n• Usar demasiada resistencia.'),
    ('progressions', '• Aumenta repeticiones a 20 antes de cambiar de banda.\n• Realiza el ejercicio en diferentes ángulos (45°, 90°).'),
    ('safety_notes', '• Sin dolor. Si aparece pinzamiento, reduce el rango.')
) AS f(field, value)
WHERE uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Shoulder External Rotation'),
    ('short_description', 'Rotator cuff strengthening with a resistance band.'),
    ('description', 'Essential injury-prevention exercise for climber shoulder health. Strengthens the rotator cuff (supraspinatus, infraspinatus, teres minor), the muscles that stabilise the humeral head. Performed with a low-resistance band and high reps.'),
    ('execution_instructions', '1. Anchor a resistance band at elbow height.\n2. Standing, elbow tucked into your side and bent 90°.\n3. Grip the band and rotate the arm outward.\n4. Return to the starting position under control.\n5. 12-15 reps × 3 sets per arm.'),
    ('common_mistakes', '• Letting the elbow drift away from the body.\n• Rotating the torso instead of the shoulder.\n• Using too much resistance.'),
    ('progressions', '• Increase reps to 20 before switching band.\n• Perform at different angles (45°, 90°).'),
    ('safety_notes', '• Pain-free only. If impingement appears, reduce range.')
) AS f(field, value)
WHERE uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '12'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '60'),
    ('RPE',          FALSE, '3')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577' AND mg.code IN ('BACK');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577' AND eq.code = 'RESISTANCE_BAND';

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = 'e469bc65-5cdd-4e6d-bc3a-b163c896c577'
  AND m.uuid = '6a20a813-9a4e-4a8e-a708-e2bb394830be';


-- E13: Ring Push-Ups
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'a6a9daec-30c0-4bb6-b166-86c65fa2066f',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, TRUE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ANTAGONIST' AND mg.code = 'CHEST';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Flexiones en anillas'),
    ('short_description', 'Flexiones en anillas de gimnasia para trabajar pecho y estabilidad.'),
    ('description', 'Las anillas añaden inestabilidad, forzando a los estabilizadores del hombro y core a trabajar mucho más que en flexiones normales. Excelente para equilibrar la musculatura de empuje frente a la dominancia de tracción en escalada.'),
    ('execution_instructions', '1. Ajusta las anillas a la altura de la cadera.\n2. Colócate en posición de flexión con las manos en las anillas.\n3. Baja controlando la inestabilidad (2 s).\n4. Extiende los brazos sin bloquear los codos.\n5. 8-15 repeticiones × 3 series.'),
    ('common_mistakes', '• Perder la tensión de core y arquear la espalda.\n• Bajar demasiado profundo forzando los hombros.\n• Bloquear los codos arriba.'),
    ('progressions', '• Flexiones normales → en anillas → con pies elevados.\n• Añade pausa de 2 s abajo.'),
    ('safety_notes', '• Asegura bien las anillas antes de usarlas. Mantén el suelo despejado.')
) AS f(field, value)
WHERE uuid = 'a6a9daec-30c0-4bb6-b166-86c65fa2066f';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Ring Push-Ups'),
    ('short_description', 'Push-ups on gymnastics rings to work chest and stability.'),
    ('description', 'Rings add instability, forcing shoulder stabilisers and core to work much harder than in regular push-ups. Excellent for balancing pushing muscles against the pulling dominance in climbing.'),
    ('execution_instructions', '1. Set the rings at hip height.\n2. Assume push-up position with hands on the rings.\n3. Lower while controlling instability (2 s).\n4. Extend arms without locking elbows.\n5. 8-15 reps × 3 sets.'),
    ('common_mistakes', '• Losing core tension and arching the back.\n• Going too deep and straining shoulders.\n• Locking elbows at the top.'),
    ('progressions', '• Regular push-ups → ring push-ups → feet elevated.\n• Add a 2 s pause at the bottom.'),
    ('safety_notes', '• Secure the rings properly before use. Keep the floor clear.')
) AS f(field, value)
WHERE uuid = 'a6a9daec-30c0-4bb6-b166-86c65fa2066f';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '10'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '90'),
    ('RPE',          FALSE, '7')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'a6a9daec-30c0-4bb6-b166-86c65fa2066f';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'a6a9daec-30c0-4bb6-b166-86c65fa2066f' AND mg.code IN ('SHOULDERS', 'ARMS', 'CORE');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = 'a6a9daec-30c0-4bb6-b166-86c65fa2066f' AND eq.code = 'SLINGS';


-- E14: I-Y-T Raises
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '75ab896b-532c-4884-a365-356b11691d7b',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ANTAGONIST' AND mg.code = 'BACK';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Elevaciones I-Y-T'),
    ('short_description', 'Elevaciones de brazos en posición de I, Y y T para fortalecer trapecio y romboides.'),
    ('description', 'Ejercicio de prehabilitación de hombro y espalda alta. Boca abajo, se elevan los brazos formando las letras I (por encima de la cabeza), Y (a 45°) y T (en cruz). Trabaja el trapecio inferior y medio, romboides y deltoides posterior. Corrige la postura de hombros adelantados típica de escaladores.'),
    ('execution_instructions', '1. Boca abajo en el suelo o banco inclinado.\n2. Posición I: brazos extendidos por encima de la cabeza, pulgares arriba.\n3. Eleva los brazos 10-15 cm, mantén 2 s, baja.\n4. Posición Y: brazos a 45°, misma ejecución.\n5. Posición T: brazos en cruz, misma ejecución.\n6. 10 repeticiones de cada letra × 3 rondas.'),
    ('common_mistakes', '• Usar impulso.\n• Encoger los hombros hacia las orejas.\n• Elevar demasiado (pierde activación de trapecio).'),
    ('progressions', '• Añade mancuernas de 0.5-1 kg.\n• Realiza en banco inclinado para mayor rango.'),
    ('safety_notes', '• Sin dolor. Movimiento controlado en todo momento.')
) AS f(field, value)
WHERE uuid = '75ab896b-532c-4884-a365-356b11691d7b';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'I-Y-T Raises'),
    ('short_description', 'Arm raises in I, Y and T positions to strengthen traps and rhomboids.'),
    ('description', 'Shoulder and upper back prehabilitation exercise. Face down, raise arms forming the letters I (overhead), Y (45°) and T (crucifix). Works the lower and middle traps, rhomboids and rear deltoids. Corrects the forward-shoulder posture common in climbers.'),
    ('execution_instructions', '1. Face down on the floor or an incline bench.\n2. I position: arms extended overhead, thumbs up.\n3. Raise arms 10-15 cm, hold 2 s, lower.\n4. Y position: arms at 45°, same execution.\n5. T position: arms out to sides, same execution.\n6. 10 reps of each letter × 3 rounds.'),
    ('common_mistakes', '• Using momentum.\n• Shrugging shoulders toward ears.\n• Raising too high (loses trap activation).'),
    ('progressions', '• Add 0.5-1 kg dumbbells.\n• Perform on an incline bench for greater range.'),
    ('safety_notes', '• Pain-free. Controlled movement throughout.')
) AS f(field, value)
WHERE uuid = '75ab896b-532c-4884-a365-356b11691d7b';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '10'),
    ('SETS',         TRUE,  '3'),
    ('REST_SECONDS', TRUE,  '60'),
    ('RPE',          FALSE, '4')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '75ab896b-532c-4884-a365-356b11691d7b';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '75ab896b-532c-4884-a365-356b11691d7b' AND mg.code IN ('SHOULDERS');


-- 4.5 FLEXIBILITY exercises --------------------------------------------------

-- E15: Cossack Squat (Hip Mobility)
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '0f766ff6-47fa-450a-a541-56be6ea5abf9',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, TRUE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'FLEXIBILITY' AND mg.code = 'LEGS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Sentadilla cosaca'),
    ('short_description', 'Movilidad de cadera y estiramiento de aductores en posición lateral.'),
    ('description', 'Ejercicio de movilidad de cadera que abre el rango de abducción, esencial para pasos altos en escalada. Se desciende lateralmente sobre una pierna mientras la otra se mantiene extendida. Trabaja fuerza excéntrica y flexibilidad simultáneamente.'),
    ('execution_instructions', '1. De pie con las piernas muy abiertas.\n2. Desplaza el peso hacia un lado, flexionando esa rodilla.\n3. La otra pierna se mantiene extendida con el talón en el suelo.\n4. Baja hasta donde permita tu movilidad, mantén 3 s.\n5. Cambia de lado. 8-10 por pierna.'),
    ('common_mistakes', '• Levantar el talón de la pierna extendida.\n• Inclinar el torso excesivamente.\n• Forzar más allá del rango de confort.'),
    ('progressions', '• Apoya las manos en el suelo al principio.\n• Progresa a manos libres y luego con pesa rusa ligera.'),
    ('safety_notes', '• Movimiento controlado, sin rebotes. No fuerces.')
) AS f(field, value)
WHERE uuid = '0f766ff6-47fa-450a-a541-56be6ea5abf9';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Cossack Squat'),
    ('short_description', 'Hip mobility and adductor stretch in a lateral position.'),
    ('description', 'Hip mobility exercise that opens abduction range, essential for high steps in climbing. Descend laterally onto one leg while keeping the other extended. Works eccentric strength and flexibility simultaneously.'),
    ('execution_instructions', '1. Stand with legs very wide.\n2. Shift weight to one side, bending that knee.\n3. The other leg stays extended with the heel on the floor.\n4. Lower as far as your mobility allows, hold 3 s.\n5. Switch sides. 8-10 per leg.'),
    ('common_mistakes', '• Lifting the extended leg''s heel.\n• Leaning the torso excessively.\n• Forcing beyond your comfort range.'),
    ('progressions', '• Hands on the floor initially.\n• Progress to hands-free, then with a light kettlebell.'),
    ('safety_notes', '• Controlled movement, no bouncing. Do not force.')
) AS f(field, value)
WHERE uuid = '0f766ff6-47fa-450a-a541-56be6ea5abf9';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '8'),
    ('SETS',         TRUE,  '2'),
    ('REST_SECONDS', TRUE,  '30'),
    ('RPE',          FALSE, '3')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '0f766ff6-47fa-450a-a541-56be6ea5abf9';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '0f766ff6-47fa-450a-a541-56be6ea5abf9' AND mg.code IN ('CORE');


-- E16: Thoracic Spine Mobility
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'ccf774d5-52f1-41ae-8e80-c507927e6e2c',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, FALSE, 10, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'FLEXIBILITY' AND mg.code = 'BACK';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Movilidad de columna torácica'),
    ('short_description', 'Ejercicios de rotación y extensión torácica para mejorar el alcance.'),
    ('description', 'La columna torácica (parte media de la espalda) tiende a rigidizarse en escaladores, limitando el alcance y la capacidad de mirar hacia arriba en vías. Estos ejercicios restauran la rotación y extensión torácica, mejorando la eficiencia en movimientos de techo y desplomes.'),
    ('execution_instructions', '1. En cuadrupedia, coloca una mano detrás de la cabeza.\n2. Rota el codo hacia el techo siguiendo con la mirada.\n3. Vuelve a la posición inicial.\n4. 8-10 repeticiones por lado.\n5. Complementa con extensiones torácicas sobre foam roller.'),
    ('common_mistakes', '• Rotar desde la zona lumbar en lugar de la torácica.\n• Hacer el movimiento rápido.\n• No coordinar con la respiración (exhala al rotar).'),
    ('progressions', '• Añade pausa de 3 s en máxima rotación.\n• Realiza en posición de sentadilla profunda para mayor desafío.'),
    ('safety_notes', '• Diferencia el dolor articular de la molestia por rigidez. Para si hay dolor.')
) AS f(field, value)
WHERE uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Thoracic Spine Mobility'),
    ('short_description', 'Thoracic rotation and extension drills to improve reach.'),
    ('description', 'The thoracic spine (mid-back) tends to stiffen in climbers, limiting reach and the ability to look up on routes. These exercises restore thoracic rotation and extension, improving efficiency on roof and overhanging movements.'),
    ('execution_instructions', '1. On all fours, place one hand behind your head.\n2. Rotate your elbow toward the ceiling, following with your gaze.\n3. Return to the starting position.\n4. 8-10 reps per side.\n5. Complement with thoracic extensions over a foam roller.'),
    ('common_mistakes', '• Rotating from the lumbar spine instead of thoracic.\n• Moving too fast.\n• Not coordinating with breath (exhale on rotation).'),
    ('progressions', '• Add a 3 s pause at maximum rotation.\n• Perform in a deep squat position for added challenge.'),
    ('safety_notes', '• Distinguish joint pain from stiffness discomfort. Stop if there is pain.')
) AS f(field, value)
WHERE uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '10'),
    ('SETS',         TRUE,  '2'),
    ('REST_SECONDS', TRUE,  '30'),
    ('RPE',          FALSE, '2')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c' AND mg.code IN ('SHOULDERS', 'CORE');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, TRUE FROM exercises e, equipment eq
WHERE e.uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c' AND eq.code = 'FOAM_ROLLER';

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = 'ccf774d5-52f1-41ae-8e80-c507927e6e2c'
  AND m.uuid = 'be06779b-651b-434a-a7d1-de1bd27509d4';


-- E17: Shoulder Dislocates
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '88dcf1f7-750d-4f0d-bdd9-6395aa723afb',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, TRUE, FALSE, 5, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'FLEXIBILITY' AND mg.code = 'SHOULDERS';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Dislocates de hombro'),
    ('short_description', 'Rotación completa de hombros con palo o banda para mejorar rango articular.'),
    ('description', 'Ejercicio clásico de movilidad de hombro que consiste en pasar un palo o banda desde delante del cuerpo hasta detrás manteniendo los brazos extendidos. Mejora la flexibilidad y rango de movimiento de la articulación glenohumeral.'),
    ('execution_instructions', '1. Sujeta un palo o banda con las manos bien separadas.\n2. Con los brazos extendidos, eleva el palo por encima de la cabeza.\n3. Continúa el arco hasta que el palo quede detrás de la espalda.\n4. Vuelve por el mismo camino.\n5. 10 repeticiones lentas. Acerca las manos progresivamente.'),
    ('common_mistakes', '• Flexionar los codos.\n• Usar un agarre demasiado estrecho al principio.\n• Hacer el movimiento rápido o con rebote.'),
    ('progressions', '• Reduce 2 cm el agarre cada semana.\n• Usa una banda elástica para asistencia si es necesario.'),
    ('safety_notes', '• Si tienes historial de luxación de hombro, consulta con un profesional antes.')
) AS f(field, value)
WHERE uuid = '88dcf1f7-750d-4f0d-bdd9-6395aa723afb';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Shoulder Dislocates'),
    ('short_description', 'Full shoulder rotation with a stick or band to improve joint range.'),
    ('description', 'Classic shoulder mobility exercise that involves passing a stick or band from in front of the body to behind while keeping arms extended. Improves flexibility and range of motion in the glenohumeral joint.'),
    ('execution_instructions', '1. Grip a stick or band with hands very wide apart.\n2. With arms extended, raise the stick overhead.\n3. Continue the arc until the stick is behind your back.\n4. Return along the same path.\n5. 10 slow reps. Gradually narrow your grip.'),
    ('common_mistakes', '• Bending the elbows.\n• Using too narrow a grip at the start.\n• Moving fast or with a bounce.'),
    ('progressions', '• Narrow your grip 2 cm each week.\n• Use a resistance band for assistance if needed.'),
    ('safety_notes', '• If you have a history of shoulder dislocation, consult a professional first.')
) AS f(field, value)
WHERE uuid = '88dcf1f7-750d-4f0d-bdd9-6395aa723afb';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '10'),
    ('SETS',         TRUE,  '2'),
    ('REST_SECONDS', TRUE,  '30'),
    ('RPE',          FALSE, '2')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '88dcf1f7-750d-4f0d-bdd9-6395aa723afb';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '88dcf1f7-750d-4f0d-bdd9-6395aa723afb' AND mg.code IN ('BACK', 'CHEST');

INSERT INTO exercise_equipment (exercise_id, equipment_id, is_optional)
SELECT e.id, eq.id, FALSE FROM exercises e, equipment eq
WHERE e.uuid = '88dcf1f7-750d-4f0d-bdd9-6395aa723afb' AND eq.code = 'RESISTANCE_BAND';


-- 4.6 ENDURANCE exercises ----------------------------------------------------

-- E18: ARC Training
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT '9cd693ff-6410-4690-b17b-d692157ffee6',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, FALSE, 30, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ENDURANCE' AND mg.code = 'FOREARM';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'ARC Training'),
    ('short_description', 'Escalada continua de baja intensidad (30 min) para desarrollar capilaridad y base aeróbica.'),
    ('description', 'ARC (Aerobic Restoration and Capillarity) es el método fundamental de entrenamiento aeróbico en escalada. Consiste en escalar de forma continua durante 20-45 minutos a una intensidad baja (sin bombeo), en travesías o presas grandes. Desarrolla capilaridad en el antebrazo, mejora la recuperación entre intentos y crea la base para trabajo de resistencia más intenso.'),
    ('execution_instructions', '1. Busca un plafón de travesías o un sector con presas grandes.\n2. Escala durante 20-45 minutos sin parar.\n3. La intensidad debe ser baja: puedes mantener una conversación.\n4. No llegues al bombeo. Si bombeas, busca presas mejores.\n5. Haz 1-2 sesiones por semana.'),
    ('common_mistakes', '• Escalar demasiado intenso (esto no es un 4×4).\n• Parar con frecuencia.\n• No beber agua durante sesiones largas.'),
    ('progressions', '• Aumenta la duración de 20 → 30 → 45 minutos.\n• Reduce el tamaño de las presas gradualmente.\n• Añade lastre ligero (2-5 kg) en fases avanzadas.'),
    ('safety_notes', '• Hidrátate bien. Sesiones de 45 min deshidratan.\n• No hagas ARC después de un entrenamiento de fuerza.')
) AS f(field, value)
WHERE uuid = '9cd693ff-6410-4690-b17b-d692157ffee6';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'ARC Training'),
    ('short_description', 'Continuous low-intensity climbing (30 min) to develop capillarity and aerobic base.'),
    ('description', 'ARC (Aerobic Restoration and Capillarity) is the fundamental aerobic training method in climbing. It consists of climbing continuously for 20-45 minutes at low intensity (no pump), on traverses or large holds. Develops forearm capillarity, improves recovery between attempts, and builds the base for more intense endurance work.'),
    ('execution_instructions', '1. Find a traverse wall or a section with large holds.\n2. Climb for 20-45 minutes without stopping.\n3. Intensity should be low: you can hold a conversation.\n4. Do not reach pump. If you pump, find better holds.\n5. Perform 1-2 sessions per week.'),
    ('common_mistakes', '• Climbing too hard (this is not 4×4s).\n• Stopping frequently.\n• Not drinking water during long sessions.'),
    ('progressions', '• Increase duration from 20 → 30 → 45 minutes.\n• Gradually reduce hold size.\n• Add light weight (2-5 kg) in advanced phases.'),
    ('safety_notes', '• Stay well hydrated. 45 min sessions cause dehydration.\n• Do not do ARC after a strength session.')
) AS f(field, value)
WHERE uuid = '9cd693ff-6410-4690-b17b-d692157ffee6';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS', TRUE,  '1800'),
    ('SETS',             TRUE,  '1'),
    ('RPE',              FALSE, '4')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = '9cd693ff-6410-4690-b17b-d692157ffee6';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = '9cd693ff-6410-4690-b17b-d692157ffee6' AND mg.code IN ('FINGERS', 'FULL_BODY');

INSERT INTO exercise_media (exercise_id, media_id, role, position)
SELECT e.id, m.id, 'DEMONSTRATION', 1
FROM exercises e, media_assets m
WHERE e.uuid = '9cd693ff-6410-4690-b17b-d692157ffee6'
  AND m.uuid = 'd3489d7f-7c2c-4c0c-b6d4-b1907470ddb1';


-- E19: 4x4s Boulder Intervals
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'dfd9283a-41f2-4dc6-80ab-8c2eb064e403',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'INTERMEDIATE', mg.id, FALSE, FALSE, 30, 'HIGH'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'ENDURANCE' AND mg.code = 'FOREARM';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', '4×4 — Intervalos de bloque'),
    ('short_description', 'Intervalos de resistencia de fuerza: 4 bloques, 4 problemas, sin descanso entre ellos.'),
    ('description', 'Protocolo clásico de resistencia de fuerza. Se eligen 4 bloques ligeramente por debajo del nivel máximo del escalador y se escalan seguidos sin descanso, formando 1 ronda. Se descansa entre rondas y se repite 4 veces. Desarrolla la capacidad de escalar al límite con fatiga acumulada. Muy específico para competición.'),
    ('execution_instructions', '1. Elige 4 bloques que puedas encadenar a la primera (no proyecto).\n2. Escala los 4 seguidos sin descanso = 1 ronda.\n3. Descansa 3-4 minutos entre rondas.\n4. Completa 4 rondas.\n5. Si fallas, cuenta el intento y sigue al siguiente bloque.'),
    ('common_mistakes', '• Elegir bloques demasiado difíciles.\n• No descansar lo suficiente entre rondas.\n• Hacer más de 4 rondas (el protocolo es 4×4×4).'),
    ('progressions', '• Aumenta la dificultad de los bloques semana a semana.\n• Reduce el descanso entre rondas a 2 min.\n• Pasa a 5×5 para mayor volumen.'),
    ('safety_notes', '• ALTO riesgo de lesión en poleas por fatiga acumulada.\n• Máximo 2 sesiones por semana.\n• Para inmediatamente si la técnica se degrada.')
) AS f(field, value)
WHERE uuid = 'dfd9283a-41f2-4dc6-80ab-8c2eb064e403';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', '4×4s — Boulder Intervals'),
    ('short_description', 'Power-endurance intervals: 4 blocks, 4 problems, no rest between them.'),
    ('description', 'Classic power-endurance protocol. Choose 4 boulders slightly below the climber''s maximum level and climb them back-to-back without rest, forming 1 round. Rest between rounds, repeat 4 times. Develops the ability to climb at your limit with accumulated fatigue. Highly competition-specific.'),
    ('execution_instructions', '1. Choose 4 boulders you can flash (not projects).\n2. Climb all 4 back-to-back = 1 round.\n3. Rest 3-4 minutes between rounds.\n4. Complete 4 rounds.\n5. If you fail, count the attempt and move to the next problem.'),
    ('common_mistakes', '• Choosing boulders that are too hard.\n• Not resting enough between rounds.\n• Doing more than 4 rounds (the protocol is 4×4×4).'),
    ('progressions', '• Increase boulder difficulty week to week.\n• Reduce rest between rounds to 2 min.\n• Progress to 5×5 for greater volume.'),
    ('safety_notes', '• HIGH pulley injury risk from accumulated fatigue.\n• Maximum 2 sessions per week.\n• Stop immediately if technique degrades.')
) AS f(field, value)
WHERE uuid = 'dfd9283a-41f2-4dc6-80ab-8c2eb064e403';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('REPS',         TRUE,  '4'),
    ('SETS',         TRUE,  '4'),
    ('REST_SECONDS', TRUE,  '240'),
    ('INTENSITY_PERCENT', FALSE, '85'),
    ('RPE',          FALSE, '8')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'dfd9283a-41f2-4dc6-80ab-8c2eb064e403';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'dfd9283a-41f2-4dc6-80ab-8c2eb064e403' AND mg.code IN ('FINGERS', 'FULL_BODY');


-- 4.7 TECHNIQUE exercises ----------------------------------------------------

-- E20: Silent Feet Drills
INSERT INTO exercises (uuid, source, owner_id, category_id, visibility,
                       difficulty_level, primary_muscle_group_id,
                       requires_equipment, is_unilateral, estimated_duration_minutes,
                       safety_warning_level)
SELECT 'b31330ea-8ddd-482c-807e-461e980a460a',
       'PLATFORM', NULL, cat.id, 'PUBLIC',
       'BEGINNER', mg.id, FALSE, FALSE, 15, 'NONE'
FROM exercise_categories cat, muscle_groups mg
WHERE cat.code = 'TECHNIQUE' AND mg.code = 'FULL_BODY';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'es', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Pies silenciosos'),
    ('short_description', 'Ejercicio técnico de colocación precisa de pies sin hacer ruido.'),
    ('description', 'Ejercicio de conciencia corporal y precisión en la colocación de pies. Consiste en escalar vías o bloques fáciles concentrándose exclusivamente en que cada colocación de pie sea completamente silenciosa. Elimina el «golpeo» de pies y desarrolla la sensibilidad necesaria para apoyos pequeños.'),
    ('execution_instructions', '1. Escala un bloque o vía fácil (V2/5b o inferior).\n2. Concéntrate en colocar cada pie sin hacer ningún ruido.\n3. Si haces ruido, vuelve a empezar la secuencia.\n4. Mira el pie hasta que esté completamente colocado.\n5. 15-20 minutos de práctica.'),
    ('common_mistakes', '• Quitar la vista del pie antes de que esté colocado.\n• Escalar demasiado rápido.\n• Elegir una vía muy difícil (resta atención a la técnica).'),
    ('progressions', '• Pies silenciosos + sin manos (flag, talón, etc. con intención).\n• Hazlo en vías de tu grado máximo con calma.'),
    ('safety_notes', '• Sin riesgo. Ejercicio de conciencia, no de fuerza.')
) AS f(field, value)
WHERE uuid = 'b31330ea-8ddd-482c-807e-461e980a460a';

INSERT INTO exercise_translations (exercise_id, locale, field, value)
SELECT id, 'en', f.field, f.value FROM exercises
CROSS JOIN (VALUES
    ('name', 'Silent Feet Drills'),
    ('short_description', 'Technical drill for precise, silent foot placement.'),
    ('description', 'Body awareness and foot placement precision exercise. Climb easy routes or boulders focusing exclusively on making every foot placement completely silent. Eliminates foot «thumping» and develops the sensitivity needed for small footholds.'),
    ('execution_instructions', '1. Climb an easy boulder or route (V2/5b or below).\n2. Focus on placing each foot without making any noise.\n3. If you make noise, restart the sequence.\n4. Watch your foot until it is fully placed.\n5. 15-20 minutes of practice.'),
    ('common_mistakes', '• Looking away from the foot before it is placed.\n• Climbing too fast.\n• Choosing a route that is too hard (detracts from technique focus).'),
    ('progressions', '• Silent feet + no hands (flag, heel hook, etc. with intention).\n• Perform on routes at your limit with calm focus.'),
    ('safety_notes', '• No risk. An awareness drill, not a strength exercise.')
) AS f(field, value)
WHERE uuid = 'b31330ea-8ddd-482c-807e-461e980a460a';

INSERT INTO exercise_allowed_parameters (exercise_id, parameter_type_id, is_required, default_value)
SELECT e.id, p.id, t.req, t.def
FROM exercises e, parameter_types p
JOIN (VALUES
    ('DURATION_SECONDS', TRUE,  '900'),
    ('SETS',             TRUE,  '1'),
    ('RPE',              FALSE, '3')
) AS t(code, req, def) ON p.code = t.code
WHERE e.uuid = 'b31330ea-8ddd-482c-807e-461e980a460a';

INSERT INTO exercise_secondary_muscles (exercise_id, muscle_group_id)
SELECT e.id, mg.id FROM exercises e, muscle_groups mg
WHERE e.uuid = 'b31330ea-8ddd-482c-807e-461e980a460a' AND mg.code IN ('LEGS', 'CORE');


-- =============================================================================
-- 5. PLATFORM WORKOUT TEMPLATES
-- =============================================================================

-- 5.1 Max Hang Session (Intermediate, SPORT) ---------------------------------

INSERT INTO workout_templates (uuid, source, owner_id, visibility,
                               difficulty_level, estimated_duration_minutes,
                               target_discipline)
VALUES ('25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9',
        'PLATFORM', NULL, 'PUBLIC',
        'INTERMEDIATE', 45, 'SPORT');

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'name', 'Sesión de fuerza máxima — Hangboard'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'description',
       'Sesión principal de hangboard enfocada en colgadas máximas de 7 segundos en semi-arqueo y mano abierta. Incluye calentamiento progresivo y ejercicios de core como complemento.'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'coach_notes',
       'La clave es la calidad sobre la cantidad. Si fallas una serie, reduce el lastre. No sacrifiques la forma del semi-arqueo.'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'name', 'Max Strength Session — Hangboard'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'description',
       'Main hangboard session focused on 7-second max hangs in half crimp and open hand. Includes progressive warm-up and core exercises as a complement.'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'coach_notes',
       'Quality over quantity. If you fail a set, reduce weight. Never sacrifice half-crimp form.'
FROM workout_templates WHERE uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

-- Exercises in template
INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 1, 'duration_seconds', 30, 'rest_seconds', 60,
           'edge_depth_mm', 30, 'grip_type', 'HALF_CRIMP', 'weight_kg', 0
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (1, '82b2d80b-a34b-488b-b831-e141727628a9')) AS t(pos, ex_uuid)
WHERE wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 5, 'duration_seconds', 7, 'rest_seconds', 180,
           'edge_depth_mm', 20, 'grip_type', 'HALF_CRIMP', 'weight_kg', 0, 'rpe', 8
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (2, '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9')) AS t(pos, ex_uuid)
WHERE wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 4, 'duration_seconds', 7, 'rest_seconds', 180,
           'edge_depth_mm', 20, 'grip_type', 'OPEN_HAND', 'weight_kg', 0, 'rpe', 8
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (3, 'bd985851-6a9e-4838-99d2-732a04010a49')) AS t(pos, ex_uuid)
WHERE wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 4, 'duration_seconds', 30, 'rest_seconds', 60, 'rpe', 6
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (4, 'd4c3e3f3-6342-4183-81fc-3cc9b05bb9f7')) AS t(pos, ex_uuid)
WHERE wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 3, 'reps', 10, 'rest_seconds', 60, 'rpe', 3
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (5, '1e85588f-3bba-4bff-8e9f-acfd1590d467')) AS t(pos, ex_uuid)
WHERE wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
  AND e.uuid = t.ex_uuid::uuid;

-- 5.2 Repeater Endurance Session (Intermediate, SPORT) -----------------------

INSERT INTO workout_templates (uuid, source, owner_id, visibility,
                               difficulty_level, estimated_duration_minutes,
                               target_discipline)
VALUES ('bd985851-6a9e-4838-99d2-732a04010a49',
        'PLATFORM', NULL, 'PUBLIC',
        'INTERMEDIATE', 50, 'SPORT');

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'name', 'Sesión de resistencia — Repetidores'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'description',
       'Sesión de hangboard enfocada en resistencia de fuerza mediante protocolo de repetidores (7 s on / 3 s off). Combina semi-arqueo y mano abierta con ejercicios de tracción.'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'coach_notes',
       'Usa un temporizador de intervalos. El 70 % de tu RM es la carga óptima para empezar. Si completas 8 bloques, sube un 2.5 %.'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'name', 'Power Endurance Session — Repeaters'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'description',
       'Hangboard session focused on power endurance via the repeaters protocol (7 s on / 3 s off). Combines half crimp and open hand with pulling exercises.'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'coach_notes',
       'Use an interval timer. 70 % of your 1RM is the optimal starting load. If you complete 8 blocks, increase by 2.5 %.'
FROM workout_templates WHERE uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 6, 'duration_seconds', 7, 'rest_seconds', 120,
           'edge_depth_mm', 20, 'grip_type', 'HALF_CRIMP', 'weight_kg', 0, 'rpe', 7
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (1, '0d5487ca-afc2-44ff-a5b0-b0e2713f2874')) AS t(pos, ex_uuid)
WHERE wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 5, 'reps', 5, 'rest_seconds', 180, 'weight_kg', 10, 'rpe', 7
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (2, '0e2fb513-2655-471d-9811-c8f0d55b4a78')) AS t(pos, ex_uuid)
WHERE wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 3, 'reps', 8, 'rest_seconds', 90, 'rpe', 7
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (3, '4a21745d-c715-4d52-9785-5befa2eb3e7b')) AS t(pos, ex_uuid)
WHERE wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object(
           'sets', 3, 'reps', 15, 'rest_seconds', 60, 'weight_kg', 1, 'rpe', 3
       )
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (4, '1e85588f-3bba-4bff-8e9f-acfd1590d467')) AS t(pos, ex_uuid)
WHERE wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
  AND e.uuid = t.ex_uuid::uuid;

-- 5.3 Full Body Strength (Intermediate) -------------------------------------

INSERT INTO workout_templates (uuid, source, owner_id, visibility,
                               difficulty_level, estimated_duration_minutes,
                               target_discipline)
VALUES ('0d5487ca-afc2-44ff-a5b0-b0e2713f2874',
        'PLATFORM', NULL, 'PUBLIC',
        'INTERMEDIATE', 60, 'BOULDER');

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'name', 'Sesión de fuerza general — Boulder'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'description',
       'Sesión de fuerza integral para escalada en bloque. Combina dominadas lastradas, core avanzado, front lever y ejercicios de prevención.'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'coach_notes',
       'Sesión exigente. Deja al menos 48 h de descanso antes de escalar al límite. Prioriza la calidad de ejecución sobre la carga.'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'name', 'General Strength Session — Boulder'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'description',
       'Comprehensive strength session for bouldering. Combines weighted pull-ups, advanced core, front lever and injury-prevention exercises.'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'coach_notes',
       'Demanding session. Allow at least 48 h rest before climbing at your limit. Prioritise execution quality over load.'
FROM workout_templates WHERE uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874';

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 5, 'reps', 5, 'rest_seconds', 180, 'weight_kg', 10, 'rpe', 8)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (1, '0e2fb513-2655-471d-9811-c8f0d55b4a78')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 4, 'duration_seconds', 10, 'rest_seconds', 90, 'rpe', 7)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (2, 'bc2d96ab-a0b8-40c5-b86e-16d2875cf5d5')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 4, 'duration_seconds', 5, 'reps', 4, 'rest_seconds', 120, 'rpe', 9)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (3, '3bd00087-7512-4aa9-b7bc-833547be79b4')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 10, 'rest_seconds', 90, 'rpe', 7)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (4, 'a6a9daec-30c0-4bb6-b166-86c65fa2066f')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 12, 'rest_seconds', 60, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (5, 'e469bc65-5cdd-4e6d-bc3a-b163c896c577')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 10, 'rest_seconds', 60, 'rpe', 4)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (6, '75ab896b-532c-4884-a365-356b11691d7b')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
  AND e.uuid = t.ex_uuid::uuid;

-- 5.4 Antagonist & Prehab Session (Beginner) ----------------------------------

INSERT INTO workout_templates (uuid, source, owner_id, visibility,
                               difficulty_level, estimated_duration_minutes,
                               target_discipline)
VALUES ('82b2d80b-a34b-488b-b831-e141727628a9',
        'PLATFORM', NULL, 'PUBLIC',
        'BEGINNER', 30, NULL);

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'name', 'Sesión de prehabilitación y antagonistas'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'description',
       'Sesión ligera de fortalecimiento de músculos antagonistas y prehabilitación de hombro, codo y muñeca. Ideal como sesión de recuperación activa o para días de descanso.'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'coach_notes',
       'Nunca uses pesos altos aquí. La prioridad es la salud articular, no la fuerza. 2-3 sesiones por semana es lo óptimo para prevención.'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'name', 'Prehab & Antagonist Session'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'description',
       'Light strengthening session for antagonist muscles and prehabilitation of shoulders, elbows and wrists. Ideal as active recovery or for rest days.'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'coach_notes',
       'Never use heavy weights here. Joint health is the priority, not strength. 2-3 sessions per week is optimal for prevention.'
FROM workout_templates WHERE uuid = '82b2d80b-a34b-488b-b831-e141727628a9';

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 15, 'rest_seconds', 60, 'weight_kg', 1, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (1, '1e85588f-3bba-4bff-8e9f-acfd1590d467')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 12, 'rest_seconds', 60, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (2, 'e469bc65-5cdd-4e6d-bc3a-b163c896c577')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 10, 'rest_seconds', 60, 'rpe', 4)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (3, '75ab896b-532c-4884-a365-356b11691d7b')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 2, 'reps', 10, 'rest_seconds', 30, 'rpe', 2)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (4, 'ccf774d5-52f1-41ae-8e80-c507927e6e2c')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 2, 'reps', 10, 'rest_seconds', 30, 'rpe', 2)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (5, '88dcf1f7-750d-4f0d-bdd9-6395aa723afb')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 10, 'rest_seconds', 90, 'rpe', 7)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (6, 'a6a9daec-30c0-4bb6-b166-86c65fa2066f')) AS t(pos, ex_uuid)
WHERE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9'
  AND e.uuid = t.ex_uuid::uuid;

-- 5.5 Climbing-Specific Warm-Up (All levels) ---------------------------------

INSERT INTO workout_templates (uuid, source, owner_id, visibility,
                               difficulty_level, estimated_duration_minutes,
                               target_discipline)
VALUES ('0e2fb513-2655-471d-9811-c8f0d55b4a78',
        'PLATFORM', NULL, 'PUBLIC',
        'BEGINNER', 20, NULL);

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'name', 'Calentamiento específico de escalada'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'description',
       'Rutina de calentamiento completa para antes de cualquier sesión de escalada o entrenamiento. Incluye movilidad, activación y ejercicios de preparación del tejido conectivo.'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'es', 'coach_notes',
       'No te saltes el calentamiento. Las poleas y tendones necesitan al menos 15 minutos de carga progresiva antes del trabajo intenso.'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'name', 'Climbing-Specific Warm-Up'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'description',
       'Complete warm-up routine for before any climbing or training session. Includes mobility, activation and connective-tissue preparation exercises.'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_translations (template_id, locale, field, value)
SELECT id, 'en', 'coach_notes',
       'Do not skip the warm-up. Pulleys and tendons need at least 15 minutes of progressive loading before intense work.'
FROM workout_templates WHERE uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78';

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 2, 'reps', 10, 'rest_seconds', 30, 'rpe', 2)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (1, '88dcf1f7-750d-4f0d-bdd9-6395aa723afb')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 2, 'reps', 10, 'rest_seconds', 30, 'rpe', 2)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (2, 'ccf774d5-52f1-41ae-8e80-c507927e6e2c')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 4, 'duration_seconds', 30, 'rest_seconds', 60,
                           'edge_depth_mm', 30, 'grip_type', 'HALF_CRIMP', 'weight_kg', 0, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (3, '82b2d80b-a34b-488b-b831-e141727628a9')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 2, 'reps', 8, 'rest_seconds', 30, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (4, '0f766ff6-47fa-450a-a541-56be6ea5abf9')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 12, 'rest_seconds', 60, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (5, 'e469bc65-5cdd-4e6d-bc3a-b163c896c577')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;

INSERT INTO workout_template_exercises (template_id, exercise_id, position, config)
SELECT wt.id, e.id, t.pos,
       jsonb_build_object('sets', 3, 'reps', 15, 'rest_seconds', 60, 'weight_kg', 1, 'rpe', 3)
FROM workout_templates wt, exercises e
CROSS JOIN (VALUES (6, '1e85588f-3bba-4bff-8e9f-acfd1590d467')) AS t(pos, ex_uuid)
WHERE wt.uuid = '0e2fb513-2655-471d-9811-c8f0d55b4a78'
  AND e.uuid = t.ex_uuid::uuid;


-- =============================================================================
-- 6. PLATFORM TRAINING PLANS
-- =============================================================================

-- 6.1 Finger Strength Block — 6 weeks (Intermediate, SPORT) ------------------

-- Plan
INSERT INTO training_plans (uuid, source, generation_type, owner_id, visibility,
                            difficulty_level, target_discipline, primary_goal_type_id,
                            duration_weeks, sessions_per_week, avg_session_duration_minutes,
                            training_volume,
                            requires_hangboard, requires_campus_board, requires_gym_access,
                            requires_outdoor_climbing, is_recovery_focused,
                            published_at)
SELECT 'c691418b-7a60-47f2-bd87-6df4221efa89',
       'PLATFORM', 'MANUAL', NULL, 'PUBLIC',
       'INTERMEDIATE', 'SPORT', gt.id,
       6, 2, 45,
       'MODERATE',
       TRUE, FALSE, FALSE, FALSE, FALSE,
       NOW()
FROM goal_types gt WHERE gt.code = 'FINGER_STRENGTH';

-- Plan translations ES
INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'es', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Bloque de fuerza de dedos — 6 semanas'),
    ('short_description', 'Programa de 6 semanas para aumentar la fuerza máxima de dedos mediante colgadas en hangboard.'),
    ('description', 'Plan de entrenamiento de 6 semanas con 2 sesiones semanales diseñado para mejorar la fuerza máxima de los dedos. Basado en colgadas máximas de 7 segundos en semi-arqueo y mano abierta. Incluye una semana de descarga cada 3 semanas para permitir la supercompensación. Recomendado para escaladores de nivel 6b-7b que quieren dar el salto al siguiente grado.'),
    ('methodology', 'Método de colgadas máximas con carga progresiva. Semanas 1-2: adaptación al 85 % RM. Semanas 3-4: fuerza al 90-95 % RM. Semana 5: pico de carga. Semana 6: descarga y test de reevaluación.'),
    ('prerequisites', '• Mínimo 1 año de escalada regular.\n• Sin lesiones activas en poleas o dedos.\n• Tener una regleta o hangboard con canto de 20 mm.\n• Haber completado un test de fuerza de dedos (FINGER_STRENGTH_V1) para conocer tu RM.'),
    ('expected_outcomes', '• Aumento del 10-15 % en la fuerza máxima de dedos.\n• Mejora de la confianza en presas pequeñas.\n• Base para progresar a entrenamiento de campus board.'),
    ('author_notes', 'Este plan es la base de cualquier programa de fuerza en escalada. Los resultados son muy predecibles si se respeta la progresión y el descanso. No tengas prisa; las poleas tardan meses en adaptarse.'),
    ('coaching_tips', '• Usa un temporizador para las series de 7 s.\n• Graba tus sesiones para verificar la forma del semi-arqueo.\n• Si fallas una serie, no la repitas: anota el fallo y baja el lastre la próxima sesión.\n• La semana de descarga no es opcional.')
) AS t(field, value)
WHERE uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89';

-- Plan translations EN
INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'en', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Finger Strength Block — 6 Weeks'),
    ('short_description', '6-week programme to increase maximum finger strength through hangboard hangs.'),
    ('description', '6-week training plan with 2 weekly sessions designed to improve maximum finger strength. Based on 7-second max hangs in half crimp and open hand. Includes a deload week every 3 weeks to allow supercompensation. Recommended for climbers at the 6b-7b level looking to break into the next grade.'),
    ('methodology', 'Max hang method with progressive loading. Weeks 1-2: adaptation at 85 % 1RM. Weeks 3-4: strength at 90-95 % 1RM. Week 5: peak load. Week 6: deload and reassessment test.'),
    ('prerequisites', '• Minimum 1 year of regular climbing.\n• No active pulley or finger injuries.\n• Access to a hangboard with a 20 mm edge.\n• Must have completed a finger strength test (FINGER_STRENGTH_V1) to know your 1RM.'),
    ('expected_outcomes', '• 10-15 % increase in maximum finger strength.\n• Improved confidence on small holds.\n• Foundation to progress to campus board training.'),
    ('author_notes', 'This plan is the foundation of any climbing strength programme. Results are highly predictable when progression and rest are respected. Be patient; pulleys take months to adapt.'),
    ('coaching_tips', '• Use a timer for the 7 s sets.\n• Record your sessions to verify half-crimp form.\n• If you fail a set, do not repeat it: log the failure and reduce weight next session.\n• The deload week is not optional.')
) AS t(field, value)
WHERE uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89';

-- Equipment
INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, FALSE FROM training_plans tp, equipment eq
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND eq.code = 'HANGBOARD';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, TRUE FROM training_plans tp, equipment eq
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND eq.code = 'WEIGHTED_BELT';

-- Weeks 1-6
INSERT INTO training_plan_weeks (uuid, plan_id, week_number, is_deload)
SELECT (CASE w
    WHEN 1 THEN '8a833107-a474-4461-8973-6bfac75968ce'
    WHEN 2 THEN 'f211056d-c2a5-4676-b49e-1924f4435b27'
    WHEN 3 THEN 'e492ed02-695d-4b8e-bb98-ec933923707b'
    WHEN 4 THEN 'e9759e04-0f40-4ec5-803d-96e38b41e5e5'
    WHEN 5 THEN '2bf491ab-48c2-4099-b937-e11f14570f7e'
    WHEN 6 THEN '2eb4aac2-02fb-448b-855c-9a95cc785c2e'
END)::uuid, tp.id, w, (w IN (3, 6))
FROM training_plans tp
CROSS JOIN generate_series(1, 6) AS w
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89';

-- Week translations (ES)
INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'es', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('8a833107-a474-4461-8973-6bfac75968ce', 'name',  'Semana 1 — Adaptación'),
    ('8a833107-a474-4461-8973-6bfac75968ce', 'focus', 'Adaptar el tejido conectivo a las cargas. Trabajo al 85 % RM.'),
    ('f211056d-c2a5-4676-b49e-1924f4435b27', 'name',  'Semana 2 — Progresión'),
    ('f211056d-c2a5-4676-b49e-1924f4435b27', 'focus', 'Subir carga al 90 % RM manteniendo calidad de agarre.'),
    ('e492ed02-695d-4b8e-bb98-ec933923707b', 'name',  'Semana 3 — Descarga'),
    ('e492ed02-695d-4b8e-bb98-ec933923707b', 'focus', 'Reducir volumen al 60 %. Permitir supercompensación.'),
    ('e9759e04-0f40-4ec5-803d-96e38b41e5e5', 'name',  'Semana 4 — Fuerza'),
    ('e9759e04-0f40-4ec5-803d-96e38b41e5e5', 'focus', 'Trabajo al 90-95 % RM. Series de calidad.'),
    ('2bf491ab-48c2-4099-b937-e11f14570f7e', 'name',  'Semana 5 — Pico'),
    ('2bf491ab-48c2-4099-b937-e11f14570f7e', 'focus', 'Carga máxima. Intentar nuevo RM en la última sesión.'),
    ('2eb4aac2-02fb-448b-855c-9a95cc785c2e', 'name',  'Semana 6 — Descarga y Test'),
    ('2eb4aac2-02fb-448b-855c-9a95cc785c2e', 'focus', 'Recuperación activa. Realizar test FINGER_STRENGTH_V1 al final.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89';

-- Week translations (EN)
INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'en', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('8a833107-a474-4461-8973-6bfac75968ce', 'name',  'Week 1 — Adaptation'),
    ('8a833107-a474-4461-8973-6bfac75968ce', 'focus', 'Adapt connective tissue to loads. Work at 85 % 1RM.'),
    ('f211056d-c2a5-4676-b49e-1924f4435b27', 'name',  'Week 2 — Progression'),
    ('f211056d-c2a5-4676-b49e-1924f4435b27', 'focus', 'Increase load to 90 % 1RM while maintaining grip quality.'),
    ('e492ed02-695d-4b8e-bb98-ec933923707b', 'name',  'Week 3 — Deload'),
    ('e492ed02-695d-4b8e-bb98-ec933923707b', 'focus', 'Reduce volume to 60 %. Allow supercompensation.'),
    ('e9759e04-0f40-4ec5-803d-96e38b41e5e5', 'name',  'Week 4 — Strength'),
    ('e9759e04-0f40-4ec5-803d-96e38b41e5e5', 'focus', 'Work at 90-95 % 1RM. Quality sets.'),
    ('2bf491ab-48c2-4099-b937-e11f14570f7e', 'name',  'Week 5 — Peak'),
    ('2bf491ab-48c2-4099-b937-e11f14570f7e', 'focus', 'Maximum load. Attempt new 1RM in the final session.'),
    ('2eb4aac2-02fb-448b-855c-9a95cc785c2e', 'name',  'Week 6 — Deload & Test'),
    ('2eb4aac2-02fb-448b-855c-9a95cc785c2e', 'focus', 'Active recovery. Perform FINGER_STRENGTH_V1 test at the end.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89';

-- Sessions: each week has 2 sessions (day 2 = max strength, day 5 = max strength + core)
-- We'll use the Max Hang Session template for day 2 and a variant for day 5
INSERT INTO training_plan_sessions (uuid, week_id, day_of_week, position, workout_template_id, is_optional)
SELECT gen_random_uuid(),
       wk.id, d, 1, wt.id, FALSE
FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
CROSS JOIN (VALUES (2), (5)) AS days(d)
CROSS JOIN workout_templates wt
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89'
  AND wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9';

-- Session notes ES
INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Realiza el calentamiento completo antes de las colgadas. Ajusta el lastre según la semana (consulta el foco de la semana).'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND s.day_of_week = 2;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Segunda sesión de hangboard de la semana. Si sientes fatiga acumulada, prioriza la calidad sobre la carga. Reduce el lastre un 5 % si es necesario.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND s.day_of_week = 5;

-- Session notes EN
INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Complete the full warm-up before hangs. Adjust weight according to the week (see week focus).'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND s.day_of_week = 2;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Second hangboard session of the week. If you feel accumulated fatigue, prioritise quality over load. Reduce weight by 5 % if needed.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'c691418b-7a60-47f2-bd87-6df4221efa89' AND s.day_of_week = 5;


-- 6.2 Endurance Builder — 8 weeks (Intermediate, SPORT) -----------------------

INSERT INTO training_plans (uuid, source, generation_type, owner_id, visibility,
                            difficulty_level, target_discipline, primary_goal_type_id,
                            duration_weeks, sessions_per_week, avg_session_duration_minutes,
                            training_volume,
                            requires_hangboard, requires_campus_board, requires_gym_access,
                            requires_outdoor_climbing, is_recovery_focused,
                            published_at)
SELECT 'fc3830c5-e333-41ae-8416-b3f74c5a3341',
       'PLATFORM', 'MANUAL', NULL, 'PUBLIC',
       'INTERMEDIATE', 'SPORT', gt.id,
       8, 3, 50,
       'HIGH',
       TRUE, FALSE, TRUE, FALSE, FALSE,
       NOW()
FROM goal_types gt WHERE gt.code = 'POWER_ENDURANCE';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'es', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Constructor de resistencia — 8 semanas'),
    ('short_description', 'Plan de 8 semanas para desarrollar resistencia de fuerza y tolerancia al bombeo.'),
    ('description', 'Programa de 8 semanas con 3 sesiones semanales que combina repetidores en hangboard, ARC training y 4×4 en bloque. Ideal para escaladores deportivos que quieren encadenar vías más largas sin perder fuerza al final. La carga de hangboard se mantiene al 70 % RM con aumento progresivo de volumen.'),
    ('methodology', 'Periodización lineal: bloque de base aeróbica (semanas 1-3), bloque de resistencia de fuerza (semanas 4-6), bloque de pico (semanas 7-8). Cada bloque añade intensidad específica mientras mantiene el volumen del bloque anterior.'),
    ('prerequisites', '• Nivel mínimo de escalada deportiva 6b.\n• Haber completado un test de fuerza de dedos (FINGER_STRENGTH_V1).\n• Haber completado un test de resistencia (ENDURANCE_REPEATERS_V1) recomendado.\n• Acceso a hangboard y rocódromo con travesías.'),
    ('expected_outcomes', '• Aumento significativo del tiempo hasta el fallo en repetidores (50-100 %).\n• Mejora en la resistencia al bombeo en vías de 20-30 movimientos.\n• Mayor densidad capilar en el antebrazo.'),
    ('author_notes', 'La resistencia es la cualidad que más rápido se gana y más rápido se pierde. Este plan es ideal para pretemporada o para un ciclo de 2 meses antes de un viaje de escalada deportiva.'),
    ('coaching_tips', '• La clave de los repetidores es NO fallar: ajusta el peso para completar TODOS los bloques.\n• El ARC debe ser aburrido. Si te diviertes, vas demasiado fuerte.\n• Los 4×4 requieren frescura mental. Hazlos al principio de la sesión.')
) AS t(field, value)
WHERE uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'en', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Endurance Builder — 8 Weeks'),
    ('short_description', '8-week programme to develop power endurance and pump tolerance.'),
    ('description', '8-week programme with 3 weekly sessions combining hangboard repeaters, ARC training and 4×4 boulder intervals. Ideal for sport climbers who want to send longer routes without losing strength at the end. Hangboard load stays at 70 % 1RM with progressive volume increases.'),
    ('methodology', 'Linear periodisation: aerobic base block (weeks 1-3), power-endurance block (weeks 4-6), peak block (weeks 7-8). Each block adds specific intensity while maintaining the previous block''s volume.'),
    ('prerequisites', '• Minimum sport climbing level 6b.\n• Must have completed a finger strength test (FINGER_STRENGTH_V1).\n• Having completed an endurance test (ENDURANCE_REPEATERS_V1) is recommended.\n• Access to a hangboard and a climbing gym with traverses.'),
    ('expected_outcomes', '• Significant increase in time to failure on repeaters (50-100 %).\n• Improved pump resistance on 20-30 move routes.\n• Greater forearm capillary density.'),
    ('author_notes', 'Endurance is the quality gained fastest and lost fastest. This plan is ideal for pre-season or a 2-month cycle before a sport climbing trip.'),
    ('coaching_tips', '• The key to repeaters is NOT failing: adjust weight to complete ALL blocks.\n• ARC should be boring. If you''re having fun, you''re going too hard.\n• 4×4s require mental freshness. Do them at the start of the session.')
) AS t(field, value)
WHERE uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341';

-- Equipment
INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, FALSE FROM training_plans tp, equipment eq
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341' AND eq.code = 'HANGBOARD';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, TRUE FROM training_plans tp, equipment eq
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341' AND eq.code = 'PULLUP_BAR';

-- Secondary goals
INSERT INTO training_plan_secondary_goals (plan_id, goal_type_id)
SELECT tp.id, gt.id FROM training_plans tp, goal_types gt
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341' AND gt.code = 'AEROBIC_BASE';

-- Weeks 1-8
INSERT INTO training_plan_weeks (uuid, plan_id, week_number, is_deload)
SELECT (CASE w
    WHEN 1 THEN 'cb1d8ef4-f6e1-4358-979a-8ef4cacfbedd'
    WHEN 2 THEN 'a3df5b29-38d9-440b-b234-214a28902242'
    WHEN 3 THEN 'f04068b7-ddda-4ba0-8adf-31a158d73130'
    WHEN 4 THEN 'f8977302-9cf5-4e42-8009-059fcbb4a2a8'
    WHEN 5 THEN 'a51d3b4b-c04e-42ff-b452-a32768e29954'
    WHEN 6 THEN '82d93aa7-80fc-4c83-8e60-ddc15a64ad93'
    WHEN 7 THEN '50b62bf6-bfc5-419e-9f06-ee4620347a10'
    WHEN 8 THEN '3f379c56-b460-47a5-8ba8-c75090bea025'
END)::uuid, tp.id, w, (w IN (4, 8))
FROM training_plans tp
CROSS JOIN generate_series(1, 8) AS w
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'es', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('cb1d8ef4-f6e1-4358-979a-8ef4cacfbedd', 'name', 'Semana 1 — Base'),
    ('cb1d8ef4-f6e1-4358-979a-8ef4cacfbedd', 'focus', 'ARC 20 min + familiarización con repetidores.'),
    ('a3df5b29-38d9-440b-b234-214a28902242', 'name', 'Semana 2 — Base'),
    ('a3df5b29-38d9-440b-b234-214a28902242', 'focus', 'ARC 25 min + repetidores 4 bloques.'),
    ('f04068b7-ddda-4ba0-8adf-31a158d73130', 'name', 'Semana 3 — Base'),
    ('f04068b7-ddda-4ba0-8adf-31a158d73130', 'focus', 'ARC 30 min + repetidores 5 bloques.'),
    ('f8977302-9cf5-4e42-8009-059fcbb4a2a8', 'name', 'Semana 4 — Descarga'),
    ('f8977302-9cf5-4e42-8009-059fcbb4a2a8', 'focus', 'ARC 15 min suave. Sin repetidores.'),
    ('a51d3b4b-c04e-42ff-b452-a32768e29954', 'name', 'Semana 5 — Resistencia de fuerza'),
    ('a51d3b4b-c04e-42ff-b452-a32768e29954', 'focus', 'Repetidores 6 bloques + 4×4 básico.'),
    ('82d93aa7-80fc-4c83-8e60-ddc15a64ad93', 'name', 'Semana 6 — Resistencia de fuerza'),
    ('82d93aa7-80fc-4c83-8e60-ddc15a64ad93', 'focus', 'Repetidores 7 bloques + 4×4 intermedio.'),
    ('50b62bf6-bfc5-419e-9f06-ee4620347a10', 'name', 'Semana 7 — Pico'),
    ('50b62bf6-bfc5-419e-9f06-ee4620347a10', 'focus', 'Repetidores 8 bloques + 4×4 al límite.'),
    ('3f379c56-b460-47a5-8ba8-c75090bea025', 'name', 'Semana 8 — Descarga'),
    ('3f379c56-b460-47a5-8ba8-c75090bea025', 'focus', 'Recuperación activa. ARC 15 min + movilidad.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'en', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('cb1d8ef4-f6e1-4358-979a-8ef4cacfbedd', 'name', 'Week 1 — Base'),
    ('cb1d8ef4-f6e1-4358-979a-8ef4cacfbedd', 'focus', 'ARC 20 min + repeater familiarisation.'),
    ('a3df5b29-38d9-440b-b234-214a28902242', 'name', 'Week 2 — Base'),
    ('a3df5b29-38d9-440b-b234-214a28902242', 'focus', 'ARC 25 min + repeaters 4 blocks.'),
    ('f04068b7-ddda-4ba0-8adf-31a158d73130', 'name', 'Week 3 — Base'),
    ('f04068b7-ddda-4ba0-8adf-31a158d73130', 'focus', 'ARC 30 min + repeaters 5 blocks.'),
    ('f8977302-9cf5-4e42-8009-059fcbb4a2a8', 'name', 'Week 4 — Deload'),
    ('f8977302-9cf5-4e42-8009-059fcbb4a2a8', 'focus', 'Light ARC 15 min. No repeaters.'),
    ('a51d3b4b-c04e-42ff-b452-a32768e29954', 'name', 'Week 5 — Power Endurance'),
    ('a51d3b4b-c04e-42ff-b452-a32768e29954', 'focus', 'Repeaters 6 blocks + basic 4×4.'),
    ('82d93aa7-80fc-4c83-8e60-ddc15a64ad93', 'name', 'Week 6 — Power Endurance'),
    ('82d93aa7-80fc-4c83-8e60-ddc15a64ad93', 'focus', 'Repeaters 7 blocks + intermediate 4×4.'),
    ('50b62bf6-bfc5-419e-9f06-ee4620347a10', 'name', 'Week 7 — Peak'),
    ('50b62bf6-bfc5-419e-9f06-ee4620347a10', 'focus', 'Repeaters 8 blocks + max 4×4.'),
    ('3f379c56-b460-47a5-8ba8-c75090bea025', 'name', 'Week 8 — Deload'),
    ('3f379c56-b460-47a5-8ba8-c75090bea025', 'focus', 'Active recovery. ARC 15 min + mobility.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341';

-- Sessions for endurance plan: each week 3 sessions
-- All sessions use the repeater endurance template for simplicity
INSERT INTO training_plan_sessions (uuid, week_id, day_of_week, position, workout_template_id, is_optional)
SELECT gen_random_uuid(),
       wk.id, d, 1, wt.id, FALSE
FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
CROSS JOIN (VALUES (2), (4), (6)) AS days(d)
CROSS JOIN workout_templates wt
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341'
  AND wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49';

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión de repetidores. Ajusta la carga al 70 % de tu RM. Usa temporizador de intervalos 7/3.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341' AND s.day_of_week IN (2, 6);

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Repeater session. Set load at 70 % of your 1RM. Use a 7/3 interval timer.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = 'fc3830c5-e333-41ae-8416-b3f74c5a3341' AND s.day_of_week IN (2, 6);


-- 6.3 Full Body Foundation — 4 weeks (Beginner, All disciplines) --------------

INSERT INTO training_plans (uuid, source, generation_type, owner_id, visibility,
                            difficulty_level, target_discipline, primary_goal_type_id,
                            duration_weeks, sessions_per_week, avg_session_duration_minutes,
                            training_volume,
                            requires_hangboard, requires_campus_board, requires_gym_access,
                            requires_outdoor_climbing, is_recovery_focused,
                            published_at)
SELECT '20ca0754-b314-49dc-bb30-fa32c0e0487a',
       'PLATFORM', 'MANUAL', NULL, 'PUBLIC',
       'BEGINNER', 'SPORT', gt.id,
       4, 2, 45,
       'LOW',
       TRUE, FALSE, FALSE, FALSE, FALSE,
       NOW()
FROM goal_types gt WHERE gt.code = 'GENERAL_STRENGTH';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'es', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Fundamentos de fuerza — 4 semanas'),
    ('short_description', 'Plan de iniciación de 4 semanas para construir una base de fuerza general para escalada.'),
    ('description', 'Programa de 4 semanas con 2 sesiones semanales diseñado para principiantes que quieren empezar a entrenar fuerza de forma estructurada. Combina colgadas de densidad en hangboard, dominadas básicas, core y ejercicios de prevención. El volumen es bajo y la progresión lenta para minimizar el riesgo de lesión.'),
    ('methodology', 'Adaptación progresiva. Semanas 1-2: familiarización con los ejercicios y cargas bajas. Semanas 3-4: aumento gradual de intensidad. No se persiguen récords: el objetivo es construir hábitos y aprender la técnica correcta.'),
    ('prerequisites', '• Ninguno. Apto para cualquier persona que escale regularmente.\n• Acceso a hangboard y barra de dominadas.'),
    ('expected_outcomes', '• Mejora de la fuerza de tracción y core.\n• Adaptación del tejido conectivo de los dedos.\n• Comprensión de los ejercicios fundamentales de entrenamiento.'),
    ('author_notes', 'Este plan es la puerta de entrada al entrenamiento estructurado. No te saltes la fase de adaptación aunque te sientas fuerte. Las poleas necesitan meses para fortalecerse.'),
    ('coaching_tips', '• La técnica es más importante que la carga.\n• Si un ejercicio causa dolor, sustitúyelo.\n• Haz las sesiones de prehabilitación aunque no tengas molestias.')
) AS t(field, value)
WHERE uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'en', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Strength Foundations — 4 Weeks'),
    ('short_description', '4-week introductory plan to build a general strength base for climbing.'),
    ('description', '4-week programme with 2 weekly sessions designed for beginners who want to start structured strength training. Combines density hangs on a hangboard, basic pull-ups, core and injury-prevention exercises. Volume is low and progression is slow to minimise injury risk.'),
    ('methodology', 'Progressive adaptation. Weeks 1-2: familiarisation with exercises and low loads. Weeks 3-4: gradual intensity increase. No records are pursued: the goal is to build habits and learn correct technique.'),
    ('prerequisites', '• None. Suitable for anyone who climbs regularly.\n• Access to a hangboard and pull-up bar.'),
    ('expected_outcomes', '• Improved pulling and core strength.\n• Connective tissue adaptation in the fingers.\n• Understanding of fundamental training exercises.'),
    ('author_notes', 'This plan is the gateway to structured training. Do not skip the adaptation phase even if you feel strong. Pulleys need months to strengthen.'),
    ('coaching_tips', '• Technique is more important than load.\n• If an exercise causes pain, substitute it.\n• Do the prehab sessions even if you have no discomfort.')
) AS t(field, value)
WHERE uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a';

-- Equipment
INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, FALSE FROM training_plans tp, equipment eq
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND eq.code = 'HANGBOARD';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, FALSE FROM training_plans tp, equipment eq
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND eq.code = 'PULLUP_BAR';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, TRUE FROM training_plans tp, equipment eq
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND eq.code = 'RESISTANCE_BAND';

-- Weeks 1-4
INSERT INTO training_plan_weeks (uuid, plan_id, week_number, is_deload)
SELECT (CASE w
    WHEN 1 THEN '8ce9e64b-c40d-4a39-b160-d84bf7ad76d5'
    WHEN 2 THEN '64679e75-756a-4057-9775-9e1ba5d1ce5f'
    WHEN 3 THEN '65c3a0db-c85a-4354-9776-ce8beab3b65a'
    WHEN 4 THEN '044bfeac-6099-4a8f-9f7f-b69324d04ad9'
END)::uuid, tp.id, w, FALSE
FROM training_plans tp
CROSS JOIN generate_series(1, 4) AS w
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'es', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('8ce9e64b-c40d-4a39-b160-d84bf7ad76d5', 'name', 'Semana 1 — Descubrimiento'),
    ('8ce9e64b-c40d-4a39-b160-d84bf7ad76d5', 'focus', 'Aprender la técnica de cada ejercicio. Cargas mínimas.'),
    ('64679e75-756a-4057-9775-9e1ba5d1ce5f', 'name', 'Semana 2 — Consolidación'),
    ('64679e75-756a-4057-9775-9e1ba5d1ce5f', 'focus', 'Repetir con la misma carga, mejorando la ejecución.'),
    ('65c3a0db-c85a-4354-9776-ce8beab3b65a', 'name', 'Semana 3 — Progresión'),
    ('65c3a0db-c85a-4354-9776-ce8beab3b65a', 'focus', 'Aumentar ligeramente la carga en dominadas y colgadas.'),
    ('044bfeac-6099-4a8f-9f7f-b69324d04ad9', 'name', 'Semana 4 — Evaluación'),
    ('044bfeac-6099-4a8f-9f7f-b69324d04ad9', 'focus', 'Test de fuerza de dedos y dominadas para planificar el siguiente ciclo.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'en', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('8ce9e64b-c40d-4a39-b160-d84bf7ad76d5', 'name', 'Week 1 — Discovery'),
    ('8ce9e64b-c40d-4a39-b160-d84bf7ad76d5', 'focus', 'Learn the technique for each exercise. Minimal loads.'),
    ('64679e75-756a-4057-9775-9e1ba5d1ce5f', 'name', 'Week 2 — Consolidation'),
    ('64679e75-756a-4057-9775-9e1ba5d1ce5f', 'focus', 'Repeat with the same load, improving execution.'),
    ('65c3a0db-c85a-4354-9776-ce8beab3b65a', 'name', 'Week 3 — Progression'),
    ('65c3a0db-c85a-4354-9776-ce8beab3b65a', 'focus', 'Slightly increase load on pull-ups and hangs.'),
    ('044bfeac-6099-4a8f-9f7f-b69324d04ad9', 'name', 'Week 4 — Assessment'),
    ('044bfeac-6099-4a8f-9f7f-b69324d04ad9', 'focus', 'Finger strength and pull-up test to plan the next cycle.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a';

-- Sessions: Day 3 = strength, Day 6 = strength + prehab
INSERT INTO training_plan_sessions (uuid, week_id, day_of_week, position, workout_template_id, is_optional)
SELECT gen_random_uuid(),
       wk.id, d, 1, wt.id, FALSE
FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
CROSS JOIN (VALUES (3), (6)) AS days(d)
CROSS JOIN workout_templates wt
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a'
  AND CASE WHEN d = 3 THEN wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
           ELSE wt.uuid = '82b2d80b-a34b-488b-b831-e141727628a9' END;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión de fuerza. Concéntrate en la técnica. No añadas peso hasta que el movimiento sea perfecto.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND s.day_of_week = 3;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión de prehabilitación. Ligera y controlada. No deberías terminar cansado.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND s.day_of_week = 6;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Strength session. Focus on technique. Do not add weight until the movement is perfect.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND s.day_of_week = 3;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Prehab session. Light and controlled. You should not finish feeling tired.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '20ca0754-b314-49dc-bb30-fa32c0e0487a' AND s.day_of_week = 6;


-- 6.4 Pre-Season Prep — 4 weeks (Advanced, SPORT) ----------------------------

INSERT INTO training_plans (uuid, source, generation_type, owner_id, visibility,
                            difficulty_level, target_discipline, primary_goal_type_id,
                            duration_weeks, sessions_per_week, avg_session_duration_minutes,
                            training_volume,
                            requires_hangboard, requires_campus_board, requires_gym_access,
                            requires_outdoor_climbing, is_recovery_focused,
                            published_at)
SELECT '3dfc2316-31f1-4f03-a537-f4d42e6fee80',
       'PLATFORM', 'MANUAL', NULL, 'PUBLIC',
       'ADVANCED', 'SPORT', gt.id,
       4, 3, 60,
       'HIGH',
       TRUE, TRUE, TRUE, FALSE, FALSE,
       NOW()
FROM goal_types gt WHERE gt.code = 'GRADE_TARGET';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'es', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Preparación pre-temporada — 4 semanas'),
    ('short_description', 'Plan intensivo de 4 semanas para llegar al pico de forma antes de una temporada de proyectos.'),
    ('description', 'Programa avanzado de 4 semanas con 3 sesiones semanales de alta intensidad. Diseñado para escaladores que ya tienen varios años de entrenamiento y quieren afinar la forma justo antes de una temporada al aire libre o una competición. Combina fuerza máxima, campus board y resistencia específica.'),
    ('methodology', 'Semanas 1-2: carga alta de fuerza + campus board. Semana 3: pico de intensidad con reducción de volumen. Semana 4: descarga activa para llegar fresco a la temporada. La periodización es inversa: se acumula fatiga al principio y se disipa hacia el final.'),
    ('prerequisites', '• Mínimo 3 años de escalada y 1 año de entrenamiento estructurado.\n• Sin lesiones activas.\n• Test de fuerza de dedos completado con un ratio fuerza/peso > 1.2 (7a/7A+).\n• Experiencia previa con campus board.'),
    ('expected_outcomes', '• Pico de fuerza de dedos.\n• Mejora de la potencia de contacto.\n• Confianza en movimientos explosivos.'),
    ('author_notes', 'Este plan es exigente. No lo hagas si tienes molestias en poleas o codos. La temporada se gana en la pretemporada, pero se pierde por lesiones en la preparación.'),
    ('coaching_tips', '• Escucha a tu cuerpo. Si hay dolor articular, sustituye campus por colgadas.\n• Aumenta la ingesta de proteína y el sueño durante este bloque.\n• La semana 4 no es opcional: necesitas llegar descansado.')
) AS t(field, value)
WHERE uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80';

INSERT INTO training_plan_translations (plan_id, locale, field, value)
SELECT id, 'en', t.field, t.value FROM training_plans
CROSS JOIN (VALUES
    ('name', 'Pre-Season Prep — 4 Weeks'),
    ('short_description', 'Intensive 4-week plan to peak before a project season.'),
    ('description', 'Advanced 4-week programme with 3 high-intensity weekly sessions. Designed for climbers with several years of training who want to fine-tune their form just before an outdoor season or competition. Combines max strength, campus board and specific endurance.'),
    ('methodology', 'Weeks 1-2: high load strength + campus board. Week 3: peak intensity with reduced volume. Week 4: active deload to arrive fresh for the season. Periodisation is reverse: fatigue accumulates early and dissipates toward the end.'),
    ('prerequisites', '• Minimum 3 years climbing and 1 year of structured training.\n• No active injuries.\n• Finger strength test completed with a strength-to-weight ratio > 1.2 (7a/7A+).\n• Prior experience with campus board.'),
    ('expected_outcomes', '• Peak finger strength.\n• Improved contact power.\n• Confidence in explosive movements.'),
    ('author_notes', 'This plan is demanding. Do not attempt if you have pulley or elbow discomfort. The season is won in pre-season, but lost to injuries during preparation.'),
    ('coaching_tips', '• Listen to your body. If there is joint pain, substitute campus for hangs.\n• Increase protein intake and sleep during this block.\n• Week 4 is not optional: you need to arrive rested.')
) AS t(field, value)
WHERE uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80';

-- Equipment
INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, FALSE FROM training_plans tp, equipment eq
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND eq.code = 'HANGBOARD';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, TRUE FROM training_plans tp, equipment eq
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND eq.code = 'CAMPUS_BOARD';

INSERT INTO training_plan_equipment (plan_id, equipment_id, is_optional)
SELECT tp.id, eq.id, TRUE FROM training_plans tp, equipment eq
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND eq.code = 'WEIGHTED_BELT';

-- Weeks 1-4
INSERT INTO training_plan_weeks (uuid, plan_id, week_number, is_deload)
SELECT (CASE w
    WHEN 1 THEN '80919889-485f-4449-b9c8-639b6911588e'
    WHEN 2 THEN 'd4fae4db-5b0b-4fda-88e2-9c78fbf2b3d2'
    WHEN 3 THEN '64db25ed-c440-4fc2-a2b7-444c98f01d62'
    WHEN 4 THEN '269523be-e199-4768-98c8-4bc5ef59fd7e'
END)::uuid, tp.id, w, (w = 4)
FROM training_plans tp
CROSS JOIN generate_series(1, 4) AS w
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'es', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('80919889-485f-4449-b9c8-639b6911588e', 'name', 'Semana 1 — Carga'),
    ('80919889-485f-4449-b9c8-639b6911588e', 'focus', 'Fuerza máxima al 90 % + campus básico. Alto volumen.'),
    ('d4fae4db-5b0b-4fda-88e2-9c78fbf2b3d2', 'name', 'Semana 2 — Sobrecarga'),
    ('d4fae4db-5b0b-4fda-88e2-9c78fbf2b3d2', 'focus', 'Fuerza máxima al 95 % + campus intermedio. Máximo volumen tolerable.'),
    ('64db25ed-c440-4fc2-a2b7-444c98f01d62', 'name', 'Semana 3 — Pico'),
    ('64db25ed-c440-4fc2-a2b7-444c98f01d62', 'focus', 'Intensidad máxima, volumen reducido. Test de RM en hangboard.'),
    ('269523be-e199-4768-98c8-4bc5ef59fd7e', 'name', 'Semana 4 — Descarga'),
    ('269523be-e199-4768-98c8-4bc5ef59fd7e', 'focus', 'Recuperación activa. Movilidad, ARC ligero, sin cargas.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80';

INSERT INTO training_plan_week_translations (week_id, locale, field, value)
SELECT wk.id, 'en', t.field, t.value FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
JOIN (VALUES
    ('80919889-485f-4449-b9c8-639b6911588e', 'name', 'Week 1 — Loading'),
    ('80919889-485f-4449-b9c8-639b6911588e', 'focus', 'Max strength at 90 % + basic campus. High volume.'),
    ('d4fae4db-5b0b-4fda-88e2-9c78fbf2b3d2', 'name', 'Week 2 — Overload'),
    ('d4fae4db-5b0b-4fda-88e2-9c78fbf2b3d2', 'focus', 'Max strength at 95 % + intermediate campus. Maximum tolerable volume.'),
    ('64db25ed-c440-4fc2-a2b7-444c98f01d62', 'name', 'Week 3 — Peak'),
    ('64db25ed-c440-4fc2-a2b7-444c98f01d62', 'focus', 'Maximum intensity, reduced volume. Hangboard 1RM test.'),
    ('269523be-e199-4768-98c8-4bc5ef59fd7e', 'name', 'Week 4 — Deload'),
    ('269523be-e199-4768-98c8-4bc5ef59fd7e', 'focus', 'Active recovery. Mobility, light ARC, no loads.')
) AS t(week_uuid, field, value) ON wk.uuid = t.week_uuid::uuid
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80';

-- Sessions: Day 2 = max strength, Day 4 = power, Day 6 = endurance
-- Simplify: day 2 uses max hang, day 4 uses strength, day 6 uses endurance
INSERT INTO training_plan_sessions (uuid, week_id, day_of_week, position, workout_template_id, is_optional)
SELECT gen_random_uuid(),
       wk.id, d, 1, wt.id, FALSE
FROM training_plan_weeks wk
JOIN training_plans tp ON tp.id = wk.plan_id
CROSS JOIN (VALUES (2), (4), (6)) AS days(d)
CROSS JOIN workout_templates wt
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80'
  AND CASE
        WHEN d = 2 THEN wt.uuid = '25301f4c-bd5f-4d8b-8c50-2bbdb20f7af9'
        WHEN d = 4 THEN wt.uuid = '0d5487ca-afc2-44ff-a5b0-b0e2713f2874'
        ELSE wt.uuid = 'bd985851-6a9e-4838-99d2-732a04010a49'
      END;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión principal de fuerza. Día de mayor carga. Prioriza la calidad de cada serie.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 2;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión de potencia y fuerza general. Si usas campus board, hazlo al inicio de la sesión con los dedos frescos.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 4;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'es', 'notes',
       'Sesión de resistencia. Mantén la intensidad moderada. No falles en los repetidores.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 6;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Main strength session. Heaviest day. Prioritise quality on every set.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 2;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Power and general strength session. If using campus board, do it at the start of the session with fresh fingers.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 4;

INSERT INTO training_plan_session_translations (session_id, locale, field, value)
SELECT s.id, 'en', 'notes',
       'Endurance session. Keep intensity moderate. Do not fail on repeaters.'
FROM training_plan_sessions s
JOIN training_plan_weeks wk ON wk.id = s.week_id
JOIN training_plans tp ON tp.id = wk.plan_id
WHERE tp.uuid = '3dfc2316-31f1-4f03-a537-f4d42e6fee80' AND s.day_of_week = 6;
