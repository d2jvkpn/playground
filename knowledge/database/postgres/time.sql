select to_char(date_add('2024-08-01', interval '-1 day'), 'yyyy-mm-dd') the_end_of_this_month;

select date_add(to_char(now(), 'yyyy-mm-01')::date, '1 month - 1 day')::date the_end_of_this_month;

select date_trunc('hour', created_at) + 
  (floor(extract(minute from created_at) / 15) * interval '15 min') AS period_start,
  count(1)
from table_01
where create_time >= '2024-07-02 00:00:00+08' AND create_time < '2024-07-03 00:00:00+08'
group by period_start;

-- month range
select * from ghosts
where date >= '2024-07' AND
  date < to_char(to_date('2024-07's, 'yyyy-mm') + interval '1 month', 'yyyy-mm-dd');
