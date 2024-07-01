CREATE TABLE my_table (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO my_table (data) VALUES
('{"key1": {"value": 10.5}}'),
('{"key2": {"value": 20.3}}');

UPDATE my_table
SET data = JSONB_SET(data, '{key1, value}', '15.7'::JSONB)
WHERE id = 1;

UPDATE my_table
SET data = JSONB_SET(data, '{xx}', '15.7'::JSONB)
WHERE id = 1;
