ALTER ROLE dev CREATEDB;

SELECT rolname, rolcreatedb FROM pg_roles WHERE rolname = 'dev';

ALTER ROLE dev NOCREATEDB;
