create table test_json_a02 (
  id uuid default gen_random_uuid(),
  data jsonb not null default '{}',
  raw json not null default '{}',
  
  primary key (id)
);

create index test_json_a02_data on test_json_a02 (data);

create index test_json_a02_raw on test_json_a02 (raw);
-- ERROR:  data type json has no default operator class for access method "btree"

create index test_json_a02_raw_x on test_json_a02 ((raw->>'x')) where raw->>'x' is not null;
