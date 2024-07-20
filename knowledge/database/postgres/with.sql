WITH example AS (
  SELECT '{1, 2, 3, 4, 5}'::int[] AS array_a,
         '{2, 4}'::int[] AS array_b
)
SELECT array(
  SELECT unnest(array_a)
  EXCEPT
  SELECT unnest(array_b)
) AS result_array
FROM example;

WITH example AS (
  SELECT * FROM (
    VALUES
      (1, 'Alice', 30),
      (2, 'Bob', 25),
      (3, 'Charlie', 35)
  ) AS t (id, name, age)
)
SELECT * FROM example;


SELECT * FROM (
  VALUES
    (1, true), (2, false), (3, null)
) AS t (id, key)


WITH example AS (
  SELECT * FROM (
    VALUES
      (1, true),
      (2, false),
      (3, null)
  ) AS t (id, key)
)
SELECT * FROM example
where key;
-- 1, t

WITH example AS (
  SELECT * FROM (
    VALUES (1, true), (2, false), (3, null)
  ) AS t (id, key)
)
SELECT * FROM example
where not key;
-- 2 | f

WITH example AS (
  SELECT * FROM (
    VALUES
      (1, true), (2, false), (3, null)
  ) AS t (id, key)
)
SELECT * FROM example
where key is null;
-- 3 |

WITH example AS (
  SELECT * FROM (
    VALUES
      (1, true), (2, false), (3, null)
  ) AS t (id, key)
)
SELECT * FROM example
where key is not null;
--  1 | t
--  2 | f
