WITH estadios_pequenos AS (
    SELECT nombreEstadio
    FROM ESTADIO
    WHERE capacidad < 50000
),
equipos_estadios AS (
    SELECT e.nombreOficial
    FROM EQUIPO e
    JOIN estadios_pequenos ep ON e.estadio = ep.nombreEstadio
),
puntajes AS (
    SELECT c.temporada, c.equipo, c.puntos,
           (SELECT MAX(c2.puntos) 
            FROM contiene c2 
            WHERE c2.temporada = c.temporada) AS max_puntos,
           (SELECT COUNT(*) 
            FROM contiene c3 
            WHERE c3.temporada = c.temporada 
              AND c3.puntos = (SELECT MAX(c4.puntos) 
                               FROM contiene c4 
                               WHERE c4.temporada = c3.temporada)) AS num_lideres
    FROM contiene c
),
posiciones_exitosas AS (
    SELECT p.temporada, p.equipo
    FROM puntajes p
    WHERE p.puntos = p.max_puntos
       OR (p.num_lideres = 1 
           AND p.puntos = (SELECT MAX(p2.puntos) 
                           FROM puntajes p2 
                           WHERE p2.temporada = p.temporada AND p2.puntos < p.max_puntos))
),
equipos_finales AS (
    SELECT DISTINCT pe.equipo
    FROM posiciones_exitosas pe
    JOIN TEMPORADA t ON pe.temporada = t.idTemporada
    WHERE t.division = '1'
)
SELECT ee.nombreOficial
FROM equipos_estadios ee
JOIN equipos_finales ef ON ee.nombreOficial = ef.equipo
ORDER BY ee.nombreOficial;