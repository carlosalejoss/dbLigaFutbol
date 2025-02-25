CREATE TABLE DIVISION (
    denominacionOficial  VARCHAR(20) PRIMARY KEY,
    nombreComercial      VARCHAR(20)
);


-- Tabla para las temporadas
CREATE TABLE TEMPORADA (
    agno NUMBER(5) PRIMARY KEY
);


-- Tabla para la relación entre divisiones y temporadas.
CREATE TABLE pertenece (
    idPertenece NUMBER(20) PRIMARY KEY,
    division    VARCHAR(20) NULL, -- NULL para las divisiones que no pertenecen a ninguna temporada (relacion 0-N)
    temporada   NUMBER(5)   NULL, -- NULL para las temporadas que no pertenecen a ninguna división (relacion 0-N)
    FOREIGN KEY (division)  REFERENCES DIVISION(denominacionOficial),
    FOREIGN KEY (temporada) REFERENCES TEMPORADA(agno)
);

-- Secuencia para la tabla pertenece
CREATE SEQUENCE secPertenece
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idPertenece de la tabla pertenece
CREATE OR REPLACE TRIGGER trg_pertenece_id
BEFORE INSERT ON pertenece
FOR EACH ROW
BEGIN
    :NEW.idPertenece := secPertenece.NEXTVAL;
END;
/


-- Tabla para los estadios
CREATE TABLE ESTADIO (
    nombreEstadio    VARCHAR(60) PRIMARY KEY,
    fechaInauguracion NUMBER(5),
    capacidad         NUMBER(8)
);


-- Tabla para los equipos
CREATE TABLE EQUIPO (
    nombreOficial   VARCHAR(60) PRIMARY KEY,
    nombreCorto     VARCHAR(60) NOT NULL UNIQUE,
    nombreHistorico VARCHAR(70),
    ciudad          VARCHAR(60) NOT NULL,
    fechaFundacion  NUMBER(5),
    estadio         VARCHAR(60) NOT NULL,
    FOREIGN KEY (estadio) REFERENCES ESTADIO(nombreEstadio)
);


-- Tabla para la relación entre equipos y temporadas
CREATE TABLE contiene (
    idContiene NUMBER(20) PRIMARY KEY,
    temporada  NUMBER(4) NOT NULL,
    equipo     VARCHAR(60) NOT NULL,
    puntos     NUMBER(3) NULL,
    FOREIGN KEY (temporada) REFERENCES TEMPORADA(agno),
    FOREIGN KEY (equipo)    REFERENCES EQUIPO(nombreCorto),
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
    otrosNombres   VARCHAR(50),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreCorto)
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
    idjornada NUMBER(20) PRIMARY KEY,
    numero    NUMBER(3) NOT NULL,
    temporada NUMBER(5) NOT NULL,
    FOREIGN KEY (temporada) REFERENCES TEMPORADA(agno)
);

-- Secuencia para la tabla JORNADA
CREATE SEQUENCE secJornada
    START WITH 1
    INCREMENT BY 1;

-- Trigger para la secuencia en la clave artificial idjornada de la tabla JORNADA
CREATE OR REPLACE TRIGGER trg_jornada_id
BEFORE INSERT ON JORNADA
FOR EACH ROW
BEGIN
    :NEW.idjornada := secJornada.NEXTVAL;
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
    FOREIGN KEY (equipoLocal)    REFERENCES EQUIPO(nombreCorto),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPO(nombreCorto),
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
