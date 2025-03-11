-- Índice compuesto para mejorar la búsqueda por temporada y puntos
CREATE INDEX idx_contiene_temporada_puntos ON CONTIENE (temporada, puntos DESC);

-- Índice para acelerar los joins por equipo
CREATE INDEX idx_contiene_equipo ON CONTIENE (equipo);

-- Índice compuesto para mejorar búsquedas por local y visitante
CREATE INDEX idx_partido_local_visitante ON PARTIDO (equipoLocal, equipoVisitante);

-- Índice para acelerar los joins por jornada
CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);

CREATE INDEX idx_jornada_temporada ON JORNADA (temporada);

-- Índice para filtrar rápidamente temporadas de la primera división
CREATE INDEX idx_temporada_division ON TEMPORADA (division);

CREATE INDEX idx_estadio_capacidad ON ESTADIO (capacidad);

-- Índice para acelerar la búsqueda por estadio
CREATE INDEX idx_equipo_estadio ON EQUIPO (estadio);

