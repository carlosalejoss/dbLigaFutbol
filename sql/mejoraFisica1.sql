CREATE INDEX idx_partido_equipo_goles ON PARTIDO(equipoLocal, equipoVisitante, golesLocal, golesVisitante, jornada);
CREATE INDEX idx_partido_jornada ON PARTIDO(jornada);
CREATE INDEX idx_jornada_temporada ON JORNADA(temporada);
CREATE INDEX idx_temporada_division_agno ON TEMPORADA(division, agno);