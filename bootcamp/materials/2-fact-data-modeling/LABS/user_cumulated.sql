CREATE TABLE USERS_CUMULATED (

                                 USER_ID NUMERIC,
                                 DATES_ACTIVE DATE[],
                                 DATE DATE,
                                 PRIMARY KEY (USER_ID, DATE)

)

INSERT INTO USERS_CUMULATED
WITH YESTERDAY AS (

    SELECT * FROM USERS_CUMULATED
    WHERE DATE = DATE('2023-01-30')

    ), TODAY AS (
SELECT USER_ID,
    DATE(EVENT_TIME) AS DATE_ACTIVE
FROM EVENTS
WHERE DATE(EVENT_TIME) = DATE('2023-01-31')
  AND USER_ID IS NOT NULL
GROUP BY 1,2
    )

SELECT
    COALESCE(T.USER_ID, Y.USER_ID) AS USER_ID,
    CASE WHEN Y.DATES_ACTIVE IS NULL
             THEN ARRAY[T.DATE_ACTIVE]
         WHEN T.DATE_ACTIVE IS NULL THEN Y.DATES_ACTIVE
         ELSE ARRAY[T.DATE_ACTIVE] || Y.DATES_ACTIVE
        END
                                   AS DATES_ACTIVE,
    DATE(COALESCE(T.DATE_ACTIVE, Y.DATE + INTERVAL '1 DAY'))
FROM TODAY T
    FULL OUTER JOIN YESTERDAY Y
ON T.USER_ID = Y.USER_ID