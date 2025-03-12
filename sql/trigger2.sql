CREATE OR REPLACE TRIGGER trg_validar_division_equipo
BEFORE INSERT OR UPDATE ON contiene
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Contar cuántas divisiones diferentes tiene el equipo en la misma temporada (mismo año)
    SELECT COUNT(DISTINCT t.division)
    INTO v_count
    FROM contiene c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE c.equipo = :NEW.equipo
      AND t.agno = (SELECT agno FROM TEMPORADA WHERE idTemporada = :NEW.temporada)
      AND c.temporada <> :NEW.temporada;  -- Excluir la misma temporada

    -- Si el equipo ya está en otra división en el mismo año, bloquear la inserción
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Un equipo no puede estar en más de una división en la misma temporada.');
    END IF;
END;
/
