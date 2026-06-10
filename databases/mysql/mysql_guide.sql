----
CREATE DATABASE IF NOT EXISTS `<dbname>` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS USER '<user>'@'%' IDENTIFIED BY '<password>';

GRANT ALL PRIVILEGES ON <dbname>.* TO '<user>'@'%';

FLUSH PRIVILEGES;

ALTER USER '<user>'@'%' IDENTIFIED BY '<new_password>';

-- $ mysqladmin -u username -p password 'new_password'

----
-- INSERT INTO user_status VALUES ('active'), ('inactive'), ('banned');

CREATE TABLE `users` (
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户唯一ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `email` VARCHAR(100) NOT NULL COMMENT '电子邮箱',
    `password_hash` VARCHAR(255) NOT NULL COMMENT '加密后的密码',
    status ENUM('active', 'inactive', 'banned') NOT NULL DEFAULT 'active',

    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_email` (`email`)
    -- CONSTRAINT fk_status FOREIGN KEY (status) REFERENCES user_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';


CREATE INDEX idx_created_at ON '<user>'@'%' (created_at DESC);

---- misc
-- PURGE BINARY LOGS TO 'mysql-bin.010';
-- PURGE BINARY LOGS BEFORE '2024-05-01 00:00:00';
