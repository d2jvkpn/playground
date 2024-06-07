-- 1.
CREATE OR REPLACE FUNCTION update_now() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$LANGUAGE plpgsql;

create table test_a01 (
    id serial,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT null,
    name varchar NOT NULL UNIQUE,
    note varchar NOT NULL DEFAULT '',

    primary key (id)
);

CREATE TRIGGER updated_at BEFORE UPDATE ON test_a01 FOR EACH ROW EXECUTE PROCEDURE update_now();

-- 2. 
insert into test_a01 (name) values
    ('a01'),
    ('a02'),
    ('a03');

select * from test_a01;

update test_a01 set note = 'x02' where name = 'a02';
--  2 | 2024-06-05 22:15:48.495917+08 | 2024-06-05 22:16:06.34167+08 | a02  | x02

update test_a01 set note = 'x02' where name = 'a02' returning id;
--  2 | 2024-06-05 22:15:48.495917+08 | 2024-06-05 22:27:02.787134+08 | a02  | x02

update test_a01 set note = 'x02' where name = 'a02' returning id;

update test_a01 set note = 'x02' where name = 'not_exsits' returning id;
-- (0 rows)

update test_a01
  set note = 'hello'
  where name = 'a02'
  returning id, name, note as new_note, (
    select note from test_a01 where name = 'a02'
  ) as old_note;

UPDATE your_table
SET column_name = CASE
    WHEN condition_1 THEN value_1
    WHEN condition_2 THEN value_2
    ELSE default_value
END
WHERE your_condition;

UPDATE employees
SET salary = CASE
    WHEN department = 'IT' THEN salary * 1.1
    WHEN department = 'Sales' THEN salary * 1.05
    ELSE salary
END;
