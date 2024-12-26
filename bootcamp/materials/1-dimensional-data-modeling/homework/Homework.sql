DROP TABLE ACTORS
DROP TYPE FILMS
DELETE FROM ACTORS WHERE 1=1

CREATE TYPE FILMS AS (
    FILM TEXT,
    VOTES INTEGER,
    RATING REAL,
    FILMID TEXT,
    YEAR INTEGER
    )

CREATE TYPE QUALITY_CLASS AS ENUM('STAR', 'GOOD', 'AVERAGE', 'BAD')


CREATE TABLE ACTORS (
                        ACTOR TEXT,
                        ACTORID TEXT,
                        FILMS FILMS[],
                        QUALITY_CLASS QUALITY_CLASS,
                        YEARS_SINCE_LAST_FILM INTEGER,
                        IS_ACTIVE BOOLEAN,
                        CURRENT_YEAR INTEGER,
                        PRIMARY KEY (ACTOR , CURRENT_YEAR)

)

SELECT * FROM ACTORS WHERE YEARS_SINCE_LAST_FILM >1
    ACTOR = 'Agnes Moorehead'

WITH YESTERDAY AS (
    SELECT *
    FROM ACTORS
    WHERE CURRENT_YEAR = 1972
    ),
    TODAY AS (
    SELECT
    ACTOR,
    ACTORID,
    ROUND((AVG(RATING))::NUMERIC,2) AS AVG_RATING,
    ARRAY_AGG(ROW(FILM, VOTES, RATING, FILMID, YEAR)::FILMS) AS FILMS,
    YEAR
    FROM ACTOR_FILMS
    WHERE YEAR = 1973
    GROUP BY ACTOR, ACTORID, YEAR
    )
INSERT INTO ACTORS

SELECT
    COALESCE(T.ACTOR, Y.ACTOR) AS ACTOR,
    COALESCE(T.ACTORID, Y.ACTORID) AS ACTORID,
    CASE
        WHEN Y.FILMS IS NULL THEN T.FILMS
        WHEN T.FILMS IS NOT NULL THEN Y.FILMS || T.FILMS
        ELSE Y.FILMS
        END AS FILMS,
    CASE WHEN T.AVG_RATING > 8 THEN 'STAR'
         WHEN  T.AVG_RATING > 7 THEN 'GOOD'
         WHEN T.AVG_RATING > 6 THEN 'AVERAGE'
         ELSE 'BAD'
        END :: QUALITY_CLASS AS QUALITY_CLASS,
        CASE WHEN T.YEAR IS NOT NULL THEN 0
             ELSE YEARS_SINCE_LAST_FILM + 1 END AS YEARS_SINCE_LAST_FILM,
    CASE WHEN YEARS_SINCE_LAST_FILM > 0 THEN FALSE
         ELSE TRUE END AS IS_ACTIVE,
    COALESCE(T.YEAR, Y.CURRENT_YEAR + 1)  AS CURRENT_YEAR

FROM TODAY T
         FULL OUTER JOIN YESTERDAY Y
                         ON T.ACTOR = Y.ACTOR;



WITH UNNESTED AS (
    SELECT ACTOR, UNNEST(FILMS) AS FILMS FROM ACTORS
    WHERE
        ACTOR = 'Agnes Moorehead'
      AND
        CURRENT_YEAR = 1972
)
SELECT ACTOR, (FILMS::FILMS).* FROM UNNESTED


SELECT ACTOR,FILMS, FILMS[1].FILM, FILMS[CARDINALITY(FILMS)] AS F, FILMS[ARRAY_LENGTH(FILMS,1)] FROM ACTORS
                                                                                                         LIMIT 10

SELECT ACTOR, ACTORID, QUALITY_CLASS,
       LAG(QUALITY_CLASS,1) OVER(PARTITION BY ACTOR ORDER BY ACTOR) AS LAG, IS_ACTIVE, CURRENT_YEAR FROM ACTORS

