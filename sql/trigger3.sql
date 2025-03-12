CREATE OR REPLACE TRIGGER trg_actualizar_puntos
AFTER INSERT OR UPDATE OR DELETE ON PARTIDO
FOR EACH ROW
BEGIN
    -- Actualizar los puntos de los equipos locales
    UPDATE CONTIENE c
    SET c.puntos = (
        SELECT SUM(puntos)
        FROM (
            -- Puntos como equipo local
            SELECT p.equipoLocal AS equipo, t.idTemporada AS temporada,
                CASE 
                    WHEN p.golesLocal > p.golesVisitante THEN 3  -- Victoria local
                    WHEN p.golesLocal = p.golesVisitante THEN 1  -- Empate
                    ELSE 0  -- Derrota local
                END AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.equipoLocal = c.equipo
            AND t.idTemporada = c.temporada

            UNION ALL

            -- Puntos como equipo visitante
            SELECT p.equipoVisitante AS equipo, t.idTemporada AS temporada,
                CASE 
                    WHEN p.golesVisitante > p.golesLocal THEN 3  -- Victoria visitante
                    WHEN p.golesVisitante = p.golesLocal THEN 1  -- Empate
                    ELSE 0  -- Derrota visitante
                END AS puntos
            FROM PARTIDO p
            JOIN JORNADA j ON p.jornada = j.idJornada
            JOIN TEMPORADA t ON j.temporada = t.idTemporada
            WHERE p.equipoVisitante = c.equipo
            AND t.idTemporada = c.temporada
        ) puntos_totales
    )
    WHERE c.equipo IN (:OLD.equipoLocal, :OLD.equipoVisitante)
    AND c.temporada = (SELECT temporada FROM JORNADA WHERE idJornada = :OLD.jornada);

END;
/

