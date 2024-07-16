create type ok_locking as enum('ok');

create table test_o2m_locking (
  id uuid default gen_random_uuid(),

  target_id varchar NOT NULL ,
  status ok_locking default 'ok',
  data serial not null,

  primary key(id),
  unique (target_id, status)
);

insert into test_o2m_locking (target_id) values
  ('A'),
  ('B'),
  ('C');

select * from test_o2m_locking;

insert into test_o2m_locking (target_id, status) values ('A', 'ok');
-- ERROR: uplicate key value violates unique constraint "test_o2m_locking_target_id_status_key"

update test_o2m_locking set status = null WHERE  target_id = 'A' AND status = 'ok';
insert into test_o2m_locking (target_id, status) values ('A', 'ok');

select * from test_o2m_locking;

-- can't do update and insert in begin commit;
update test_o2m_locking set status = null WHERE  target_id = 'A' AND status = 'ok';
insert into test_o2m_locking (target_id, status) values ('A', 'ok');



-- this do update the old record with insert a new record
insert into test_o2m_locking (target_id, status) values ('A', 'ok')
on conflict (target_id, status) do update set status = null;
