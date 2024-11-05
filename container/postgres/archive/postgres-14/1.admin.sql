-- docker exec -it postgres_db psql -U postgres -W

alter user postgres with password 'YourPassword';
\password

create user rover with password 'rover';
-- create role king login password 'king' valid until 'infinity' createdb;
-- create role queen login password 'queen' valid until '2023-1-1 00:00' superuser;

-- create user hello with password 'hello';
-- alter role hello with superuser;

drop database if exists hello;
create database hello;

grant all privileges on database hello to rover;

set role rover;
select current_user;
\c hello;
select current_database();

-- docker exec -it postgres_db psql -U rover hello;

set role postgres;

SELECT name, setting FROM pg_settings WHERE category = 'File Locations';
-- /var/lib/postgresql/data/pgdata/postgresql.conf
-- /var/lib/postgresql/data/pgdata/pg_hba.conf
-- /var/lib/postgresql/data/pgdata/pg_ident.conf

SELECT pg_reload_conf();

SELECT
  name, context, unit, setting, boot_val, reset_val
FROM pg_settings
WHERE name IN ('listen_addresses','deadlock_timeout','shared_buffers',
    'effective_cache_size','work_mem','maintenance_work_mem')
ORDER BY context, name;

SELECT name, sourcefile, sourceline, setting, applied
FROM pg_file_settings
WHERE name IN ('listen_addresses','deadlock_timeout','shared_buffers',
    'effective_cache_size','work_mem','maintenance_work_mem')
ORDER BY name;

ALTER SYSTEM SET work_mem = '500MB';
SELECT pg_reload_conf();


-- roles
CREATE ROLE royalty INHERIT;
GRANT royalty TO leo;
GRANT royalty TO regina;

SET SESSION AUTHORIZATION;
SELECT session_user, current_user;
