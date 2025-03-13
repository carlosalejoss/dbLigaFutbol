CREATE OR REPLACE TRIGGER trg_validar_fundacion_equipo
BEFORE INSERT OR UPDATE ON PARTIDO
FOR EACH ROW
DECLARE
    v_fundacion_local NUMBER;
    v_fundacion_visitante NUMBER;
    v_anio_temporada NUMBER;
BEGIN
    -- Obtener el año de fundación del equipo local
    SELECT fechaFundacion INTO v_fundacion_local
    FROM EQUIPO
    WHERE nombreOficial = :NEW.equipoLocal;

    -- Obtener el año de fundación del equipo visitante
    SELECT fechaFundacion INTO v_fundacion_visitante
    FROM EQUIPO
    WHERE nombreOficial = :NEW.equipoVisitante;

    -- Obtener el año de la temporada del partido
    SELECT agno INTO v_anio_temporada
    FROM TEMPORADA t
    JOIN JORNADA j ON t.idTemporada = j.temporada
    WHERE j.idJornada = :NEW.jornada;

    -- Si el equipo local tiene fecha de fundación, verificar que no sea posterior a la temporada
    IF v_fundacion_local IS NOT NULL AND v_fundacion_local > v_anio_temporada THEN
        RAISE_APPLICATION_ERROR(-20060, 'Error: El equipo local no puede jugar en una temporada anterior a su fundación.');
    END IF;

    -- Si el equipo visitante tiene fecha de fundación, verificar que no sea posterior a la temporada
    IF v_fundacion_visitante IS NOT NULL AND v_fundacion_visitante > v_anio_temporada THEN
        RAISE_APPLICATION_ERROR(-20061, 'Error: El equipo visitante no puede jugar en una temporada anterior a su fundación.');
    END IF;
END;
/
