CREATE OR REPLACE TRIGGER trg_evitar_primera_segunda
BEFORE INSERT OR UPDATE ON contiene
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Contar cuántas veces el equipo ha jugado en Primera o Segunda en el mismo año
    SELECT COUNT(DISTINCT t.division)
    INTO v_count
    FROM contiene c
    JOIN TEMPORADA t ON c.temporada = t.idTemporada
    WHERE c.equipo = :NEW.equipo
      AND t.agno = (SELECT agno FROM TEMPORADA WHERE idTemporada = :NEW.temporada)
      AND t.division IN ('1', '2')  -- Solo nos interesa Primera y Segunda
      AND c.temporada <> :NEW.temporada;  -- Excluir la misma temporada

    -- Si el equipo ya ha jugado en Primera o Segunda en el mismo año, impedir la inserción
    IF v_count > 0 AND (SELECT division FROM TEMPORADA WHERE idTemporada = :NEW.temporada) IN ('1', '2') THEN
        RAISE_APPLICATION_ERROR(-20010, 'Un equipo no puede jugar en Primera y Segunda en la misma temporada.');
    END IF;
END;
/
