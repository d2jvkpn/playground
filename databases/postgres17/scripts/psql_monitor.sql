-- 01
SELECT pid, datname, usename, application_name, client_addr, state, backend_start::timestamptz(0)
FROM pg_stat_activity where datname is not null;

SELECT usename, application_name, client_addr, count(1)
FROM pg_stat_activity where datname is not null
group by usename, application_name, client_addr;

-- 02
CREATE EXTENSION pg_stat_statements;

SELECT userid, dbid, queryid, substring(query, 1, 32) || '...',
  total_exec_time::decimal(9, 3), mean_exec_time::decimal(9, 3), calls, rows
FROM pg_stat_statements
ORDER BY mean_exec_time DESC;

select count(1) from pg_stat_statements;

-- 03
select * from pg_stat_io;
