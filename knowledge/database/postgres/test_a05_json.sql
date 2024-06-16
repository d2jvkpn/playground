select
  station_id,
  sum(case when running_status = 0 then 1 else 0 end) offline,
  sum(case when running_status = 1 then 1 else 0 end) online
  from sf_devices
  where status = true
  group by station_id;

select json_build_object(
  'a', 'hello',
  'b', 'world'
);

select
  station_id id,
  json_build_object(
    'offline', sum(case when running_status = 0 then 1 else 0 end),
    'online', sum(case when running_status = 1 then 1 else 0 end)
  ) running_status
  from sf_devices
  where status = true
  group by station_id;

UPDATE sf_stations s
SET running_status = r.running_status
FROM (
  select
    station_id,
    json_build_object(
      'offline', sum(case when running_status = 0 then 1 else 0 end),
      'online', sum(case when running_status = 1 then 1 else 0 end)
    ) running_status
    from sf_devices
    where status = true
    group by station_id
) AS r
WHERE s.id = r.station_id;

select id, running_status from sf_stations where (running_status->>'online')::int > 0;
