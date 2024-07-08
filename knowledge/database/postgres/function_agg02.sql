-- 步骤 1: 创建基础合并函数
CREATE OR REPLACE FUNCTION custom_jsonb_merge(jsonb1 JSONB, jsonb2 JSONB) RETURNS JSONB
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT
  RETURN jsonb1 || jsonb2;

-- select custom_jsonb_merge('{"a": 1}', '{"b": 42}');

-- 步骤 2: 创建状态转换函数
CREATE OR REPLACE FUNCTION custom_jsonb_agg_sfunc(state JSONB, value JSONB) RETURNS JSONB AS $$
BEGIN
  IF state IS NULL THEN
     RETURN value;
  ELSE
     RETURN state || value;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- 步骤 3: 创建最终函数
CREATE OR REPLACE FUNCTION custom_jsonb_agg_ffunc(state JSONB) RETURNS JSONB AS $$
BEGIN
    RETURN state;
END;
$$ LANGUAGE plpgsql;

-- 步骤 4: 创建自定义聚合函数
CREATE AGGREGATE custom_jsonb_agg(jsonb_data JSONB) (
    SFUNC = custom_jsonb_agg_sfunc,
    STYPE = JSONB,
    FINALFUNC = custom_jsonb_agg_ffunc,
    INITCOND = '{}'
);


CREATE TABLE my_table (
  id SERIAL PRIMARY KEY,
  data JSONB
);

INSERT INTO my_table (data) VALUES
  ('{"name": "Alice", "transactions": [{"amount": 100}, {"amount": 200}]}'),
  ('{"name": "Bob", "transactions": [{"amount": 150}, {"amount": 250}]}'),
  ('{"name": "Charlie", "transactions": [{"amount": 300}, {"amount": 400}]}');

SELECT jsonb_object_agg(id, data) AS aggregated_data
FROM my_table;

/*
{
  "1": {"name": "Alice", "transactions": [{"amount": 100}, {"amount": 200}]},
  "2": {"name": "Bob", "transactions": [{"amount": 150}, {"amount": 250}]},
  "3": {"name": "Charlie", "transactions": [{"amount": 300}, {"amount": 400}]}
}
*/

select custom_jsonb_agg(data) from my_table;
/*
{"name": "Charlie", "transactions": [{"amount": 300}, {"amount": 400}]}
*/
