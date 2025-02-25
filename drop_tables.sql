-- Eliminar las tablas (DROP TABLE con CASCADE CONSTRAINTS para eliminar dependencias)
DROP TABLE PARTIDO CASCADE CONSTRAINTS;
DROP TABLE JORNADA CASCADE CONSTRAINTS;
DROP TABLE otrosNombres CASCADE CONSTRAINTS;
DROP TABLE contiene CASCADE CONSTRAINTS;
DROP TABLE EQUIPO CASCADE CONSTRAINTS;
DROP TABLE ESTADIO CASCADE CONSTRAINTS;
DROP TABLE pertenece CASCADE CONSTRAINTS;
DROP TABLE TEMPORADA CASCADE CONSTRAINTS;
DROP TABLE DIVISION CASCADE CONSTRAINTS;

-- Eliminar las secuencias
DROP SEQUENCE secPartidos;
DROP SEQUENCE secJornada;
DROP SEQUENCE secOtrosNombres;
DROP SEQUENCE secContiene;
DROP SEQUENCE secPertenece;

-- Eliminar los triggers
DROP TRIGGER trg_partidos_id;
DROP TRIGGER trg_jornada_id;
DROP TRIGGER trg_otrosNombres_id;
DROP TRIGGER trg_contiene_id;
DROP TRIGGER trg_pertenece_id;
