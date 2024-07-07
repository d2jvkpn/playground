SELECT t1.org_id, t2.name org_name, array_agg(t1.account_id) account_ids
FROM user_org_members t1
INNER JOIN user_orgs t2 ON t1.org_id = t2.id
WHERE t2.status = true
GROUP BY t1.org_id, t2.name
ORDER BY t2.name, t1.org_id;

CREATE TABLE my_table (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO my_table (data) VALUES
('{"key1": {"value": 10.5}}'),
('{"key2": {"value": 20.3}}');

UPDATE my_table
SET data = JSONB_SET(data, '{key1, value}', '15.7'::JSONB)
WHERE id = 1;

UPDATE my_table
SET data = JSONB_SET(data, '{xx}', '15.7'::JSONB)
WHERE id = 1;


--
CREATE TABLE events (
    id serial,
    type text,
    status text
);

INSERT INTO events (id, type, status) VALUES
(1, 'A', 'open'),
(1, 'A', 'closed'),
(1, 'B', 'open'),
(2, 'A', 'open'),
(2, 'B', 'closed'),
(3, 'A', 'open'),
(3, 'A', 'open'),
(3, 'B', 'closed');

SELECT id,
  jsonb_object_agg(type, status_counts) AS type_status_counts
FROM (
  SELECT
    id, type,
    jsonb_object_agg(status, count) AS status_counts
  FROM (
    SELECT id, type, status, COUNT(1) AS count
    FROM events
    GROUP BY id, type, status
  ) AS subquery
  GROUP BY id, type
) AS final_subquery
GROUP BY id;


WITH status_counts AS (
  SELECT id, type, status, COUNT(1) AS count
  FROM events
  GROUP BY id, type, status
),
type_status_json AS (
  SELECT id, type, jsonb_object_agg(status, count) AS status_counts
  FROM status_counts
  GROUP BY id, type
)
SELECT id, jsonb_object_agg(type, status_counts) AS type_status_counts
FROM type_status_json
GROUP BY id;

SELECT type, json_agg(number) AS status FROM
(
  select type, json_build_object('key', status, 'value', count(1)) number
  from events group by type, status
) t1
GROUP BY type;
