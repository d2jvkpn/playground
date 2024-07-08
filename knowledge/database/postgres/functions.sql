SELECT pg_get_functiondef('public.calculate_sales_tax'::regproc);


CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;


DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'add_numbers'
  ) THEN
    CREATE FUNCTION add_numbers(a integer, b integer) RETURNS integer
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT
    RETURN a + b;
  END IF;
END $$;


CREATE OR REPLACE FUNCTION jsonb_merge(jsonb1 JSONB, jsonb2 JSONB) RETURNS JSONB AS $$
BEGIN
    RETURN jsonb1 || jsonb2;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add(a integer, b integer) RETURNS integer
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT
  RETURN a + b;
