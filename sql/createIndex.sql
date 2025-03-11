-- �ndice para acelerar la b�squeda por equipo local en la tabla PARTIDO
CREATE INDEX idx_partido_local 
ON PARTIDO (equipoLocal, golesLocal, golesVisitante);

-- �ndice para acelerar la b�squeda por equipo visitante en la tabla PARTIDO
CREATE INDEX idx_partido_visitante 
ON PARTIDO (equipoVisitante, golesVisitante, golesLocal);

-- �ndice para acelerar el JOIN entre JORNADA y PARTIDO
CREATE INDEX idx_jornada_temporada 
ON JORNADA (idJornada, temporada);

-- Optimizaci�n del �ndice en TEMPORADA: �ndice compuesto en idTemporada y agno
CREATE INDEX idx_temporada_agno 
ON TEMPORADA (idTemporada, agno);

CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);

CREATE INDEX idx_temporada_division ON TEMPORADA (division, agno, idTemporada);

