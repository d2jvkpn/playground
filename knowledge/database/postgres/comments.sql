DO $$
DECLARE
  column_record RECORD;
BEGIN
  -- Create a temporary table to hold the table and column names along with their comments
  CREATE TEMP TABLE temp_comments (
    column_name TEXT,
    column_comment TEXT
  );

  -- Insert your table and column names along with their comments
  INSERT INTO temp_comments (column_name, column_comment) VALUES
    ('category', '分类'),
    ('code', '代码'),
    ('created_at', '创建时间'),
    ('updated_at', '更新时间'),
    ('status', '可用状态'),
    ('type', '数据类型'),
    ('value', '字面字符串'),
    ('note', '备注');

  -- Loop through each record and add the comments
  FOR column_record IN SELECT * FROM temp_comments
  LOOP
    EXECUTE format(
      'COMMENT ON COLUMN %I.%I IS %L',
      'cms_dict',
      column_record.column_name,
      column_record.column_comment
    );
  END LOOP;

  -- Drop the temporary table
  DROP TABLE temp_comments;
END $$;
