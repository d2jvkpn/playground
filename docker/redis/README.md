#### References
- https://raw.githubusercontent.com/redis/redis/7.0/redis.conf
- https://redis.io/docs/manual/persistence/
- https://redis.io/commands/acl-setuser/
- https://geshan.com.np/blog/2022/01/redis-docker/
- https://redis.io/docs/management/config-file/

#### C01. Setup
``` bash
mkdir -p configs data/redis

# touch data/redis/redis.log

cat > configs/redis.conf <<EOF
requirepass world

dir /data
logfile redis.log
dbfilename dump.rdb
aof-use-rdb-preamble yes
proto-max-bulk-len 32mb
io-threads 4
io-threads-do-reads yes
EOF

cp docker_deploy.yaml docker-compose.yaml
docker-compose -f docker-compose.yaml up -d

# docker-compose -f deployment.yaml down
```

#### C02. Redis Commands
```redis
help getex
command
acl list
acl whoami

config get dir
config get *

bgsave
# seconds words
save 30 10

info persistence

# reset default administrator password
config set requirepass d2jvkpn
auth d2jvkpn

acl setuser hello -keys -flushall -flushdb -config on >world
acl list
auth hello world
```

#### C03. ACL
```
# set password for default account
ACL SETUSER default on >mystrongpassword

# create account with password
ACL SETUSER myuser on >mypassword

# allow account to access all databases
ACL SETUSER myuser ~* +@all

# allow account to access database 1
ACL SETUSER myuser >mypassword resetchannels +@all resetkeys ~db1:* on

# verify
AUTH myuser mypassword
SELECT 1

ACL SAVE
```
