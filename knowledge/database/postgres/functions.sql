SELECT pg_get_functiondef('public.calculate_sales_tax'::regproc);


CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;


DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'add_numbers'
  ) THEN
    CREATE FUNCTION add_numbers(a integer, b integer) RETURNS integer
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT
    RETURN a + b;
  END IF;
END $$;


CREATE OR REPLACE FUNCTION jsonb_merge(jsonb1 JSONB, jsonb2 JSONB) RETURNS JSONB AS $$
BEGIN
    RETURN jsonb1 || jsonb2;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add(a integer, b integer) RETURNS integer
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT
  RETURN a + b;

CREATE OR REPLACE FUNCTION my_transition_devices_rs(type TEXT, rs device_status)
RETURNS TEXT AS $$
BEGIN
  IF type IS NULL OR rs IS NULL THEN
    RETURN NULL;
  END IF;

  IF type = 'invertor' AND rs != 'online' AND rs != 'standby' THEN
    RETURN 'malfunction';
  ELSIF type = 'invertor' AND rs = 'standby' THEN
    RETURN 'standby';
  ELSE
    RETURN rs;
  END IF;
END;
$$ LANGUAGE plpgsql;

update sf_devices set status = 'offline'
where type = 'invertor' and status = 'online'
order by random() limit 5;

WITH cte AS (
  SELECT id
  FROM sf_devices
  WHERE type = 'invertor' and running_status = 'online'
  ORDER BY random()
  LIMIT 2
)
UPDATE sf_devices
SET running_status = 'offline'
WHERE id IN (SELECT id FROM cte);

WITH cte AS (
  SELECT id
  FROM sf_devices
  WHERE type = 'invertor' and running_status = 'online'
  ORDER BY random()
  LIMIT 2
)
UPDATE sf_devices
SET running_status = 'standby'
WHERE id IN (SELECT id FROM cte);


select type, running_status, my_transform_devices_rs(type, running_status) from sf_devices;

select my_transform_devices_rs(type, running_status) rs, count(1)
from sf_devices group by rs;

select json_object_agg(rs, number) from
(
  select my_transform_devices_rs(type, running_status) rs, count(1) number
  from sf_devices group by rs
) t1;
