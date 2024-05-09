\x on;
\pset null '<null>';

SELECT to_timestamp('2024-05-09 16:37:05', 'YYYY-MM-DD hh24:mi:ss')::timestamptz;

SELECT to_timestamp('2024-05-09 16:37:05', 'YYYY-MM-DD hh24:mi:ss')::timestamp 
  without time zone at time zone 'Etc/UTC';
