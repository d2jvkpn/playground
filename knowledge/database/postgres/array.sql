-- concat
select array_cat('{1,2,4}'::int[], '{1,4}'::int[]);

-- push
select ARRAY(SELECT DISTINCT UNNEST('{1,2,4}'::int[] || '{1,3,4}'::int[]));

-- contains
select 1 = ANY('{1,2,4}'::int[]);
select 3 = ANY('{1,2,4}'::int[]);

-- includes
select '{1,2,4}'::int[] @> '{1,2,4}'::int[];
select '{1,2,4}'::int[] @> '{1,4}'::int[];
select '{1,2,4}'::int[] @> '{1,3}'::int[];

-- array filter
WITH unnest_table1 AS (
    SELECT id, unnest(visitor_ids) AS value
    FROM sf_stations
),
invalid_values AS (
    SELECT id, value
    FROM unnest_table1
    WHERE value NOT IN (SELECT id FROM user_accounts)
)
SELECT
    t.id, t.visitor_ids,
    array(
        SELECT value
        FROM invalid_values
        WHERE id = t.id
    ) AS invalid_elements
FROM sf_stations t
WHERE EXISTS (
    SELECT 1
    FROM invalid_values iv
    WHERE iv.id = t.id
);

WITH unnest_table1 AS (
    SELECT id, unnest(visitor_ids) AS value
    FROM sf_stations
),
invalid_elements AS (
    SELECT DISTINCT value
    FROM unnest_table1
    WHERE value NOT IN (SELECT id FROM user_accounts)
    GROUP BY value
)
SELECT  value
FROM invalid_elements
ORDER BY value;

SELECT t1.id, unnest(t1.visitor_ids) vid from sf_stations t1
left join user_accounts t2 on t1.vid = t2.id;

UPDATE sf_stations
SET visitor_ids = (
  SELECT array(
    SELECT unnest(visitor_ids)
    INTERSECT
    SELECT id FROM user_accounts
  )
);
