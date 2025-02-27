UPDATE CONTIENE c
SET c.puntos = (
    SELECT SUM(puntos)
    FROM (
        SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada,
            CASE 
                WHEN p.golesLocal > p.golesVisitante THEN 3  -- Victoria local
                WHEN p.golesLocal = p.golesVisitante THEN 1  -- Empate
                ELSE 0  -- Derrota local
            END AS puntos
        FROM PARTIDO p
        JOIN JORNADA j ON p.jornada = j.idJornada
        JOIN TEMPORADA t ON j.temporada = t.idTemporada
        UNION ALL
        SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada,
            CASE 
                WHEN p.golesVisitante > p.golesLocal THEN 3  -- Victoria visitante
                WHEN p.golesVisitante = p.golesLocal THEN 1  -- Empate
                ELSE 0  -- Derrota visitante
            END AS puntos
        FROM PARTIDO p
        JOIN JORNADA j ON p.jornada = j.idJornada
        JOIN TEMPORADA t ON j.temporada = t.idTemporada
    ) puntos_totales
    WHERE puntos_totales.equipo = c.equipo
    AND puntos_totales.temporada = c.temporada
)
WHERE EXISTS (
    SELECT 1
    FROM PARTIDO p
    JOIN JORNADA j ON p.jornada = j.idJornada
    JOIN TEMPORADA t ON j.temporada = t.idTemporada
    WHERE (p.equipoLocal = c.equipo OR p.equipoVisitante = c.equipo)
    AND t.idTemporada = c.temporada
);