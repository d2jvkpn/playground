-- postgres_guide.sql

-- ============================================================
-- 1. 创建数据库与用户
-- ============================================================
-- psql -U postgres -d postgres

CREATE USER <user> WITH LOGIN PASSWORD '<password>';

CREATE DATABASE <dbname> WITH ENCODING = 'UTF8' TEMPLATE = template0 owner = <user>;

GRANT ALL PRIVILEGES ON DATABASE <dbname> TO <user>;

-- ============================================================
-- 2. 连接到目标数据库后授权 schema
-- ============================================================
-- \c <dbname>

GRANT USAGE, CREATE ON SCHEMA public TO <user>;

-- 如果希望该用户拥有 public schema 下已有表的权限：
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <user>;

-- 如果希望该用户拥有 public schema 下已有序列的权限：
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO <user>;

-- 如果希望未来新建的表默认授权给该用户：
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO <user>;

-- 如果希望未来新建的序列默认授权给该用户：
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO <user>;

-- ============================================================
-- 3. 修改用户密码
-- ============================================================
ALTER USER <user> WITH PASSWORD '<new_password>';
-- \password <user>

-- ============================================================
-- 4. users 表
-- ============================================================
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'banned');

CREATE TABLE users (
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- user_id BIGSERIAL PRIMARY KEY,
    user_id  uuid PRIMARY KEY DEFAULT uuidv7(),   -- 用户唯一ID
    username VARCHAR(50) NOT NULL,                -- 用户名
    email VARCHAR(100) NOT NULL,                  -- 电子邮箱
    password_hash VARCHAR(255) NOT NULL,          -- 加密后的密码
    status user_status NOT NULL DEFAULT 'active'  -- 状态

    roles TEXT[] NOT NULL DEFAULT ARRAY['user'],  -- 角色列表
    tags TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[]  -- 标签列表
    settings JSONB NOT NULL DEFAULT '{}'::JSONB   -- 用户设置

    CONSTRAINT uk_users_email UNIQUE (email)
    -- CONSTRAINT chk_users_status CHECK (status IN ('active', 'inactive', 'banned'))
);

CREATE INDEX idx_users_created_at ON users (created_at DESC);

CREATE INDEX idx_users_roles ON users USING GIN (roles);
CREATE INDEX idx_users_settings ON users USING GIN (settings);
CREATE INDEX idx_users_settings_language ON users ((settings->>'language'));

COMMENT ON TABLE users IS '用户表';
COMMENT ON COLUMN users.created_at IS '创建时间';

INSERT INTO users (username, email, password_hash, roles, tags, settings)
VALUES (
    'alice',
    'alice@example.com',
    '<bcrypt_hash>',
    ARRAY['user', 'admin'],
    ARRAY['internal', 'vip'],
    '{"theme": "dark", "language": "zh-CN"}'
);

SELECT * FROM users WHERE 'admin' = ANY(roles);
SELECT * FROM users WHERE roles @> ARRAY['admin'];
SELECT
    username,
    profile->>'nickname' AS nickname,
    settings->>'theme' AS theme
FROM users;

SELECT * FROM users WHERE profile->>'city' = 'Shanghai';
SELECT * FROM users WHERE settings @> '{"theme": "dark"}';

-- ============================================================
-- 5. 自动更新 updated_at
-- ============================================================

CREATE OR REPLACE FUNCTION updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION updated_at();
