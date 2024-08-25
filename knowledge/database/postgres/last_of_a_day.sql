WITH RankedRecords AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY date_trunc('day', date) ORDER BY date DESC) AS rn
  FROM your_table
)
SELECT *
FROM RankedRecords
WHERE rn = 1;
