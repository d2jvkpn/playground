CREATE TABLE test_b01 (
  name   varchar,
  status varchar NOT NULL,

  primary key(name)
);

create table test_b01_log (
  id         uuid default gen_random_uuid(),
  name       varchar NULL,
  old_status varchar,
  new_status varchar,
  created_at timestamptz DEFAULT now(),

  primary key(id)
);

CREATE OR REPLACE FUNCTION test_b01_update_status_func()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status <> OLD.status THEN
    RAISE NOTICE 'Status field in t1 has changed from % to %', OLD.status, NEW.status;
    insert into test_b01_log (name, old_status, new_status)
      VALUES (OLD.name, OLD.status, NEW.status);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER test_b01_update_status_trigger
  AFTER UPDATE OF status ON test_b01
  FOR EACH ROW
  EXECUTE FUNCTION test_b01_update_status_func();

insert into test_b01 (name, status) values ('Jane', 'ok');
update test_b01 set status = 'disabled' where name = 'Jane';
