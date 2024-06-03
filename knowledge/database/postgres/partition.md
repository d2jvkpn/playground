# 

#### 1. Links
- https://www.postgresql.org/docs/current/ddl-partitioning.html
- https://rasiksuhail.medium.com/guide-to-postgresql-table-partitioning-c0814b0fbd9b

#### 2. Range Partitioning
- 2.1
```
--
CREATE TABLE sales (
    sale_id    uuid DEFAULT gen_random_uuid(),
    sale_date  date NOT NULL,
    product_id int,
    quantity   int,
    amount     numeric,

    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE(sale_date);

--
CREATE TABLE sales_202301 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE sales_202302 PARTITION OF sales
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

CREATE TABLE sales_202303 PARTITION OF sales
    FOR VALUES FROM ('2023-03-01') TO ('2023-04-01');

--
ALTER TABLE sales_202301 ADD CONSTRAINT sales_january_check
    CHECK (sale_date >= '2023-01-01' AND sale_date < '2023-02-01');

ALTER TABLE sales_202302 ADD CONSTRAINT sales_february_check
    CHECK (sale_date >= '2023-02-01' AND sale_date < '2023-03-01');

ALTER TABLE sales_202303 ADD CONSTRAINT sales_march_check
    CHECK (sale_date >= '2023-03-01' AND sale_date < '2023-04-01');

--
INSERT INTO sales (sale_date, product_id, quantity, amount) VALUES
    ('2023-01-15', 101, 5, 100.00),
    ('2023-02-20', 102, 10, 200.00),
    ('2023-03-10', 103, 8, 150.00);

INSERT INTO sales (sale_date, product_id, quantity, amount) VALUES
    ('2023-12-15', 104, 5, 100.42);
-- ERROR: no partition of relation "sales" found for row
-- DETAIL:  Partition key of the failing row contains (sale_date) = (2023-12-15).
```

- 2.2
```sql
CREATE TABLE IF NOT EXISTS sales2 (
    sale_id    uuid DEFAULT gen_random_uuid(),
    sale_date  date NOT NULL DEFAULT now()::date,
    sale_at    timestamptz NOT NULL DEFAULT now(),
    product_id int,
    quantity   int,
    amount     numeric,

    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE(sale_date);


CREATE TABLE IF NOT EXISTS sales2_202406 PARTITION OF sales2
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');

ALTER TABLE sales2_202406 ADD CONSTRAINT sales2_202406_check
    CHECK (sale_date >= '2024-06-01' AND sale_date < '2024-07-01');

INSERT INTO sales2 (product_id, quantity, amount) VALUES
    (101, 5, 100.00),
    (102, 10, 200.00),
    (103, 8, 150.00);

INSERT INTO sales2 (sale_date, sale_at, product_id, quantity, amount) VALUES
    ('2024-07-01', now(), 101, 5, 100.00);
```

#### 3. List Partitioning
```
CREATE TABLE products (
    product_id   serial,
    category     text,
    product_name text,
    price        numeric,

    PRIMARY KEY(product_id, category)
) PARTITION BY LIST(category);

CREATE TABLE electronics PARTITION OF products
    FOR VALUES IN ('Electronics');

CREATE TABLE clothing PARTITION OF products
    FOR VALUES IN ('Clothing');

CREATE TABLE furniture PARTITION OF products
    FOR VALUES IN ('Furniture');

INSERT INTO products (category, product_name, price) VALUES
    ('Electronics', 'Smartphone', 500.00),
    ('Clothing', 'T-Shirt', 25.00),
    ('Furniture', 'Sofa', 800.00);
```

#### 4. Hash Partitioning
```sql
CREATE TABLE orders (
    order_id     serial,
    order_date   date,
    customer_id  int,
    total_amount numeric,

    PRIMARY KEY(order_id, customer_id)
) PARTITION BY HASH(customer_id);

CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES WITH (MODULUS 3, REMAINDER 0);

CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES WITH (MODULUS 3, REMAINDER 1);

CREATE TABLE orders_3 PARTITION OF orders
    FOR VALUES WITH (MODULUS 3, REMAINDER 2);

INSERT INTO orders (order_date, customer_id, total_amount) VALUES
    ('2023-01-15', 101, 500.00),
    ('2023-02-20', 102, 600.00),
    ('2023-03-10', 103, 700.00);
```
