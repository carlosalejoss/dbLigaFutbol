CREATE OR REPLACE TRIGGER no_nombreoficial_trigger
BEFORE INSERT ON EQUIPO
FOR EACH ROW
BEGIN
    -- Si nombreOficial es NULL pero nombreCorto tiene un valor, asignamos nombreCorto a nombreOficial
    IF :NEW.nombreOficial IS NULL AND :NEW.nombreCorto IS NOT NULL THEN
        :NEW.nombreOficial := SUBSTR(:NEW.nombreCorto, 1, 60);
    END IF;
END;
/
