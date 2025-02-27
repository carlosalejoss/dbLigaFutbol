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
    SELECT c.equipo, t.agno, c.puntos
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
    -- Equipos que están empatados en el segundo puesto (sin calcular aún los goles)
    SELECT c.equipo, t.agno, c.puntos, c.temporada
    FROM CONTIENE c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE t.division = '1'
    AND c.puntos = (
        -- Segundo máximo puntaje en la temporada, excluyendo el primero
        SELECT MAX(c3.puntos)
        FROM CONTIENE c3
        WHERE c3.temporada = c.temporada
        AND c3.puntos < (
            SELECT MAX(c4.puntos) 
            FROM CONTIENE c4
            WHERE c4.temporada = c3.temporada
        )
    )
    -- Solo incluir segundos puestos si hay exactamente 1 equipo en primer lugar
    AND (SELECT COUNT(*) FROM primeros_puestos pp WHERE pp.agno = t.agno) = 1
),
goles_empatados AS (
    -- Calcular goles SOLO de los equipos que están en el segundo puesto empatados en la temporada en cuestión
    SELECT c.equipo, c.temporada,
           SUM(CASE WHEN p.equipoLocal = c.equipo THEN p.golesLocal ELSE p.golesVisitante END) AS golesFavor,
           SUM(CASE WHEN p.equipoLocal = c.equipo THEN p.golesVisitante ELSE p.golesLocal END) AS golesContra
    FROM CONTIENE c
    JOIN PARTIDO p ON c.equipo = p.equipoLocal OR c.equipo = p.equipoVisitante
    JOIN JORNADA j ON p.jornada = j.idJornada
    JOIN TEMPORADA t ON j.temporada = t.idTemporada
    JOIN equipos_empatados_segundo ees ON c.equipo = ees.equipo AND c.temporada = ees.temporada
    GROUP BY c.equipo, c.temporada
),
segundos_puestos AS (
    -- Seleccionar el equipo con la mejor diferencia de goles en caso de empate en el segundo puesto
    SELECT ees.equipo, ees.agno
    FROM equipos_empatados_segundo ees
    JOIN goles_empatados g ON ees.equipo = g.equipo AND ees.temporada = g.temporada
    WHERE (g.golesFavor - g.golesContra) = (
        -- Seleccionamos el equipo con la mejor diferencia de goles
        SELECT MAX(g2.golesFavor - g2.golesContra)
        FROM goles_empatados g2
        WHERE g2.temporada = ees.temporada
    )
)
SELECT DISTINCT ee.nombreOficial, pe.agno AS temporada
FROM equipos_estadios ee
JOIN (
    SELECT equipo, agno FROM primeros_puestos
    UNION ALL
    SELECT equipo, agno FROM segundos_puestos
) pe ON ee.nombreOficial = pe.equipo
ORDER BY pe.agno;
