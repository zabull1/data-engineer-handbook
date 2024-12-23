DROP TABLE actors_history_scd

CREATE TABLE actors_history_scd(
                                   ACTOR TEXT,
                                   QUALITY_CLASS QUALITY_CLASS,
                                   IS_ACTIVE BOOLEAN,
                                   START_YEAR INTEGER,
                                   END_YEAR INTEGER,
                                   CURRENT_YEAR INTEGER,
                                   PRIMARY KEY (ACTOR, END_YEAR, CURRENT_YEAR)

)

SELECT actor,
       quality_class,
       is_active
FROM public.actors
where current_year =1973


    INSERT INTO actors_history_scd
WITH PREVIOUS AS (
    SELECT actor,
    quality_class,
    is_active,
    current_year,
    LAG(QUALITY_CLASS, 1) OVER(PARTITION BY ACTOR ORDER BY CURRENT_YEAR) as PREVIOUS_QUALITY_CLASS,
    LAG(IS_ACTIVE, 1) OVER(PARTITION BY ACTOR ORDER BY CURRENT_YEAR) as PREVIOUS_IS_ACTIVE
    FROM ACTORS
    WHERE CURRENT_YEAR <= 2021
    )
        , INDICATORS AS (
    SELECT *,
-- 		CASE WHEN QUALITY_CLASS <> PREVIOUS_QUALITY_CLASS THEN 1 ELSE 0 END AS QUALITY_CLASS_CHANGE_INDICATOR,
-- 		CASE WHEN IS_ACTIVE <> PREVIOUS_IS_ACTIVE THEN 1 ELSE 0 END AS IS_ACTIVE_CHANGE_INDICATOR
    CASE WHEN QUALITY_CLASS <> PREVIOUS_QUALITY_CLASS THEN 1
    WHEN IS_ACTIVE <> PREVIOUS_IS_ACTIVE THEN 1
    ELSE 0
    END AS CHANGE_INDICATOR
    FROM PREVIOUS
    ),
    STREAK AS (
    SELECT *,
    SUM(CHANGE_INDICATOR) OVER(PARTITION BY ACTOR ORDER BY CURRENT_YEAR) AS STREAK_IDENTIFIER
    FROM INDICATORS
    )
SELECT ACTOR,
       QUALITY_CLASS,
       IS_ACTIVE,
       MIN(CURRENT_YEAR) AS START_YEAR,
       MAX(CURRENT_YEAR) AS END_YEAR,
       2021 AS CURRENT_YEAR
FROM STREAK
GROUP BY ACTOR, STREAK_IDENTIFIER, IS_ACTIVE, QUALITY_CLASS
ORDER BY ACTOR, STREAK_IDENTIFIER

SELECT * FROM actors_history_scd



WHERE
    ACTOR = 'Alain Delon'
  and current_year =1973