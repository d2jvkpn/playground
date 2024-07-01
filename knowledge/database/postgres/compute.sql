SELECT COALESCE((col->>'desired_field')::int, 0) FROM t1;

SELECT 100/NULLIF(col, 0);

SELECT COALESCE(100/NULLIF(col, 0), -1.00);

CREATE INDEX idx_name ON t1 (column_name) WHERE column_name IS NOT NULL;

SELECT (col->>'not_exist')::int FROM t1; -- null

select station_id, date,
  ROUND(t1.x_value/t2.installed_capacity_kw, 6) equivalent_hours
  from sfpg_stations t1
  left join sf_stations t2 on t1.station_id = t2.id
  where t1.date = '2024-07-01' AND t1.x_value > 0 and t2.installed_capacity_kw > 0;


select station_id, date,
  ROUND(t1.x_value/t2.installed_capacity_kw, 6) hours
  from sfpg_stations t1
  left join sf_stations t2 on t1.station_id = t2.id
  where t1.date = '2024-07-01' AND t1.x_value > 0 and t2.installed_capacity_kw > 0;


alter table sfpg_stations add column data json NOT NULL default '{}';

CREATE INDEX sfpg_stations_equivalent_hours
  ON sfpg_stations (
    ((data->>'equivalentHours')::numeric)
) WHERE data->>'equivalentHours' IS NOT NULL;

UPDATE sfpg_stations t1
SET data = jsonb_set(data::jsonb, '{equivalentHours}', t2.hours::text::jsonb, true)
FROM (
  SELECT station_id, date,
  ROUND(s1.x_value/s2.installed_capacity_kw, 6) hours
  FROM sfpg_stations s1
  LEFT JOIN sf_stations s2 ON s2.id = s1.station_id
  WHERE s1.date = '2024-07-01' AND s1.x_value > 0 AND s2.installed_capacity_kw > 0
  ORDER BY hours DESC LIMIT 10
) t2
WHERE t1.station_id = t2.station_id AND s1.date = '2024-07-01';


-- UPDATE sfpg_stations SET data = jsonb_set(data::jsonb, '{equivalentHours}', 'null'::jsonb);
-- UPDATE sfpg_stations SET data = data::jsonb -'{equivalentHours}';

UPDATE sfpg_stations SET data = data::jsonb #- '{equivalentHours}';

UPDATE sfpg_stations t1
SET data = jsonb_set(data::jsonb, '{equivalentHours}', t2.hours::text::jsonb, true)
FROM (
  SELECT station_id, date,
  ROUND(s2.x_value/s1.installed_capacity_kw, 6) hours
  FROM sf_stations s1
  LEFT JOIN sfpg_stations s2 ON s1.id = s2.station_id
  WHERE s2.date = '2024-05-29' AND s1.installed_capacity_kw > 0 AND s1.status
  ORDER BY hours DESC, station_id LIMIT 5
) t2
WHERE t1.station_id = t2.station_id AND t1.date = t2.date
RETURNING t1.station_id;

UPDATE sfpg_stations t1
SET data = jsonb_set(data::jsonb, '{equivalentHours}', t2.hours::text::jsonb, true)
FROM (
  SELECT station_id, date,
  ROUND(s2.x_value/s1.installed_capacity_kw, 6) hours
  FROM sf_stations s1
  LEFT JOIN sfpg_stations s2 ON s1.id = s2.station_id
  WHERE s2.date = '2024-05-29' AND s1.installed_capacity_kw > 0 AND s1.status
  ORDER BY hours ASC, station_id LIMIT 5
) t2
WHERE t1.station_id = t2.station_id AND t1.date = t2.date
RETURNING t1.station_id;
