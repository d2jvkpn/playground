----
SELECT station_id,
  json_build_object(
    'malfunction', sum(CASE WHEN type = 'invertor' AND
      (running_status = 'offline' OR running_status = 'shutdown') THEN 1 ELSE 0 END),
    'offline', sum(CASE WHEN type != 'invertor' AND running_status = 'offline' THEN 1 ELSE 0 END),
    'standby', sum(CASE WHEN running_status = 'standby' THEN 1 ELSE 0 END),
    'online', sum(CASE WHEN running_status = 'online' THEN 1 ELSE 0 END)
  ) running_status
FROM sf_devices
WHERE status = true
GROUP BY station_id;

----
UPDATE stats s
SET running_status = r.running_status
FROM (

	SELECT station_id,
	  json_build_object(
	    'malfunction', sum(CASE WHEN type = 'invertor' AND
	      (running_status = 'offline' OR running_status = 'shutdown') THEN 1 ELSE 0 END),
	    'offline', sum(CASE WHEN type != 'invertor' AND running_status = 'offline' THEN 1 ELSE 0 END),
	    'standby', sum(CASE WHEN running_status = 'standby' THEN 1 ELSE 0 END),
	    'online', sum(CASE WHEN running_status = 'online' THEN 1 ELSE 0 END)
	  ) running_status
	FROM sf_devices
	WHERE status = true
	GROUP BY station_id

) AS r
WHERE s.status = true AND s.id = r.station_id;

----
CREATE OR REPLACE FUNCTION sf_stations_update_alarm_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.handle <> OLD.handle THEN
  -- RAISE NOTICE 't_alam.hanlde has changed from % to %', OLD.hanlde, NEW.hanlde;
    UPDATE sf_stations s
    SET alarm_status = r.alarm_status
    FROM (
      SELECT station_id,
        json_build_object(
          'unhandled', sum(CASE WHEN handle = 0 THEN 1 ELSE 0 END),
          'handled', sum(CASE WHEN handle = 1 THEN 1 ELSE 0 END),
          'recovered', sum(CASE WHEN handle = 2 THEN 1 ELSE 0 END),
          'blocked', sum(CASE WHEN handle = 3 THEN 1 ELSE 0 END),
          'ignored', sum(CASE WHEN handle = 4 THEN 1 ELSE 0 END)
        ) alarm_status
      FROM t_alarm
      WHERE station_id = OLD.station_id
      GROUP BY station_id
    ) AS r
    WHERE s.status = true AND s.id = r.station_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- drop function sf_stations_update_alarm_status;

----
CREATE TRIGGER update_handle
  AFTER INSERT OR UPDATE OF handle ON t_alarm
  FOR EACH ROW
  EXECUTE FUNCTION sf_stations_update_alarm_status();
-- drop trigger update_handle on t_alarm;
