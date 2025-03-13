CREATE OR REPLACE TRIGGER trg_actualizar_puntos
AFTER INSERT OR UPDATE OR DELETE ON PARTIDO
BEGIN
    -- Actualizar los puntos de los equipos afectados
    UPDATE CONTIENE c
    SET c.puntos = (
        SELECT SUM(puntos)
        FROM (
            -- Puntos obtenidos como equipo local
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 3 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal > p.golesVisitante

            UNION ALL

            -- Empates como equipo local
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 1 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal = p.golesVisitante

            UNION ALL

            -- Empates como equipo visitante
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada, 1 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesVisitante = p.golesLocal

            UNION ALL

            -- Puntos obtenidos como equipo visitante
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada, 3 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesVisitante > p.golesLocal

            UNION ALL

            -- Derrotas como equipo local
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 0 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal < p.golesVisitante

            UNION ALL

            -- Derrotas como equipo visitante
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada, 0 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesVisitante < p.golesLocal
        ) puntos_totales
        WHERE puntos_totales.equipo = c.equipo
        AND puntos_totales.temporada = c.temporada
    )
    WHERE EXISTS (
        -- Verificar que el equipo ha jugado al menos un partido en la temporada
        SELECT 1 FROM PARTIDO p
        JOIN JORNADA j ON p.jornada = j.idJornada
        JOIN TEMPORADA t ON j.temporada = t.idTemporada
        WHERE (p.equipoLocal = c.equipo OR p.equipoVisitante = c.equipo)
        AND t.idTemporada = c.temporada
    );

    -- Manejo de valores NULL: Si un equipo no tiene partidos, aseguramos que tenga puntos = 0
    UPDATE CONTIENE
    SET puntos = 0
    WHERE puntos IS NULL;
END;
/
