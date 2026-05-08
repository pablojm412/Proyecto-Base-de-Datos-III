-- PARTE 1: DDL Y CARGA MASIVA
DROP TABLE IF EXISTS turnos_veterinarios, historias_clinicas, animales, voluntarios CASCADE;

CREATE TABLE voluntarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    dni_token TEXT,
    supervisor_id INT REFERENCES voluntarios(id)
);

CREATE TABLE animales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especie_id INT,
    fecha_ingreso DATE
);

CREATE TABLE historias_clinicas (
    id SERIAL PRIMARY KEY,
    animal_id INT REFERENCES animales(id),
    datos_medicos JSONB
);

CREATE TABLE turnos_veterinarios (
    id SERIAL PRIMARY KEY,
    animal_id INT REFERENCES animales(id),
    periodo_atencion TSRANGE
);

-- CARGA DE DATOS (Ajustado para cumplir con el millón de registros totales)
INSERT INTO voluntarios (nombre, dni_token, supervisor_id)
SELECT 'Voluntario_' || i, md5(i::text), CASE WHEN i <= 10 THEN NULL ELSE (floor(random() * 10) + 1)::int END
FROM generate_series(1, 10000);

INSERT INTO animales (nombre, especie_id, fecha_ingreso)
SELECT 'Animal_' || i, (random() * 5 + 1)::int, now()::date - (random() * interval '5 years')
FROM generate_series(1, 500000);

INSERT INTO historias_clinicas (animal_id, datos_medicos)
SELECT (random() * 499999 + 1)::int,
    jsonb_build_object(
        'diagnostico', (ARRAY['Moquillo', 'Parvovirus', 'Sarna', 'Sano', 'Fractura'])[floor(random() * 5 + 1)],
        'gravedad', (ARRAY['Baja', 'Media', 'Alta'])[floor(random() * 3 + 1)]
    )
FROM generate_series(1, 500000);

-- PARTE 2: OPTIMIZACIÓN (Índices)
CREATE INDEX idx_animales_fecha ON animales(fecha_ingreso);
CREATE INDEX idx_voluntarios_dni_hash ON voluntarios USING HASH (dni_token);
CREATE INDEX idx_clinicas_datos_gin ON historias_clinicas USING GIN (datos_medicos);
CREATE INDEX idx_turnos_periodo_gist ON turnos_veterinarios USING GIST (periodo_atencion);

-- PARTE 3: SQL AVANZADO (Lógica de Negocio)
-- Window Function: Ranking
SELECT v2.nombre AS supervisor, COUNT(v1.id) AS voluntarios,
       RANK() OVER (ORDER BY COUNT(v1.id) DESC) as puesto
FROM voluntarios v1 JOIN voluntarios v2 ON v1.supervisor_id = v2.id
GROUP BY v2.nombre;

-- CTE Recursivo: Organigrama
WITH RECURSIVE organigrama AS (
    SELECT id, nombre, supervisor_id, 1 as nivel FROM voluntarios WHERE supervisor_id IS NULL
    UNION ALL
    SELECT v.id, v.nombre, v.supervisor_id, o.nivel + 1
    FROM voluntarios v INNER JOIN organigrama o ON v.supervisor_id = o.id
)
SELECT * FROM organigrama ORDER BY nivel;
