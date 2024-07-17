-- 01
CREATE TABLE sales (
    id uuid default gen_random_uuid(),
    at char(10) NOT NULL,

    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),

    amount NUMERIC(10, 2) NOT NULL,

    primary key(id, at)
) PARTITION BY RANGE (at);

CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER updated_at BEFORE UPDATE ON sales FOR EACH ROW EXECUTE PROCEDURE update_now();

-- 02
CREATE TABLE sales_0000 PARTITION OF sales FOR VALUES FROM ('0000') TO ('0001');

CREATE TABLE sales_2023 PARTITION OF sales FOR VALUES FROM ('2023') TO ('2024');

CREATE TABLE sales_2024 PARTITION OF sales FOR VALUES FROM ('2024') TO ('2025');

-- ALTER TABLE sales ATTACH PARTITION sales_2023 FOR VALUES FROM ('2023') TO ('2024');
-- ALTER TABLE sales DETACH PARTITION sales_2023;
-- ALTER TABLE sales DETACH PARTITION sales_2023 CONCURRENTLY;


-- 03
INSERT INTO sales (at, amount) VALUES ('2023-05-15', 100.00);

INSERT INTO sales (at, amount) VALUES ('2024-06-20', 200.00);

INSERT INTO sales (at, amount) VALUES
  ('0000', 1001),
  ('0000', 1024);

select * from sales;

SELECT * FROM sales WHERE at BETWEEN '2023-01-01' AND '2023-12-31';

SELECT * FROM sales WHERE at BETWEEN '2023' AND '2024-12-31';

SELECT * FROM sales WHERE at BETWEEN '2023' AND '2026';

select * from sales where at = '0000';

SELECT * FROM sales WHERE at BETWEEN '2027' AND '2030';

----- NOT WORKING-----
--------------------------------------------------------------------------------------------------------------------------------

-- to_char(NEW.sale_date, 'YYYY')
CREATE OR REPLACE FUNCTION create_partition_of_sales()
RETURNS trigger
   LANGUAGE plpgsql AS
$$BEGIN
  BEGIN
  EXECUTE format(
    'CREATE TABLE sales_%I PARTITION OF sales FOR VALUES FROM (%I) TO (%I)',
    substring(NEW.at, 1, 4),
    substring(NEW.at, 1, 4),
    RIGHT('0000' || (substring(NEW.at, 1, 4)::int + 1), 4)
  );
  END;

  EXECUTE format(
    'INSERT INTO sales_$I VALUES ($1.*)', substring(NEW.at, 1, 4)
  ) USING NEW;

  RETURN NULL;
END;$$;

CREATE OR REPLACE FUNCTION create_partition_of_sales()
RETURNS TRIGGER AS $$
DECLARE
    partition_name TEXT;
    start_year text;
    end_year text;
BEGIN
    RAISE NOTICE '==> create_partition_of_sales: %', substring(NEW.at, 1, 4);

    -- 生成分区表名
    partition_name := 'sales_' || substring(NEW.at, 1, 4);
    
    start_year := RIGHT('0000' || substring(NEW.at, 1, 4), 4);
    end_year := RIGHT('0000' || substring(NEW.at, 1, 4)::int + 1, 4);

    -- 动态创建分区表
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || partition_name ||
      ' PARTITION OF sales FOR VALUES FROM (''' ||
      start_year || ''') TO (''' || end_year || ''')';
    
    -- 将新记录插入到正确的分区表
    EXECUTE 'INSERT INTO ' || partition_name || ' VALUES ($1.*)' USING NEW;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_sales_trigger
   BEFORE INSERT ON sales FOR EACH ROW
   WHEN (pg_trigger_depth() < 1)
   EXECUTE FUNCTION create_partition_of_sales();
-- drop trigger insert_sales_trigger on sales;


INSERT INTO sales (at, amount) VALUES
  ('2025', 2001),
  ('2025', 2024);
