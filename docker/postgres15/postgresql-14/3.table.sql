-- \connect hello;

CREATE TABLE users (
  id serial PRIMARY KEY,
  name character(32) NOT NULL, 
  -- name character varying(32) NOT NULL, 
  age integer DEFAULT 0,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now(),
  UNIQUE(name)
);
-- drop table users;
-- truncate users;


\l  -- databases
\d  -- relations
\dt -- tables
\ds -- sequence

\du -- roles

-- describe table users
\d users;
\d+ users;

INSERT INTO users (name, age) VALUES
  ('David', 2),
  ('Ava', 5) RETURNING *;

INSERT INTO users (name, age) VALUES
  ('"david"', 2) RETURNING *;

INSERT INTO users (name, age) VALUES
  ('Evol', 7),
  ('Rover', 9) RETURNING *;

UPDATE users SET age = 11 WHERE id = 3 RETURNING id, age, updated_at;

UPDATE users SET age = age + 1 WHERE id = 3 RETURNING *;

INSERT INTO users (name) VALUES ('YYYY');

SELECT * FROM users_id_seq;

SELECT * FROM users;

---- setup trigger
CREATE FUNCTION updated_at() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;

-- BEFORE INSERT OR UPDATE ON users
CREATE TRIGGER updated_at
   BEFORE INSERT OR UPDATE ON users
   FOR EACH ROW
   EXECUTE PROCEDURE updated_at();

-- ALTER TABLE users DROP TRIGGER updated_at;
-- DROP TRIGGER updated_at ON users;

\d+ users;

UPDATE users SET age = age + 1 WHERE id = 3 RETURNING *;

---- add json fields
ALTER TABLE users ADD COLUMN data JSON;

UPDATE users SET data = '{"x": 10.0, "y": 9.0}';

SELECT data FROM users;

SELECT data->'x' AS x FROM users;

SELECT data->'x' AS x, data->'y' AS y FROM users;

----
ALTER TABLE users ADD COLUMN data2 JSON;

UPDATE users SET data2 = '[1, 2, 3, 4]' where id = 1;

SELECT id, data2 FROM users;

SELECT id, data2->0 FROM users;

---- more tables
CREATE TABLE person (
    first_name text,
    last_name  text,
    email      text
);

alter table person add constraint name unique(first_name, last_name);
-- alter table person drop constraint name;

CREATE TABLE place (
    country  text,
    city     text NULL,
    telcode  integer
);

INSERT INTO person (first_name, last_name, email) VALUES
  ('Jason', 'Moiron', 'jmoiron@jmoiron.net'),
  ('John', 'Doe', 'johndoeDNE@gmail.net');

INSERT INTO place (country, city, telcode) VALUES
  ('United States', 'New York', 1),
  ('Hong Kong', '', 852),
  ('Singapore', NULL, 65)
  RETURNING *;

SELECT * FROM ROWS FROM (
  jsonb_each('{"a":"foo1","b":"bar"}'::jsonb),
  jsonb_each('{"c":"foo2"}'::jsonb))
  x (a1,a1_val,a2_val);
