WITH estadios_pequenos AS (
    -- Equipos que juegan en estadios con capacidad menor a 50,000
    SELECT nombreEstadio
    FROM ESTADIO
    WHERE capacidad < 50000
),
equipos_estadios AS (
    -- Equipos que juegan en estadios pequeños
    SELECT e.nombreOficial
    FROM EQUIPO e
    JOIN estadios_pequenos ep ON e.estadio = ep.nombreEstadio
),
primeros_puestos AS (
    -- Equipos que quedaron en primer lugar (incluyendo empates)
    SELECT c.equipo, c.temporada
    FROM CONTIENE c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE t.division = '1'
    AND c.puntos = (
        SELECT MAX(c2.puntos) 
        FROM CONTIENE c2
        WHERE c2.temporada = c.temporada
    )
),
equipos_empatados_segundo AS (
    -- Equipos que estan empatados en el segundo puesto (sin calcular aun los goles)
    SELECT c.equipo, c.temporada
    FROM CONTIENE c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE t.division = '1'
    AND c.puntos = (
        -- Segundo maximo puntaje en la temporada, excluyendo el primero
        SELECT MAX(c3.puntos)
        FROM CONTIENE c3
        WHERE c3.temporada = c.temporada
        AND c3.puntos < (
            SELECT MAX(c4.puntos) 
            FROM CONTIENE c4
            WHERE c4.temporada = c3.temporada
        )
    )
    -- Solo incluir segundos puestos si hay exactamente 1 equipo en primer lugar en esa temporada
    AND (SELECT COUNT(*) FROM primeros_puestos pp WHERE pp.temporada = c.temporada) = 1
),
goles_locales AS (
    -- Calcular goles SOLO de los equipos que estan en el segundo puesto empatados en la temporada en cuestion
    SELECT c.equipo, c.temporada, SUM(p.golesLocal) AS golesFavor
    FROM CONTIENE c
    JOIN PARTIDO p ON c.equipo = p.equipoLocal
    JOIN JORNADA j ON p.jornada = j.idJornada
    JOIN TEMPORADA t ON j.temporada = t.idTemporada
    JOIN equipos_empatados_segundo ees ON c.equipo = ees.equipo AND c.temporada = ees.temporada
    GROUP BY c.equipo, c.temporada
),
goles_visitantes AS (
    SELECT c.equipo, c.temporada, SUM(p.golesVisitante) AS golesFavor
    FROM CONTIENE c
    JOIN PARTIDO p ON c.equipo = p.equipoVisitante
    JOIN JORNADA j ON p.jornada = j.idJornada
    JOIN TEMPORADA t ON j.temporada = t.idTemporada
    JOIN equipos_empatados_segundo ees ON c.equipo = ees.equipo AND c.temporada = ees.temporada
    GROUP BY c.equipo, c.temporada
),
goles_empatados AS (
    SELECT gl.equipo, gl.temporada, (gl.golesFavor + gv.golesFavor) AS golesFavor
    FROM goles_locales gl
    JOIN goles_visitantes gv ON gl.equipo = gv.equipo AND gl.temporada = gv.temporada
),
segundos_puestos AS (
    -- Seleccionar el equipo con la mejor diferencia de goles en caso de empate en el segundo puesto
    SELECT ees.equipo
    FROM equipos_empatados_segundo ees
    JOIN goles_empatados g ON ees.equipo = g.equipo AND ees.temporada = g.temporada
    WHERE g.golesFavor = (
        -- Seleccionamos el equipo con la mejor diferencia de goles
        SELECT MAX(g2.golesFavor)
        FROM goles_empatados g2
        WHERE g2.temporada = ees.temporada
    )
)
SELECT DISTINCT ee.nombreOficial
FROM equipos_estadios ee
JOIN (
    SELECT equipo FROM primeros_puestos
    UNION ALL
    SELECT equipo FROM segundos_puestos
) pe ON ee.nombreOficial = pe.equipo
ORDER BY ee.nombreOficial;