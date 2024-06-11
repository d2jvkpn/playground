CREATE TABLE accounts (
  id serial,
  name varchar,

  PRIMARY KEY(id)
);

SELECT * FROM accounts_id_seq;

ALTER SEQUENCE accounts_id_seq RESTART WITH 100;

INSERT INTO accounts (name) VALUES ('aa'), ('bb'), ('cc');

SELECT * FROM accounts;
SELECT * FROM accounts_id_seq;
