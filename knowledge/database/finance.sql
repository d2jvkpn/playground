-- #### functions
CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;
-- drop function update_now cascade;

-- prefix list: events_, cms_, report_, device_, system_, detail_, biz_, user_

-- ####
CREATE TYPE finance_title AS
  ENUM('account_balance', 'deferred_revenue', 'available_balance', 'financial_records');
-- DROP TYPE finance_title;
-- ALTER TYPE finance_title ADD VALUE 'new_value'; -- appends to list
-- ALTER TYPE finance_title ADD VALUE 'new_value' BEFORE 'available_balance';
-- ALTER TYPE finance_title ADD VALUE 'new_value' AFTER 'available_balance';
-- ALTER TYPE finance_title RENAME TO _finance_title;

CREATE TYPE finance_sign AS ENUM('+', '-', '=', '_');
-- drop type finance_sign;

CREATE TABLE finance (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz DEFAULT NULL,

    month       char(7) NOT NULL,
    title       finance_title NOT NULL,
    kind        varchar NOT NULL,
    date        char(10) NOT NULL,
    item        varchar NOT NULL,
    sign        finance_sign NOT NULL,
    amount      decimal(6, 3) NOT NULL,
    tags        varchar[] NOT NULL DEFAULT array[]::varchar[]
);
-- DROP TABLE finance CASCADE;

-- ALTER TABLE finance ADD PRIMARY KEY (id);

CREATE INDEX finance_detail ON finance (month, title, kind, item);
-- DROP INDEX finance_detail;

CREATE INDEX finance_items ON finance (month, item);
-- DROP INDEX finance_items;

CREATE INDEX finance_amount ON finance (month, sign, amount);
-- DROP INDEX finance_amount;

CREATE INDEX finance_tags ON finance (month, tags);
-- drop index finance_tags;

CREATE TRIGGER finance_updated_at BEFORE INSERT OR UPDATE ON finance
  FOR EACH ROW EXECUTE PROCEDURE update_now();
-- DROP TRIGGER finance_updated_at;

SELECT * FROM pg_indexes WHERE tablename = 'finance';
SELECT * FROM information_schema.triggers WHERE event_object_table = 'finance';

-- SELECT * FROM finance WHERE 'Journal' = ANY(tags);
-- SELECT * FROM mytable WHERE tags && '{"Journal", "Book"}';

-- ####
-- date_trunc('month', now());
-- date(now());
-- month(now());
-- to_char(now(), 'YYYYMM');
-- CREATE TABLE new_table_name ( like old_table_name including all)

-- CREATE TABLE IF NOT EXISTS finance05 AS TABLE finance WITH NO DATA;

-- CREATE OR REPLACE FUNCTION create_finance_table(templ text)
-- RETURNS VOID AS
-- $$
-- DECLARE
--     table_name text;
-- BEGIN
--     table_name := 'finance_' || to_char(CURRENT_DATE, 'YYYYMM');

--     EXECUTE 'CREATE TABLE IF NOT EXISTS ' || table_name || ' AS TABLE ' || templ ||' WITH NO DATA';
-- END;
-- $$
-- LANGUAGE plpgsql;

-- select create_finance_table('finance');
