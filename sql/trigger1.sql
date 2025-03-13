CREATE OR REPLACE TRIGGER trg_actualizar_puntos
AFTER INSERT OR UPDATE OR DELETE ON PARTIDO
BEGIN
    UPDATE CONTIENE c
    SET c.puntos = (
        SELECT SUM(puntos)
        FROM (
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 3 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal > p.golesVisitante
            UNION ALL
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 1 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal = p.golesVisitante
            UNION ALL
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada, 1 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesVisitante = p.golesLocal
            UNION ALL
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada, 3 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesVisitante > p.golesLocal
            UNION ALL
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada, 0 AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.golesLocal < p.golesVisitante
            UNION ALL
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
        SELECT 1 FROM PARTIDO p
        JOIN JORNADA j ON p.jornada = j.idJornada
        JOIN TEMPORADA t ON j.temporada = t.idTemporada
        WHERE (p.equipoLocal = c.equipo OR p.equipoVisitante = c.equipo)
        AND t.idTemporada = c.temporada
    );
    UPDATE CONTIENE
    SET puntos = 0
    WHERE puntos IS NULL;
END;
/
