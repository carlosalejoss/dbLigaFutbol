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
posiciones_exitosas AS (
    SELECT c.equipo
    FROM contiene c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE c.puntos IN (
        SELECT MAX(c2.puntos) FROM contiene c2 WHERE c2.temporada = c.temporada
        UNION
        SELECT MAX(c3.puntos) FROM contiene c3 WHERE c3.temporada = c.temporada AND c3.puntos < (SELECT MAX(c4.puntos) FROM contiene c4 WHERE c4.temporada = c3.temporada)
    )
    AND t.division = '1'
)
SELECT DISTINCT ee.nombreOficial
FROM equipos_estadios ee
JOIN posiciones_exitosas pe ON ee.nombreOficial = pe.equipo
ORDER BY ee.nombreOficial;