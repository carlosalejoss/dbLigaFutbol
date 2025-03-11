-- Eliminar índice para la búsqueda por temporada y puntos en CONTIENE
DROP INDEX idx_contiene_temporada_puntos;

-- Eliminar índice para la búsqueda por equipo en CONTIENE
DROP INDEX idx_contiene_equipo;

-- Eliminar índice compuesto para la búsqueda por equipo local y visitante en PARTIDO
DROP INDEX idx_partido_local_visitante;

-- Eliminar índice para la búsqueda por jornada en PARTIDO
DROP INDEX idx_partido_jornada;

-- Eliminar índice para el JOIN entre JORNADA y TEMPORADA
DROP INDEX idx_jornada_temporada;

-- Eliminar índice para la búsqueda por idTemporada en TEMPORADA
DROP INDEX idx_temporada_id;

-- Eliminar índice para el filtro por división en TEMPORADA
DROP INDEX idx_temporada_division;

-- Eliminar índice para la búsqueda por capacidad en ESTADIO
DROP INDEX idx_estadio_capacidad;

-- Eliminar índice para el JOIN entre EQUIPO y ESTADIO
DROP INDEX idx_equipo_estadio;

-- Eliminar índice para la búsqueda por nombre de equipo en EQUIPO
DROP INDEX idx_equipo_nombre;
