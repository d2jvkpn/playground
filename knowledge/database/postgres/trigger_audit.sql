--
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
    RAISE NOTICE 'test_b01.status has changed from % to %', OLD.status, NEW.status;
    insert into test_b01_log (name, old_status, new_status)
      VALUES (OLD.name, OLD.status, NEW.status);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_status_trigger
  AFTER UPDATE OF status ON test_b01
  FOR EACH ROW
  EXECUTE FUNCTION test_b01_update_status_func();

insert into test_b01 (name, status) values ('Jane', 'ok');
update test_b01 set status = 'disabled' where name = 'Jane';

--
CREATE TABLE test_b02 (
  name   varchar,
  status varchar NOT NULL,
  value  int NOT NULL DEFAULT 0,

  primary key(name)
);

CREATE OR REPLACE FUNCTION test_b02_update_status_func()
RETURNS TRIGGER AS $$
BEGIN
  RAISE NOTICE '==> update test_b02 %, %->%, %-%',
    OLD.name, OLD.status, NEW.status, OLD.value, NEW.value;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- drop function test_b02_update_status_func;

CREATE TRIGGER update_status_trigger
  AFTER INSERT OR UPDATE OF status, value ON test_b02
  FOR EACH ROW
  EXECUTE FUNCTION test_b02_update_status_func();

-- drop trigger update_status_trigger on test_b02;

insert into test_b02 (name, status, value) values ('x0001', 'ok', 12);

update test_b02 set status = 'yes' where name = 'x0001';
update test_b02 set value = 42 where name = 'x0001';
