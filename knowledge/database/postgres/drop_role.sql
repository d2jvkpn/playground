--
create role test_a01 with login;
create database test_a01 with owner test_a01;
-- \password test_a01

create role test_b01 with login in group test_a01;
-- \password test_b01


--
create table test_c01 (
  id uuid default gen_random_uuid(),
  name text,

  primary key(id)
);

insert into test_c01 (name) values ('a01'), ('a02');

--
drop database test_a01;

DROP OWNED BY test_a01;
DROP ROLE test_a01;


SELECT 
    pg_terminate_backend(pid) 
FROM 
    pg_stat_activity 
WHERE 
    -- don't kill my own connection!
    pid <> pg_backend_pid()
    -- don't kill the connections to other databases
    AND datname = 'joyn_pccp'
    ;
