-- Eliminar las tablas (DROP TABLE con PURGE para eliminar dependencias)
DROP TABLE PARTIDO PURGE;
DROP TABLE JORNADA PURGE;
DROP TABLE otrosNombres PURGE;
DROP TABLE contiene PURGE;
DROP TABLE EQUIPO PURGE;
DROP TABLE ESTADIO PURGE;
DROP TABLE TEMPORADA PURGE;
DROP TABLE DIVISION PURGE;

-- Eliminar las secuencias
DROP SEQUENCE secPartidos;
DROP SEQUENCE secJornada;
DROP SEQUENCE secOtrosNombres;
DROP SEQUENCE secContiene;
DROP SEQUENCE secTemporada;

-- Eliminar los triggers
DROP TRIGGER trg_partidos_id;
DROP TRIGGER trg_jornada_id;
DROP TRIGGER trg_otrosNombres_id;
DROP TRIGGER trg_contiene_id;
DROP TRIGGER trg_temporada_id;
