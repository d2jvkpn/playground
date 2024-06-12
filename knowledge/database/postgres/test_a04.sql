create table test_a04(name varchar, value int);

insert into test_a04 (name, value) values
  ('aa', 1),
  ('aa', 0),
  ('aa', 0),
  ('bb', 1),
  ('bb', 1),
  ('bb', 0);


select
  name,
  sum(case when value = 0 then 1 else 0 end) as v0,
  sum(case when value = 1 then 1 else 0 end) as v1
  from test_a04
  group by name order by name;
