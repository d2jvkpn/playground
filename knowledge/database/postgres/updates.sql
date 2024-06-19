UPDATE t_01
SET status2 = CASE
  WHEN status = 0 THEN 'ok'
  WHEN status = 1 THEN 'no'
  ELSE 'unknown'
END;

UPDATE t_02 AS t SET
  column_a = t_01.column_a
FROM (VALUES
  ('123', 1),
  ('345', 2)  
) AS t_01(column_b, column_a) 
WHERE t_01.column_b = t.column_b;
