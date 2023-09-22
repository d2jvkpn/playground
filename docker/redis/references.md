#### References
- https://raw.githubusercontent.com/redis/redis/7.0/redis.conf
- https://redis.io/docs/manual/persistence/
- https://redis.io/commands/acl-setuser/
- https://geshan.com.np/blog/2022/01/redis-docker/
- https://redis.io/docs/management/config-file/

#### Setup
``` bash
mkdir -p configs data

cat > configs/redis.conf <<EOF
dbfilename redis-dump.rdb
aof-use-rdb-preamble yes
proto-max-bulk-len 32mb
io-threads 4
io-threads-do-reads yes
dir /data
EOF

docker-compose -f deployment.yaml up -d
docker-compose -f deployment.yaml down
```

#### Redis Commands
```redis
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
