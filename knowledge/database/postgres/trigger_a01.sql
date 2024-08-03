create table test_trigger_a01 (
  id uuid default gen_random_uuid(),
  created_at timestamptz default now(),

  status text not null default 'ok',

  primary key(id)
);


CREATE OR REPLACE FUNCTION test_trigger_a01_update_status()
RETURNS TRIGGER AS $$
BEGIN
  RAISE NOTICE 'test_triggre_a01.status has changed from "%" to "%"', OLD.status, NEW.status;
  IF OLD.status IS DISTINCT FROM NEW.status AND 'yes' IN (OLD.status, NEW.status) THEN
     RAISE NOTICE '==> IF';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_status
  AFTER INSERT OR DELETE OR UPDATE OF status ON test_trigger_a01
  FOR EACH ROW
  EXECUTE FUNCTION test_trigger_a01_update_status();

-- drop trigger update_status on test_trigger_a01;

insert into test_trigger_a01 (status) values
  ('ok'), ('no'), ('yes');
/*
NOTICE:  test_triggre_a01.status has changed from "<NULL>" to "ok"
NOTICE:  test_triggre_a01.status has changed from "<NULL>" to "no"
NOTICE:  test_triggre_a01.status has changed from "<NULL>" to "yes"
NOTICE:  ==> IF
*/

update test_trigger_a01 set status = 'ok' where status = 'no';
-- NOTICE:  test_triggre_a01.status has changed from "no" to "ok"

delete from test_trigger_a01 where status = 'yes';
-- NOTICE:  test_triggre_a01.status has changed from "yes" to "<NULL>"
-- NOTICE:  ==> IF
