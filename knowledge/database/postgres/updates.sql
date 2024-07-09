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

UPDATE stations s
LEFT JOIN address a ON a.plant_id = s.note
SET
  s.country = if(a.country is null, '', a.country),
  s.state=a.state,
  s.city=a.city,
  s.district=a.town,
  s.street=a.address,
  s.longitude=if(a.lon is null, 0, a.lon),
  s.latitude=if(a.lat is null, 0, a.lat)
WHERE a.country is not null;


UPDATE sf_stations
SET operator_id =
  CASE
    WHEN id = any('{90901b6b-7efc-473b-9df9-0a8f89202666,f2bed273-de19-4b3c-ac33-cbc43c134392}') THEN
      'fb24b722-d9ca-483a-b4bb-26b7659fe054'::uuid
    ELSE NULL
  END
WHERE operator_id = 'fb24b722-d9ca-483a-b4bb-26b7659fe054'
  OR id = any('{90901b6b-7efc-473b-9df9-0a8f89202666,f2bed273-de19-4b3c-ac33-cbc43c134392}');


UPDATE sf_stations
SET visitor_ids =
  CASE
    WHEN id = any('{90901b6b-7efc-473b-9df9-0a8f89202666,f2bed273-de19-4b3c-ac33-cbc43c134392}') THEN
      ARRAY(SELECT DISTINCT UNNEST(visitor_ids || 'fb24b722-d9ca-483a-b4bb-26b7659fe054'::uuid))
    ELSE array_remove(visitor_ids, 'fb24b722-d9ca-483a-b4bb-26b7659fe054'::uuid)
  END
WHERE 'fb24b722-d9ca-483a-b4bb-26b7659fe054' = any(visitor_ids)
  OR id = any('{90901b6b-7efc-473b-9df9-0a8f89202666,f2bed273-de19-4b3c-ac33-cbc43c134392}');
