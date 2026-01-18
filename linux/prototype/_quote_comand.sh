#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# Quote a command for execution

exit

command="db.collection.find({key: '$key'}).forEach(d => print(EJSON.stringify(d)));"
command=$(printf '"%s"' "$command")

ssh $host docker exec mongosh mongosh mongodb://127.0.0.1:27017/$db --quiet --eval "$command"
