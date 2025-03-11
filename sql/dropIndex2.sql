-- Eliminar �ndice para la b�squeda por temporada y puntos en CONTIENE
DROP INDEX idx_contiene_temporada_puntos;

-- Eliminar �ndice para la b�squeda por equipo en CONTIENE
DROP INDEX idx_contiene_equipo;

-- Eliminar �ndice compuesto para la b�squeda por equipo local y visitante en PARTIDO
DROP INDEX idx_partido_local_visitante;

-- Eliminar �ndice para la b�squeda por jornada en PARTIDO
DROP INDEX idx_partido_jornada;

-- Eliminar �ndice para el JOIN entre JORNADA y TEMPORADA
DROP INDEX idx_jornada_temporada;

-- Eliminar �ndice para la b�squeda por idTemporada en TEMPORADA
DROP INDEX idx_temporada_id;

-- Eliminar �ndice para el filtro por divisi�n en TEMPORADA
DROP INDEX idx_temporada_division;

-- Eliminar �ndice para la b�squeda por capacidad en ESTADIO
DROP INDEX idx_estadio_capacidad;

-- Eliminar �ndice para el JOIN entre EQUIPO y ESTADIO
DROP INDEX idx_equipo_estadio;

-- Eliminar �ndice para la b�squeda por nombre de equipo en EQUIPO
DROP INDEX idx_equipo_nombre;
