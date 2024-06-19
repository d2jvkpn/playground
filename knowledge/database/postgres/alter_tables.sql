-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-alter-table/

ALTER TABLE table_name action;

ALTER TABLE table_name 
  ADD COLUMN column_name datatype column_constraint;


ALTER TABLE table_name
  DROP COLUMN column_name;

ALTER TABLE table_name
  RENAME COLUMN column_name
  TO new_column_name;

ALTER TABLE table_name
  ALTER COLUMN column_name
  [SET DEFAULT value | DROP DEFAULT];

ALTER TABLE table_name
  ALTER COLUMN column_name
  [SET NOT NULL| DROP NOT NULL];

ALTER TABLE table_name
  ADD CHECK expression;

ALTER TABLE table_name
  ADD CONSTRAINT constraint_name constraint_definition;

ALTER TABLE table_name
  RENAME TO new_table_name;

DROP TABLE IF EXISTS links;

CREATE TABLE links (
  link_id serial PRIMARY KEY,
  title VARCHAR (512) NOT NULL,
  url VARCHAR (1024) NOT NULL
);

ALTER TABLE links
  ADD COLUMN active boolean;

ALTER TABLE links
  DROP COLUMN active;

ALTER TABLE links
  RENAME COLUMN title TO link_title;

ALTER TABLE links
  ADD COLUMN target VARCHAR(10);

ALTER TABLE links
  ALTER COLUMN target
  SET DEFAULT '_blank';

INSERT INTO links (link_title, url)
  VALUES('PostgreSQL Tutorial','https://www.postgresqltutorial.com/');

SELECT * FROM links;

ALTER TABLE links
  ADD CHECK (target IN ('_self', '_blank', '_parent', '_top'));

INSERT INTO links(link_title,url,target)
  VALUES('PostgreSQL','http://www.postgresql.org/','whatever');

ALTER TABLE links
  ADD CONSTRAINT unique_url UNIQUE (url);

INSERT INTO links(link_title,url)
  VALUES('PostgreSQL','https://www.postgresqltutorial.com/');

ALTER TABLE links
  RENAME TO urls;


