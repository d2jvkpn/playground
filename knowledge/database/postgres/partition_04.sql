CREATE TABLE events (
    id SERIAL,
    event_time TIMESTAMPTZ NOT NULL,
    data TEXT,
    
    PRIMARY KEY (id, event_time)
) PARTITION BY RANGE (event_time);

-- CREATE TABLE events_2023 PARTITION OF events
--   FOR VALUES FROM ('2023-01-01 00:00:00+00') TO ('2024-01-01 00:00:00+00');

CREATE TABLE events_2023 PARTITION OF events
  FOR VALUES FROM ('2023-01-01 00:00:00+08') TO ('2024-01-01 00:00:00+08');

CREATE TABLE events_2024 PARTITION OF events
    FOR VALUES FROM ('2024-01-01'::timestamptz) TO ('2025-01-01'::timestamptz);

select to_date('2024', 'YYYY');

select date_trunc('year', '2024-01-01'::timestamptz);

SELECT CURRENT_TIMESTAMP(3);
