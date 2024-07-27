-- #### 01
CREATE TABLE distributed_locks (
  lock_name TEXT PRIMARY KEY,
  locked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  locked_by TEXT NOT NULL
);

WITH lock_attempt AS (
  INSERT INTO distributed_locks (lock_name, locked_by)
  VALUES ('my_lock', 'process_1')
  ON CONFLICT (lock_name) DO UPDATE
  SET locked_by = EXCLUDED.locked_by, locked_at = CURRENT_TIMESTAMP
  WHERE distributed_locks.locked_by = 'process_1'
  RETURNING *
)
SELECT * FROM lock_attempt;

DELETE FROM distributed_locks
WHERE lock_name = 'my_lock' AND locked_by = 'process_1';


-- #### 02
CREATE TABLE distributed_locks (
  lock_name  TEXT PRIMARY KEY,
  locked_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  locked_by  TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL
);

WITH lock_attempt AS (
  INSERT INTO distributed_locks (lock_name, locked_by, expires_at)
  VALUES ('my_lock', 'process_1', CURRENT_TIMESTAMP + INTERVAL '1 minute')
  ON CONFLICT (lock_name) DO UPDATE
  SET locked_by = EXCLUDED.locked_by, locked_at = CURRENT_TIMESTAMP,
    expires_at = EXCLUDED.expires_at
  WHERE distributed_locks.locked_by = 'process_1'
    OR distributed_locks.expires_at < CURRENT_TIMESTAMP
  RETURNING *
)
SELECT * FROM lock_attempt;
-- 删除过期锁
DELETE FROM distributed_locks WHERE expires_at < CURRENT_TIMESTAMP;


WITH lock_attempt AS (
  INSERT INTO distributed_locks (lock_name, locked_by, expires_at)
  VALUES ('my_lock', 'process_2', CURRENT_TIMESTAMP + INTERVAL '1 minute')
  ON CONFLICT (lock_name) DO UPDATE
  SET locked_by = EXCLUDED.locked_by,
    locked_at = CURRENT_TIMESTAMP,
    expires_at = EXCLUDED.expires_at
  WHERE distributed_locks.locked_by = 'process_2'
    OR distributed_locks.expires_at < CURRENT_TIMESTAMP
  RETURNING *
)
SELECT * FROM lock_attempt;
