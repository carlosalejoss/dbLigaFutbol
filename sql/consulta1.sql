WITH
    -- 1) Partidos ganados por el Zaragoza como LOCAL
    local_wins AS (
        SELECT j.temporada AS temporada,
               p.equipoVisitante AS rival
        FROM PARTIDO p
             JOIN JORNADA j ON p.jornada = j.idjornada
        WHERE p.equipoLocal = 'Zaragoza'
          AND p.golesLocal > p.golesVisitante
    ),
    -- 2) Partidos ganados por el Zaragoza como VISITANTE
    away_wins AS (
        SELECT j.temporada AS temporada,
               p.equipoLocal AS rival
        FROM PARTIDO p
             JOIN JORNADA j ON p.jornada = j.idjornada
        WHERE p.equipoVisitante = 'Zaragoza'
          AND p.golesVisitante > p.golesLocal
    ),
    -- 3) Todos los partidos ganados (sumando local + visitante)
    all_wins AS (
        SELECT temporada, rival FROM local_wins
        UNION ALL
        SELECT temporada, rival FROM away_wins
    ),
    -- 4) Equipos a los que el Zaragoza ganó 2 veces (ida y vuelta) en una temporada
    both_matches_wins AS (
        SELECT temporada,
               rival,
               COUNT(*) AS times_won
        FROM all_wins
        GROUP BY temporada, rival
        HAVING COUNT(*) = 2
    ),
    -- 5) Temporadas en las que el Zaragoza ganó (ida y vuelta) a al menos 4 equipos distintos
    qualified_seasons AS (
        SELECT temporada
        FROM both_matches_wins
        GROUP BY temporada
        HAVING COUNT(*) >= 4
    )
SELECT 
    ( SELECT MAX(per.division)
      FROM pertenece per
           JOIN contiene c
             ON c.temporada = per.temporada
           JOIN EQUIPO e
             ON e.nombreCorto = c.equipo
      WHERE per.temporada = t.agno
        AND e.nombreCorto = 'Zaragoza'
    ) AS division,
    t.agno AS temporada,
    /* Subconsulta que calcula el total de goles del Zaragoza:
       SUM(golesLocal) en partidos donde es local 
       + SUM(golesVisitante) en partidos donde es visitante.
       Nota: si un SUM no encuentra filas, devuelve NULL. */
    (
      (
        SELECT SUM(p2.golesLocal)
        FROM PARTIDO p2
             JOIN JORNADA j2 ON p2.jornada = j2.idjornada
        WHERE p2.equipoLocal = 'Zaragoza'
          AND j2.temporada = t.agno
      )
      +
      (
        SELECT SUM(p3.golesVisitante)
        FROM PARTIDO p3
             JOIN JORNADA j3 ON p3.jornada = j3.idjornada
        WHERE p3.equipoVisitante = 'Zaragoza'
          AND j3.temporada = t.agno
      )
    ) AS goles_zaragoza
FROM TEMPORADA t
    JOIN qualified_seasons qs ON t.agno = qs.temporada
ORDER BY t.agno;