load data
infile './Partido.csv'
into table PARTIDO
fields terminated by ';'
(jornada, equipoLocal, equipoVisitante, golesLocal, golesVisitante)
