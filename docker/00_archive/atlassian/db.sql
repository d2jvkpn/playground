-- ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'MyNewPassword';
-- FLUSH PRIVILEGES;

CREATE USER 'hello' IDENTIFIED BY 'world';
UPDATE mysql.user SET host = '%' WHERE user = 'hello' AND host='localhost';

CREATE DATABASE jira CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,REFERENCES,ALTER,INDEX ON jira.* TO 'hello'@'%';

CREATE DATABASE confluence DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT ALL ON confluence.* TO 'hello'@'%';
