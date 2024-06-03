# 

#### 1. Links
- https://www.postgresql.org/docs/current/ddl-partitioning.html
- https://rasiksuhail.medium.com/guide-to-postgresql-table-partitioning-c0814b0fbd9b

#### 2. Range Partitioning
```
--
CREATE TABLE sales (
    sale_id    uuid DEFAULT gen_random_uuid(),
    sale_date  DATE NOT NULL,
    product_id INT,
    quantity   INT,
    amount     NUMERIC,
    
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

#### 3. List Partitioning
```
CREATE TABLE products (
    product_id SERIAL,
    category TEXT,
    product_name TEXT,
    price NUMERIC,

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
    order_id SERIAL,
    order_date DATE,
    customer_id INT,
    total_amount NUMERIC,

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
