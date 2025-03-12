CREATE OR REPLACE TRIGGER trg_equipo_unico_partido_jornada
BEFORE INSERT ON PARTIDO
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Contar cuántos partidos tiene el equipo en la jornada
    SELECT COUNT(*)
    INTO v_count
    FROM PARTIDO
    WHERE jornada = :NEW.jornada
      AND (:NEW.equipoLocal IN (equipoLocal, equipoVisitante) 
           OR :NEW.equipoVisitante IN (equipoLocal, equipoVisitante));

    -- Si el equipo ya tiene un partido en la jornada, bloquear la inserción
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Un equipo no puede jugar más de un partido en la misma jornada.');
    END IF;
END;
/