CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
-- SELECT query, total_exec_time, calls, mean_exec_time FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;
-- SELECT query, calls, mean_exec_time FROM pg_stat_statements ORDER BY calls DESC LIMIT 10;
-- SELECT query, calls, mean_exec_time FROM pg_stat_statements ORDER BY calls DESC LIMIT 10;
