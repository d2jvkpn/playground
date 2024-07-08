-- 01
SET running_status = r.running_status
FROM (
  SELECT station_id,
    json_build_object(
      'online', sum(CASE WHEN running_status = 'online' THEN 1 ELSE 0 END),
      'standby', sum(CASE WHEN running_status = 'standby' THEN 1 ELSE 0 END),
      'offline', sum(CASE WHEN type != 'invertor' AND
        running_status = 'offline' THEN 1 ELSE 0 END),
      'malfunction', sum(CASE WHEN type = 'invertor' AND
        (running_status != 'online' OR running_status != 'standby') THEN 1 ELSE 0 END),
      'total', sum(1)
    ) running_status
  FROM ` + TABLE_SF_Devices + `
  WHERE status
  GROUP BY station_id
) AS r
WHERE s.status = true AND s.id = r.station_id;

-- 02
select type, jsonb_object_agg(running_status, number) running_status
from
(
  select type, running_status, count(1) number
  from sf_devices group by type, running_status
) t1
group by type;

-- 03
select jsonb_agg(running_status)
from
(
  select jsonb_build_object(
    concat(type, '::', running_status),
    count(1)
  ) running_status
  from sf_devices group by type, running_status
) t1;

-- 04
select json_build_object(type, jsonb_agg(running_status))
from
(
  select type, jsonb_build_object(
    running_status,
    count(1)
  ) running_status
  from sf_devices group by type, running_status
) t1
group by type;
