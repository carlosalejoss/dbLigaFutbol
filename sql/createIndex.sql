-- Índice para acelerar la búsqueda por equipo local en la tabla PARTIDO
CREATE INDEX idx_partido_local 
ON PARTIDO (equipoLocal, golesLocal, golesVisitante);

-- Índice para acelerar la búsqueda por equipo visitante en la tabla PARTIDO
CREATE INDEX idx_partido_visitante 
ON PARTIDO (equipoVisitante, golesVisitante, golesLocal);

-- Índice para acelerar el JOIN entre JORNADA y PARTIDO
CREATE INDEX idx_jornada_temporada 
ON JORNADA (idJornada, temporada);

-- Optimización del índice en TEMPORADA: índice compuesto en idTemporada y agno
CREATE INDEX idx_temporada_agno 
ON TEMPORADA (idTemporada, agno);

CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);

CREATE INDEX idx_temporada_division ON TEMPORADA (division, agno, idTemporada);

