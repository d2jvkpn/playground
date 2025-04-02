SET @name = 'wowebsitedbp01';


-- SHOW TABLE STATUS;


SELECT TABLE_NAME, ENGINE, CREATE_TIME, UPDATE_TIME
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @name;


SELECT MIN(CREATE_TIME) AS estimated_db_creation_time
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = @name;


SELECT
  table_schema,
  ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'size_mb'
FROM information_schema.TABLES
WHERE table_schema = @name
GROUP BY table_schema;


SELECT
  table_name,
  ROUND(data_length / 1024 / 1024, 2) AS 'data_mb',
  ROUND(index_length / 1024 / 1024, 2) AS 'index_mb',
  table_rows
FROM information_schema.TABLES
WHERE table_schema = @name
ORDER BY (data_length + index_length) DESC;
