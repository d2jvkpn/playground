-- https://www.cybertec-postgresql.com/en/automatic-partition-creation-in-postgresql/#:~:text=Automatic%20partition%20creation%20for%20time%2Dtriggered%20partitioning,-The%20lack%20of&text=You%20can%20use%20the%20operating,ATTACH%20PARTITION%20statements.

CREATE TABLE sales (
  id uuid default gen_random_uuid(),
  at char(10) NOT NULL,

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  amount NUMERIC(10, 2) NOT NULL,

  primary key(id, at)
) PARTITION BY RANGE (at);

CREATE TABLE sales_def PARTITION OF sales DEFAULT;

CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER updated_at BEFORE UPDATE ON sales FOR EACH ROW EXECUTE PROCEDURE update_now();

CREATE OR REPLACE FUNCTION create_sales_yyyy() RETURNS trigger
  LANGUAGE plpgsql AS
$$BEGIN
  BEGIN
    EXECUTE format(
      'CREATE TABLE %I (LIKE sales INCLUDING INDEXES)',
      'sales_' || substring(new.at, 1, 4)
    );
    -- trigger won't be included

    EXECUTE format('NOTIFY sales, %L', 'sales_' || substring(new.at, 1, 4));
  EXCEPTION
    WHEN duplicate_table THEN NULL;  -- ignore
  END;
 
  EXECUTE format('INSERT INTO %I VALUES ($1.*)', 'sales_' || substring(new.at, 1, 4)) USING NEW;

  RETURN NULL;
END;$$;

CREATE TRIGGER create_sales_yyyy
BEFORE INSERT ON sales FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION create_sales_yyyy();

INSERT INTO sales (at, amount) VALUES
  ('2025', 2001),
  ('2025', 2024),
  ('2023', 42),
  ('2023-12-01', 42);

ALTER TABLE sales ATTACH PARTITION sales_2023 FOR VALUES FROM ('2023') TO ('2024');
-- ALTER TABLE sales DETACH PARTITION sales_2023;
-- ALTER TABLE sales DETACH PARTITION sales_2023 CONCURRENTLY;

ALTER TABLE sales ATTACH PARTITION sales_2025 FOR VALUES FROM ('2025') TO ('2026');
