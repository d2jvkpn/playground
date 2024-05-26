\x on;
\pset null '<null>';

SELECT to_timestamp('2024-05-09 16:37:05', 'YYYY-MM-DD hh24:mi:ss')::timestamptz;

SELECT to_timestamp('2024-05-09 16:37:05', 'YYYY-MM-DD hh24:mi:ss')::timestamp 
  without time zone at time zone 'Etc/UTC';


-- returing origin values before update
create table temp_accounts (
  id UUID DEFAULT gen_random_uuid(),
  name varchar NOT NULL UNIQUE,

  primary key (id)
);

insert into temp_accounts (name) values ('test_a01') returning id;

update temp_accounts x
  set name = 'test_a02'
  from (select id, name from temp_accounts where id = '4acd8a46-60e2-46bd-a81a-50f1d85e235c' for update) y
  where  x.id = y.id
  returning y.name old_name, x.name new_name;

truncate table temp_accounts;
drop table temp_accounts;
