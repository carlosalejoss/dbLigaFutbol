-- Eliminar índice para la búsqueda por equipo local en PARTIDO
DROP INDEX idx_partido_local;

-- Eliminar índice para la búsqueda por equipo visitante en PARTIDO
DROP INDEX idx_partido_visitante;

-- Eliminar índice para el JOIN entre JORNADA y PARTIDO
DROP INDEX idx_jornada_temporada;

-- Eliminar índice compuesto en TEMPORADA (idTemporada, agno)
DROP INDEX idx_temporada_agno;

DROP INDEX idx_partido_jornada;

DROP INDEX idx_temporada_division;
