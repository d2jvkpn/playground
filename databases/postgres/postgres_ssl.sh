#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
# 创建服务器私钥
openssl genrsa -out server.key 2048

# 创建服务器证书签名请求 (CSR)
openssl req -new -key server.key -out server.csr -subj "/CN=yourdomain.com"

# 自签名证书 (有效期一年)
openssl x509 -req -in server.csr -signkey server.key -out server.crt -days 365

# 设置服务器私钥的权限
chmod 600 server.key

cat >> postgresql.conf <<EOF
ssl = on
ssl_cert_file = '/var/lib/postgresql/certs/server.crt'
ssl_key_file = '/var/lib/postgresql/certs/server.key'
EOF

cat >> pg_hba.conf <<EOF
# IPv4 local connections:
hostssl    all             all             0.0.0.0/0               md5
EOF

psql "sslmode=require host=your_host user=your_user dbname=your_db"

echo "psql \conninfo"
