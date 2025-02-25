load data
infile './Estadio.csv'
into table ESTADIO
fields terminated by ';'
(nombreEstadio, fechaInauguracion, capacidad)
