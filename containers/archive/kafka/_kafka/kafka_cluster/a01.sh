#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. start zookeeper
cat config/zookeeper.properties

bin/zookeeper-server-start.sh config/zookeeper.properties
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

nc -zv localhost 2181

echo srvr | nc localhost 2181
echo conf | nc localhost 2181
# echo "4lw.commands.whitelist=stat, ruok, conf, isro" >> config/zookeeper.properties

#### 2. zookeeper shell
bin/zookeeper-shell.sh localhost:2181
_=```
ls /
echo "ruok" | nc localhost 2181; echo

help
create /my-node "foo"
ls /
get /my-node
get -s /my-node
set /my-node "new data"

create /my-node/new-node ""
set /my-node/new-node "~~~"
get /my-node/new-node

ls /
ls /my-node

delete /my-node/new-node
delete /my-node
```

#### 3. stop zookeeper
bin/zookeeper-server-stop.sh
