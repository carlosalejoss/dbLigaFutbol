CREATE TABLE DIVISION (
    denominacionOficial  VARCHAR(20) PRIMARY KEY,
    nombreComercial      VARCHAR(20)
);


-- Tabla para las temporadas
CREATE TABLE TEMPORADA (
    idTemporada NUMBER(20) PRIMARY KEY,
    agno        NUMBER(5),
    division    VARCHAR(20) NULL,
    FOREIGN KEY (division) REFERENCES DIVISION(denominacionOficial)
);

-- Secuencia para la tabla TEMPORADA
CREATE SEQUENCE secTemporada
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idTemporada de la tabla TEMPORADA
CREATE OR REPLACE TRIGGER trg_temporada_id
BEFORE INSERT ON TEMPORADA
FOR EACH ROW
BEGIN
    :NEW.idTemporada := secTemporada.NEXTVAL;
END;
/


-- Tabla para los estadios
CREATE TABLE ESTADIO (
    nombreEstadio     VARCHAR(60) PRIMARY KEY,
    fechaInauguracion NUMBER(5),
    capacidad         NUMBER(9)
);


-- Tabla para los equipos
CREATE TABLE EQUIPO (
    nombreOficial   VARCHAR(60) PRIMARY KEY,
    nombreCorto     VARCHAR(60),
    nombreHistorico VARCHAR(70),
    ciudad          VARCHAR(60),
    fechaFundacion  NUMBER(5),
    estadio         VARCHAR(60) NOT NULL,
    FOREIGN KEY (estadio) REFERENCES ESTADIO(nombreEstadio)
);


-- Tabla para la relación entre equipos y temporadas
CREATE TABLE contiene (
    idContiene NUMBER(20) PRIMARY KEY,
    temporada  NUMBER(20) NOT NULL,
    equipo     VARCHAR(60) NOT NULL,
    puntos     NUMBER(4) NULL,
    FOREIGN KEY (temporada) REFERENCES TEMPORADA(idTemporada),
    FOREIGN KEY (equipo)    REFERENCES EQUIPO(nombreOficial),
    CONSTRAINT unq_equipo_temporada UNIQUE (equipo, temporada)
);

-- Secuencia para la tabla contiene
CREATE SEQUENCE secContiene
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idContiene de la tabla contiene
CREATE OR REPLACE TRIGGER trg_contiene_id
BEFORE INSERT ON contiene
FOR EACH ROW
BEGIN
    :NEW.idContiene := secContiene.NEXTVAL;
END;
/


-- Tabla para los otros nombres de los equipos
CREATE TABLE otrosNombres (
    idOtrosNombres NUMBER(20) PRIMARY KEY,
    equipo         VARCHAR(60) NOT NULL,
    otrosNombres   VARCHAR(60),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial)
);

-- Secuencia para la tabla otrosNombres
CREATE SEQUENCE secOtrosNombres
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idOtrosNombres de la tabla otrosNombres
CREATE OR REPLACE TRIGGER trg_otrosNombres_id
BEFORE INSERT ON otrosNombres
FOR EACH ROW
BEGIN
    :NEW.idOtrosNombres := secOtrosNombres.NEXTVAL;
END;
/


-- Tabla para las jornadas
CREATE TABLE JORNADA (
    idJornada NUMBER(20) PRIMARY KEY,
    numero    NUMBER(4) NOT NULL,
    temporada NUMBER(20) NOT NULL,
    FOREIGN KEY (temporada) REFERENCES TEMPORADA(idTemporada)
);

-- Secuencia para la tabla JORNADA
CREATE SEQUENCE secJornada
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idJornada de la tabla JORNADA
CREATE OR REPLACE TRIGGER trg_jornada_id
BEFORE INSERT ON JORNADA
FOR EACH ROW
BEGIN
    :NEW.idJornada := secJornada.NEXTVAL;
END;
/


-- Tabla para los partidos
CREATE TABLE PARTIDO (
    idPartido       NUMBER(20) PRIMARY KEY,
    jornada         NUMBER(20) NOT NULL,
    equipoLocal     VARCHAR(60) NOT NULL,
    equipoVisitante VARCHAR(60) NOT NULL,
    golesLocal      NUMBER(3),
    golesVisitante  NUMBER(3),
    FOREIGN KEY (jornada)        REFERENCES JORNADA(idjornada),
    FOREIGN KEY (equipoLocal)    REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPO(nombreOficial),
    CONSTRAINT chk_teams_not_equal CHECK (equipoLocal <> equipoVisitante), -- No se puede jugar un partido contra uno mismo
    CONSTRAINT chk_goles_no_negativos CHECK (golesLocal >= 0 AND golesVisitante >= 0)
);

-- Secuencia para la tabla PARTIDOS
CREATE SEQUENCE secPartidos
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idPartido de la tabla PARTIDOS
CREATE OR REPLACE TRIGGER trg_partidos_id
BEFORE INSERT ON PARTIDO
FOR EACH ROW
BEGIN
    :NEW.idPartido := secPartidos.NEXTVAL;
END;
/
