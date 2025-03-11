-- Eliminar �ndice para la b�squeda por equipo local en PARTIDO
DROP INDEX idx_partido_local;

-- Eliminar �ndice para la b�squeda por equipo visitante en PARTIDO
DROP INDEX idx_partido_visitante;

-- Eliminar �ndice para el JOIN entre JORNADA y PARTIDO
DROP INDEX idx_jornada_temporada;

-- Eliminar �ndice compuesto en TEMPORADA (idTemporada, agno)
DROP INDEX idx_temporada_agno;

DROP INDEX idx_partido_jornada;

DROP INDEX idx_temporada_division;
