#### References
- https://raw.githubusercontent.com/redis/redis/7.0/redis.conf
- https://redis.io/docs/manual/persistence/
- https://redis.io/commands/acl-setuser/
- https://geshan.com.np/blog/2022/01/redis-docker/
- https://redis.io/docs/management/config-file/
- session
- rate limit(incr+ttl)
- oub/sub
- sorted set
- distributed lock(setnx)

#### ch01. Setup
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

#### ch02. Redis Commands
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

CONFIG GET *preamble*
```

#### ch03. ACL
1. create acl file
```bash
touch data/redis/aclfile.acl

sed -i 's/^requirepass/#requirepass/; /^#aclfile/s/#aclfile/aclfile/' data/redis/redis.conf

docker-compose down
docker-compose up -d
```

2. acl auth
```redis
# set password for default account
ACL SETUSER default on >dont_use_this_password

ACL SAVE

# create account with password
ACL SETUSER alice on >dont_use_this_password +@all

# allow account to access database 1
ACL SETUSER bob >dont_use_this_password ~bob:* +get +mget +set +exists +ttl

# verify
AUTH bob dont_use_this_password
SELECT 1

ACL SAVE
ACL LIST

ACL DELUSER bob
ACL SETUSER bob on
```

#### ch04. Connect
```
docker exec -it redis redis-cli -a "$password"
```
