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
