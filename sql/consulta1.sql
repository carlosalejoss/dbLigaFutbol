WITH victorias AS (
    SELECT j.temporada, p.equipoLocal AS zaragoza, p.equipoVisitante AS rival
    FROM PARTIDO p
    JOIN JORNADA j ON p.jornada = j.idJornada
    WHERE p.equipoLocal = 'Real Zaragoza' AND p.golesLocal > p.golesVisitante
    UNION ALL
    SELECT j.temporada, p.equipoVisitante AS zaragoza, p.equipoLocal AS rival
    FROM PARTIDO p
    JOIN JORNADA j ON p.jornada = j.idJornada
    WHERE p.equipoVisitante = 'Real Zaragoza' AND p.golesVisitante > p.golesLocal
),
conteo_victorias AS (
    SELECT v.temporada, v.rival, COUNT(*) AS num_victorias
    FROM victorias v
    GROUP BY v.temporada, v.rival
    HAVING COUNT(*) = 2
),
temporadas_validas AS (
    SELECT c.temporada
    FROM conteo_victorias c
    GROUP BY c.temporada
    HAVING COUNT(*) >= 4
),
goles_locales AS (
    SELECT t.division, t.agno, SUM(p.golesLocal) AS goles_zaragoza
    FROM TEMPORADA t
    JOIN JORNADA j ON t.idTemporada = j.temporada
    JOIN PARTIDO p ON j.idJornada = p.jornada
    WHERE p.equipoLocal = 'Real Zaragoza'
      AND t.idTemporada IN (SELECT temporada FROM temporadas_validas)
    GROUP BY t.division, t.agno
),
goles_visitantes AS (
    SELECT t.division, t.agno, SUM(p.golesVisitante) AS goles_zaragoza
    FROM TEMPORADA t
    JOIN JORNADA j ON t.idTemporada = j.temporada
    JOIN PARTIDO p ON j.idJornada = p.jornada
    WHERE p.equipoVisitante = 'Real Zaragoza'
      AND t.idTemporada IN (SELECT temporada FROM temporadas_validas)
    GROUP BY t.division, t.agno
)
SELECT gl.division, gl.agno, (gl.goles_zaragoza + gv.goles_zaragoza) AS goles_zaragoza
FROM goles_locales gl
JOIN goles_visitantes gv ON gl.division = gv.division AND gl.agno = gv.agno
ORDER BY gl.agno;