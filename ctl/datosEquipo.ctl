load data
infile './Equipo.csv'
into table EQUIPO
fields terminated by ';'
(nombreOficial, nombreCorto, nombreHistorico, ciudad, fechaFundacion, estadio)
