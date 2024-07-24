create type ok as enum('ok');

create table test_o2m (
  id uuid default gen_random_uuid(),

  target_id  varchar NOT NULL ,
  status     ok default 'ok',
  data       serial not null,

  primary key(id),
  unique (target_id, status)
);

insert into test_o2m (target_id) values
  ('A'),
  ('B'),
  ('C');

select * from test_o2m;

insert into test_o2m (target_id, status) values ('A', 'ok');
-- ERROR: uplicate key value violates unique constraint "test_o2m_target_id_status_key"

update test_o2m set status = null WHERE target_id = 'A' AND status = 'ok';
insert into test_o2m (target_id, status) values ('A', 'ok');

select * from test_o2m;

-- can't do update and insert in begin commit;
update test_o2m set status = null WHERE  target_id = 'A' AND status = 'ok';
insert into test_o2m (target_id, status) values ('A', 'ok');

-- this do update the old record with insert a new record
insert into test_o2m (target_id, status) values ('A', 'ok')
on conflict (target_id, status) do update set status = null;

WITH t1 AS (
    SELECT data
    FROM test_o2m
    WHERE target_id = 'A' AND status is NULL
    ORDER BY data desc
    LIMIT 1
)
UPDATE test_o2m
SET status = 'ok'
WHERE data IN (SELECT data FROM t1);

begin;
-- SELECT target_id, status FROM test_o2m WHERE target_id = 'A' and status is not null FOR UPDATE;
update test_o2m set status = null WHERE  target_id = 'A' AND status = 'ok';
insert into test_o2m (target_id, status) values ('A', 'ok');
commit;
-- rollback;

