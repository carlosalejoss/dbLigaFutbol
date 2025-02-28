WITH ultima_temporada_segunda AS (
    SELECT idTemporada, agno
    FROM TEMPORADA t1
    WHERE division = '2'
    AND agno = (SELECT MAX(t2.agno) FROM TEMPORADA t2 WHERE t2.division = '2')
),
goles_por_jornada AS (
    SELECT j.idJornada, j.numero AS numero_jornada, j.temporada, 
           SUM(p.golesLocal + p.golesVisitante) AS total_goles
    FROM PARTIDO p
    JOIN JORNADA j ON p.jornada = j.idJornada
    WHERE j.temporada IN (SELECT idTemporada FROM ultima_temporada_segunda)
    GROUP BY j.idJornada, j.numero, j.temporada
),
jornada_max_goles AS (
    SELECT temporada, numero_jornada, total_goles
    FROM goles_por_jornada
    WHERE total_goles = (SELECT MAX(g.total_goles) FROM goles_por_jornada g)
)
SELECT t.agno, j.numero_jornada, j.total_goles
FROM jornada_max_goles j
JOIN TEMPORADA t ON j.temporada = t.idTemporada;