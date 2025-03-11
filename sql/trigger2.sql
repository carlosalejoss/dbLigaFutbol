CREATE OR REPLACE TRIGGER trg_recalcular_puntos
AFTER INSERT OR UPDATE OR DELETE ON PARTIDO
FOR EACH ROW
DECLARE
    v_puntos_local NUMBER := 0;
    v_puntos_visitante NUMBER := 0;
    v_total_puntos_local NUMBER;
    v_total_puntos_visitante NUMBER;
BEGIN
    -- Determinar los puntos obtenidos por cada equipo en este partido
    IF :NEW.golesLocal > :NEW.golesVisitante THEN
        v_puntos_local := 3;
        v_puntos_visitante := 0;
    ELSIF :NEW.golesLocal < :NEW.golesVisitante THEN
        v_puntos_local := 0;
        v_puntos_visitante := 3;
    ELSE
        v_puntos_local := 1;
        v_puntos_visitante := 1;
    END IF;

    -- Calcular el total de puntos del equipo local en la temporada
    SELECT SUM(
        CASE
            WHEN p.golesLocal > p.golesVisitante THEN 3
            WHEN p.golesLocal < p.golesVisitante THEN 0
            ELSE 1
        END
    )
    INTO v_total_puntos_local
    FROM PARTIDO p
    WHERE p.jornada IN (
        SELECT j.idJornada FROM JORNADA j WHERE j.temporada = :NEW.jornada
    ) AND p.equipoLocal = :NEW.equipoLocal;

    -- Manejo de NULL para evitar errores en la actualización
    IF v_total_puntos_local IS NULL THEN
        v_total_puntos_local := 0;
    END IF;

    -- Actualizar los puntos del equipo local en la tabla contiene
    UPDATE contiene
    SET puntos = v_total_puntos_local
    WHERE equipo = :NEW.equipoLocal AND temporada = :NEW.jornada;

    -- Calcular el total de puntos del equipo visitante en la temporada
    SELECT SUM(
        CASE
            WHEN p.golesVisitante > p.golesLocal THEN 3
            WHEN p.golesVisitante < p.golesLocal THEN 0
            ELSE 1
        END
    )
    INTO v_total_puntos_visitante
    FROM PARTIDO p
    WHERE p.jornada IN (
        SELECT j.idJornada FROM JORNADA j WHERE j.temporada = :NEW.jornada
    ) AND p.equipoVisitante = :NEW.equipoVisitante;

    -- Manejo de NULL para evitar errores en la actualización
    IF v_total_puntos_visitante IS NULL THEN
        v_total_puntos_visitante := 0;
    END IF;

    -- Actualizar los puntos del equipo visitante en la tabla contiene
    UPDATE contiene
    SET puntos = v_total_puntos_visitante
    WHERE equipo = :NEW.equipoVisitante AND temporada = :NEW.jornada;
END;
/
