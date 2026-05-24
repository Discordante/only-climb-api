-- =============================================================================
-- V15 — Catalog seeds: climbing grades + ES/EN translations for every catalog.
-- Spanish is the default project locale; English is the canonical fallback.
-- =============================================================================

-- Climbing grades ------------------------------------------------------------

INSERT INTO climbing_grades (scale, value, sort_order) VALUES
    ('FRENCH', '4',    100),
    ('FRENCH', '5a',   200),
    ('FRENCH', '5b',   210),
    ('FRENCH', '5c',   220),
    ('FRENCH', '6a',   300),
    ('FRENCH', '6a+',  310),
    ('FRENCH', '6b',   320),
    ('FRENCH', '6b+',  330),
    ('FRENCH', '6c',   340),
    ('FRENCH', '6c+',  350),
    ('FRENCH', '7a',   400),
    ('FRENCH', '7a+',  410),
    ('FRENCH', '7b',   420),
    ('FRENCH', '7b+',  430),
    ('FRENCH', '7c',   440),
    ('FRENCH', '7c+',  450),
    ('FRENCH', '8a',   500),
    ('FRENCH', '8a+',  510),
    ('FRENCH', '8b',   520),
    ('FRENCH', '8b+',  530),
    ('FRENCH', '8c',   540),
    ('FRENCH', '8c+',  550),
    ('FRENCH', '9a',   600),
    ('FRENCH', '9a+',  610),
    ('FRENCH', '9b',   620),
    ('FRENCH', '9b+',  630),
    ('FRENCH', '9c',   640),
    ('FONTAINEBLEAU', '3',    100),
    ('FONTAINEBLEAU', '4',    200),
    ('FONTAINEBLEAU', '5',    300),
    ('FONTAINEBLEAU', '5+',   310),
    ('FONTAINEBLEAU', '6A',   400),
    ('FONTAINEBLEAU', '6A+',  410),
    ('FONTAINEBLEAU', '6B',   420),
    ('FONTAINEBLEAU', '6B+',  430),
    ('FONTAINEBLEAU', '6C',   440),
    ('FONTAINEBLEAU', '6C+',  450),
    ('FONTAINEBLEAU', '7A',   500),
    ('FONTAINEBLEAU', '7A+',  510),
    ('FONTAINEBLEAU', '7B',   520),
    ('FONTAINEBLEAU', '7B+',  530),
    ('FONTAINEBLEAU', '7C',   540),
    ('FONTAINEBLEAU', '7C+',  550),
    ('FONTAINEBLEAU', '8A',   600),
    ('FONTAINEBLEAU', '8A+',  610),
    ('FONTAINEBLEAU', '8B',   620),
    ('FONTAINEBLEAU', '8B+',  630),
    ('FONTAINEBLEAU', '8C',   640),
    ('FONTAINEBLEAU', '8C+',  650),
    ('FONTAINEBLEAU', '9A',   700);

-- Exercise categories --------------------------------------------------------

UPDATE exercise_categories SET sort_order = 10  WHERE code = 'HANGBOARD';
UPDATE exercise_categories SET sort_order = 20  WHERE code = 'PULL';
UPDATE exercise_categories SET sort_order = 30  WHERE code = 'CORE';
UPDATE exercise_categories SET sort_order = 40  WHERE code = 'ANTAGONIST';
UPDATE exercise_categories SET sort_order = 50  WHERE code = 'FLEXIBILITY';
UPDATE exercise_categories SET sort_order = 60  WHERE code = 'ENDURANCE';
UPDATE exercise_categories SET sort_order = 70  WHERE code = 'TECHNIQUE';

INSERT INTO exercise_category_translations (category_id, locale, field, value)
SELECT c.id, t.locale, t.field, t.value FROM exercise_categories c
JOIN (VALUES
    ('HANGBOARD',   'es', 'name', 'Hangboard'),
    ('HANGBOARD',   'en', 'name', 'Hangboard'),
    ('HANGBOARD',   'es', 'description', 'Entrenamiento de dedos en regleta o suspensiones.'),
    ('HANGBOARD',   'en', 'description', 'Finger strength on hangboard edges or hangs.'),
    ('PULL',        'es', 'name', 'Tracción'),
    ('PULL',        'en', 'name', 'Pull'),
    ('PULL',        'es', 'description', 'Fuerza de tracción de espalda y brazos.'),
    ('PULL',        'en', 'description', 'Back and arm pulling strength.'),
    ('CORE',        'es', 'name', 'Core'),
    ('CORE',        'en', 'name', 'Core'),
    ('CORE',        'es', 'description', 'Estabilidad y tensión corporal.'),
    ('CORE',        'en', 'description', 'Body tension and core stability.'),
    ('ANTAGONIST',  'es', 'name', 'Antagonistas'),
    ('ANTAGONIST',  'en', 'name', 'Antagonist'),
    ('ANTAGONIST',  'es', 'description', 'Trabajo de prevención de lesiones para músculos opuestos.'),
    ('ANTAGONIST',  'en', 'description', 'Injury-prevention work for opposing muscle groups.'),
    ('FLEXIBILITY', 'es', 'name', 'Flexibilidad'),
    ('FLEXIBILITY', 'en', 'name', 'Flexibility'),
    ('FLEXIBILITY', 'es', 'description', 'Estiramientos y rango de movimiento.'),
    ('FLEXIBILITY', 'en', 'description', 'Stretching and range of motion.'),
    ('ENDURANCE',   'es', 'name', 'Resistencia'),
    ('ENDURANCE',   'en', 'name', 'Endurance'),
    ('ENDURANCE',   'es', 'description', 'Capacidad aeróbica y resistencia de antebrazo.'),
    ('ENDURANCE',   'en', 'description', 'Aerobic capacity and forearm endurance.'),
    ('TECHNIQUE',   'es', 'name', 'Técnica'),
    ('TECHNIQUE',   'en', 'name', 'Technique'),
    ('TECHNIQUE',   'es', 'description', 'Ejercicios de movilidad, pies y eficiencia.'),
    ('TECHNIQUE',   'en', 'description', 'Footwork, movement and efficiency drills.')
) AS t(code, locale, field, value) ON c.code = t.code;

-- Muscle groups --------------------------------------------------------------

UPDATE muscle_groups SET sort_order = 10 WHERE code = 'FINGERS';
UPDATE muscle_groups SET sort_order = 20 WHERE code = 'FOREARM';
UPDATE muscle_groups SET sort_order = 30 WHERE code = 'BACK';
UPDATE muscle_groups SET sort_order = 40 WHERE code = 'SHOULDERS';
UPDATE muscle_groups SET sort_order = 50 WHERE code = 'CORE';
UPDATE muscle_groups SET sort_order = 60 WHERE code = 'CHEST';
UPDATE muscle_groups SET sort_order = 70 WHERE code = 'ARMS';
UPDATE muscle_groups SET sort_order = 80 WHERE code = 'LEGS';
UPDATE muscle_groups SET sort_order = 90 WHERE code = 'FULL_BODY';

INSERT INTO muscle_group_translations (muscle_group_id, locale, field, value)
SELECT m.id, t.locale, t.field, t.value FROM muscle_groups m
JOIN (VALUES
    ('FINGERS',   'es', 'name', 'Dedos'),
    ('FINGERS',   'en', 'name', 'Fingers'),
    ('FOREARM',   'es', 'name', 'Antebrazo'),
    ('FOREARM',   'en', 'name', 'Forearm'),
    ('BACK',      'es', 'name', 'Espalda'),
    ('BACK',      'en', 'name', 'Back'),
    ('SHOULDERS', 'es', 'name', 'Hombros'),
    ('SHOULDERS', 'en', 'name', 'Shoulders'),
    ('CORE',      'es', 'name', 'Core'),
    ('CORE',      'en', 'name', 'Core'),
    ('CHEST',     'es', 'name', 'Pecho'),
    ('CHEST',     'en', 'name', 'Chest'),
    ('ARMS',      'es', 'name', 'Brazos'),
    ('ARMS',      'en', 'name', 'Arms'),
    ('LEGS',      'es', 'name', 'Piernas'),
    ('LEGS',      'en', 'name', 'Legs'),
    ('FULL_BODY', 'es', 'name', 'Cuerpo completo'),
    ('FULL_BODY', 'en', 'name', 'Full body')
) AS t(code, locale, field, value) ON m.code = t.code;

-- Grip types -----------------------------------------------------------------

UPDATE grip_types SET sort_order = 10 WHERE code = 'CRIMP';
UPDATE grip_types SET sort_order = 20 WHERE code = 'HALF_CRIMP';
UPDATE grip_types SET sort_order = 30 WHERE code = 'OPEN_HAND';
UPDATE grip_types SET sort_order = 40 WHERE code = 'PINCH';
UPDATE grip_types SET sort_order = 50 WHERE code = 'SLOPER';
UPDATE grip_types SET sort_order = 60 WHERE code = 'MONO';

INSERT INTO grip_type_translations (grip_type_id, locale, field, value)
SELECT g.id, t.locale, t.field, t.value FROM grip_types g
JOIN (VALUES
    ('CRIMP',      'es', 'name', 'Arqueo'),
    ('CRIMP',      'en', 'name', 'Crimp'),
    ('CRIMP',      'es', 'description', 'Agarre cerrado con el pulgar bloqueando los dedos.'),
    ('CRIMP',      'en', 'description', 'Closed grip with the thumb locking the fingers.'),
    ('HALF_CRIMP', 'es', 'name', 'Semi-arqueo'),
    ('HALF_CRIMP', 'en', 'name', 'Half crimp'),
    ('HALF_CRIMP', 'es', 'description', 'Falanges a 90° sin acción de pulgar.'),
    ('HALF_CRIMP', 'en', 'description', '90° finger angle without thumb wrap.'),
    ('OPEN_HAND',  'es', 'name', 'Extensión'),
    ('OPEN_HAND',  'en', 'name', 'Open hand'),
    ('OPEN_HAND',  'es', 'description', 'Dedos extendidos colgando del peso.'),
    ('OPEN_HAND',  'en', 'description', 'Fingers extended, hanging off the load.'),
    ('PINCH',      'es', 'name', 'Pinza'),
    ('PINCH',      'en', 'name', 'Pinch'),
    ('PINCH',      'es', 'description', 'Agarre frontal con oposición del pulgar.'),
    ('PINCH',      'en', 'description', 'Thumb-opposed lateral grip.'),
    ('SLOPER',     'es', 'name', 'Romo'),
    ('SLOPER',     'en', 'name', 'Sloper'),
    ('SLOPER',     'es', 'description', 'Presa redondeada por fricción.'),
    ('SLOPER',     'en', 'description', 'Rounded friction-dependent hold.'),
    ('MONO',       'es', 'name', 'Mono'),
    ('MONO',       'en', 'name', 'Mono'),
    ('MONO',       'es', 'description', 'Agarre con un solo dedo en agujero.'),
    ('MONO',       'en', 'description', 'Single-finger pocket grip.')
) AS t(code, locale, field, value) ON g.code = t.code;

-- Parameter types ------------------------------------------------------------

UPDATE parameter_types SET sort_order = 10 WHERE code = 'REPS';
UPDATE parameter_types SET sort_order = 20 WHERE code = 'SETS';
UPDATE parameter_types SET sort_order = 30 WHERE code = 'REST_SECONDS';
UPDATE parameter_types SET sort_order = 40 WHERE code = 'DURATION_SECONDS';
UPDATE parameter_types SET sort_order = 50 WHERE code = 'WEIGHT_KG';
UPDATE parameter_types SET sort_order = 60 WHERE code = 'INTENSITY_PERCENT';
UPDATE parameter_types SET sort_order = 70 WHERE code = 'EDGE_DEPTH_MM';
UPDATE parameter_types SET sort_order = 80 WHERE code = 'GRIP_TYPE';
UPDATE parameter_types SET sort_order = 90 WHERE code = 'RPE';

INSERT INTO parameter_type_translations (parameter_type_id, locale, field, value)
SELECT p.id, t.locale, t.field, t.value FROM parameter_types p
JOIN (VALUES
    ('REPS',              'es', 'name', 'Repeticiones'),
    ('REPS',              'en', 'name', 'Repetitions'),
    ('SETS',              'es', 'name', 'Series'),
    ('SETS',              'en', 'name', 'Sets'),
    ('REST_SECONDS',      'es', 'name', 'Descanso (s)'),
    ('REST_SECONDS',      'en', 'name', 'Rest (s)'),
    ('DURATION_SECONDS',  'es', 'name', 'Duración (s)'),
    ('DURATION_SECONDS',  'en', 'name', 'Duration (s)'),
    ('WEIGHT_KG',         'es', 'name', 'Peso (kg)'),
    ('WEIGHT_KG',         'en', 'name', 'Weight (kg)'),
    ('INTENSITY_PERCENT', 'es', 'name', 'Intensidad (%)'),
    ('INTENSITY_PERCENT', 'en', 'name', 'Intensity (%)'),
    ('EDGE_DEPTH_MM',     'es', 'name', 'Profundidad de regleta (mm)'),
    ('EDGE_DEPTH_MM',     'en', 'name', 'Edge depth (mm)'),
    ('GRIP_TYPE',         'es', 'name', 'Tipo de agarre'),
    ('GRIP_TYPE',         'en', 'name', 'Grip type'),
    ('RPE',               'es', 'name', 'Esfuerzo percibido (RPE)'),
    ('RPE',               'en', 'name', 'Rate of Perceived Exertion (RPE)')
) AS t(code, locale, field, value) ON p.code = t.code;

-- Goal types -----------------------------------------------------------------

UPDATE goal_types SET sort_order = 10 WHERE code = 'FINGER_STRENGTH';
UPDATE goal_types SET sort_order = 20 WHERE code = 'POWER_ENDURANCE';
UPDATE goal_types SET sort_order = 30 WHERE code = 'AEROBIC_BASE';
UPDATE goal_types SET sort_order = 40 WHERE code = 'GRADE_TARGET';
UPDATE goal_types SET sort_order = 50 WHERE code = 'ANTAGONIST';
UPDATE goal_types SET sort_order = 60 WHERE code = 'GENERAL_STRENGTH';

INSERT INTO goal_type_translations (goal_type_id, locale, field, value)
SELECT gt.id, t.locale, t.field, t.value FROM goal_types gt
JOIN (VALUES
    ('FINGER_STRENGTH',  'es', 'name', 'Fuerza de dedos'),
    ('FINGER_STRENGTH',  'en', 'name', 'Finger strength'),
    ('FINGER_STRENGTH',  'es', 'description', 'Mejorar la fuerza máxima de los dedos.'),
    ('FINGER_STRENGTH',  'en', 'description', 'Improve maximum finger strength.'),
    ('POWER_ENDURANCE',  'es', 'name', 'Resistencia de fuerza'),
    ('POWER_ENDURANCE',  'en', 'name', 'Power endurance'),
    ('POWER_ENDURANCE',  'es', 'description', 'Aumentar la tolerancia al bombeo en vías largas.'),
    ('POWER_ENDURANCE',  'en', 'description', 'Improve resistance to pump on sustained efforts.'),
    ('AEROBIC_BASE',     'es', 'name', 'Base aeróbica'),
    ('AEROBIC_BASE',     'en', 'name', 'Aerobic base'),
    ('AEROBIC_BASE',     'es', 'description', 'Construir base aeróbica para la resistencia.'),
    ('AEROBIC_BASE',     'en', 'description', 'Build aerobic base for endurance.'),
    ('GRADE_TARGET',     'es', 'name', 'Objetivo de grado'),
    ('GRADE_TARGET',     'en', 'name', 'Grade target'),
    ('GRADE_TARGET',     'es', 'description', 'Encadenar un grado específico.'),
    ('GRADE_TARGET',     'en', 'description', 'Send a specific grade.'),
    ('ANTAGONIST',       'es', 'name', 'Antagonistas'),
    ('ANTAGONIST',       'en', 'name', 'Antagonist'),
    ('ANTAGONIST',       'es', 'description', 'Prevención de lesiones de hombro y muñeca.'),
    ('ANTAGONIST',       'en', 'description', 'Shoulder and wrist injury prevention.'),
    ('GENERAL_STRENGTH', 'es', 'name', 'Fuerza general'),
    ('GENERAL_STRENGTH', 'en', 'name', 'General strength'),
    ('GENERAL_STRENGTH', 'es', 'description', 'Fuerza de tracción y tensión corporal.'),
    ('GENERAL_STRENGTH', 'en', 'description', 'Pull strength and body tension.')
) AS t(code, locale, field, value) ON gt.code = t.code;

-- Equipment ------------------------------------------------------------------

UPDATE equipment SET sort_order = 10  WHERE code = 'HANGBOARD';
UPDATE equipment SET sort_order = 20  WHERE code = 'PULLUP_BAR';
UPDATE equipment SET sort_order = 30  WHERE code = 'WEIGHTED_BELT';
UPDATE equipment SET sort_order = 40  WHERE code = 'RESISTANCE_BAND';
UPDATE equipment SET sort_order = 50  WHERE code = 'CAMPUS_BOARD';
UPDATE equipment SET sort_order = 60  WHERE code = 'SLINGS';
UPDATE equipment SET sort_order = 70  WHERE code = 'MOON_BOARD';
UPDATE equipment SET sort_order = 80  WHERE code = 'KILTER_BOARD';
UPDATE equipment SET sort_order = 90  WHERE code = 'TINDEQ';
UPDATE equipment SET sort_order = 100 WHERE code = 'FOAM_ROLLER';

INSERT INTO equipment_translations (equipment_id, locale, field, value)
SELECT e.id, t.locale, t.field, t.value FROM equipment e
JOIN (VALUES
    ('HANGBOARD',       'es', 'name', 'Hangboard'),
    ('HANGBOARD',       'en', 'name', 'Hangboard'),
    ('PULLUP_BAR',      'es', 'name', 'Barra de dominadas'),
    ('PULLUP_BAR',      'en', 'name', 'Pull-up bar'),
    ('WEIGHTED_BELT',   'es', 'name', 'Cinturón lastrado'),
    ('WEIGHTED_BELT',   'en', 'name', 'Weighted belt'),
    ('RESISTANCE_BAND', 'es', 'name', 'Banda elástica'),
    ('RESISTANCE_BAND', 'en', 'name', 'Resistance band'),
    ('CAMPUS_BOARD',    'es', 'name', 'Campus board'),
    ('CAMPUS_BOARD',    'en', 'name', 'Campus board'),
    ('SLINGS',          'es', 'name', 'Anillas'),
    ('SLINGS',          'en', 'name', 'Rings'),
    ('MOON_BOARD',      'es', 'name', 'Moon Board'),
    ('MOON_BOARD',      'en', 'name', 'Moon Board'),
    ('KILTER_BOARD',    'es', 'name', 'Kilter Board'),
    ('KILTER_BOARD',    'en', 'name', 'Kilter Board'),
    ('TINDEQ',          'es', 'name', 'Tindeq'),
    ('TINDEQ',          'en', 'name', 'Tindeq'),
    ('FOAM_ROLLER',     'es', 'name', 'Foam roller'),
    ('FOAM_ROLLER',     'en', 'name', 'Foam roller')
) AS t(code, locale, field, value) ON e.code = t.code;
