CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX user_accounts_firstname_trgm ON user_accounts USING gin (firstname gin_trgm_ops);
CREATE INDEX user_accounts_lastname_trgm ON user_accounts USING gin (lastname gin_trgm_ops);

-- SELECT * FROM user_accounts WHERE firstname % 'Emmett' ORDER BY similarity(firstname, 'Emmett') DESC;
