CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);
CREATE INDEX idx_jornada_temporada ON JORNADA (idJornada, temporada);
CREATE INDEX idx_temporada_division ON TEMPORADA (division, agno, idTemporada);