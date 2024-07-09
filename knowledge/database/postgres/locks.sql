-- ####
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    balance NUMERIC
);

INSERT INTO accounts (balance) VALUES
    (1000),
    (2000);


BEGIN;
-- 锁定要更新的行
SELECT id, balance FROM accounts WHERE id = 1 FOR UPDATE;
SELECT id, balance FROM accounts WHERE id = 2 FOR UPDATE;
-- 更新行
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;


CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    event_id INT,
    remaining_tickets INT
);

INSERT INTO tickets (event_id, remaining_tickets) VALUES
    (1, 100),
    (2, 200);


BEGIN;
-- 锁定票务行
SELECT id, remaining_tickets FROM tickets WHERE event_id = 1 FOR UPDATE;
-- 检查是否有足够的票
UPDATE tickets SET remaining_tickets = remaining_tickets - 1 WHERE event_id = 1 AND remaining_tickets > 0;
COMMIT;


CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    amount NUMERIC
);

INSERT INTO orders (customer_id, amount) VALUES
    (1, 100.0),
    (1, 150.0),
    (2, 200.0),
    (2, 250.0),
    (3, 300.0);

BEGIN;

-- 锁定相关行
WITH locked_orders AS (
    SELECT * FROM orders WHERE customer_id IN (1, 2) FOR UPDATE
)
-- 在外部查询中进行分组和聚合
SELECT customer_id, SUM(amount) AS total_amount
FROM locked_orders
GROUP BY customer_id;

COMMIT;


-- ####
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    event_id INT,
    remaining_tickets INT
);

INSERT INTO tickets (event_id, remaining_tickets) VALUES
    (1, 100),
    (2, 200),
    (3, 300);

BEGIN;
-- 锁定票务行
WITH locked_tickets AS (
    SELECT * FROM tickets WHERE event_id IN (1, 2) FOR UPDATE
)
-- 在外部查询中进行分组和聚合
SELECT event_id, SUM(remaining_tickets) AS total_remaining
FROM locked_tickets
GROUP BY event_id;
COMMIT;
