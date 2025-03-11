-- �ndice compuesto para mejorar la b�squeda por temporada y puntos
CREATE INDEX idx_contiene_temporada_puntos ON CONTIENE (temporada, puntos DESC);

-- �ndice para acelerar los joins por equipo
CREATE INDEX idx_contiene_equipo ON CONTIENE (equipo);

-- �ndice compuesto para mejorar b�squedas por local y visitante
CREATE INDEX idx_partido_local_visitante ON PARTIDO (equipoLocal, equipoVisitante);

-- �ndice para acelerar los joins por jornada
CREATE INDEX idx_partido_jornada ON PARTIDO (jornada);

CREATE INDEX idx_jornada_temporada ON JORNADA (temporada);

-- �ndice para filtrar r�pidamente temporadas de la primera divisi�n
CREATE INDEX idx_temporada_division ON TEMPORADA (division);

CREATE INDEX idx_estadio_capacidad ON ESTADIO (capacidad);

-- �ndice para acelerar la b�squeda por estadio
CREATE INDEX idx_equipo_estadio ON EQUIPO (estadio);

