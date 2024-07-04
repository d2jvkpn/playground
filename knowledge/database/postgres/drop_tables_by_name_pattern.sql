CREATE OR REPLACE FUNCTION drop_tables_by_name_pattern(pattern TEXT) RETURNS VOID AS $$
DECLARE
  name TEXT;
  sql_stmt TEXT;
BEGIN
  -- 遍历匹配模式的表名
  FOR name IN
    SELECT table_name name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      AND table_name LIKE pattern
  LOOP
    sql_stmt := 'DROP TABLE IF EXISTS ' || quote_ident(name) || ' CASCADE;'; 

    EXECUTE sql_stmt;

    RAISE NOTICE '==> Table % dropped', name;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- select drop_tables_by_name_pattern('prefix_%');
