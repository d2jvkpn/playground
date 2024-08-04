create table platform_settings (
  name text not null,
  type text not null,

  tags text[] not null default array[]::text[],
  value text not null,

  primary key (name, type)
);

insert into platform_settings (name, type, value) values
  ('query_power', 'interval', '15 minute');

select now() + value::interval from platform_settings;

select * from platform_settings;
