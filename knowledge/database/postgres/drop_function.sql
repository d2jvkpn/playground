-- https://stackoverflow.com/questions/34431315/postgresql-9-3-function-is-not-unique-error
SELECT oid::regprocedure
FROM pg_proc
WHERE proname = 'function_tabledetails'
