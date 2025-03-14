CREATE INDEX idx_contiene_temporada_puntos ON CONTIENE (temporada, puntos DESC);
CREATE INDEX idx_contiene_equipo ON CONTIENE (equipo);
CREATE INDEX idx_partido_local_visitante ON PARTIDO (equipoLocal, equipoVisitante);
CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);
CREATE INDEX idx_jornada_temporada ON JORNADA (temporada);
CREATE INDEX idx_temporada_division ON TEMPORADA (division);
CREATE INDEX idx_estadio_capacidad ON ESTADIO (capacidad);
CREATE INDEX idx_equipo_estadio ON EQUIPO (estadio);