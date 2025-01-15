#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

function display_usage() {
>&2 cat <<'EOF'
Usage of ssh-bind.sh

#### 1. run
$ ssh-bin.sh host postgres redis

#### 2. environment variables
local_addr=locahost
config=~/apps/configs/ssh-bind.yaml

#### 3. config(yaml):
```yaml
services:
  kibana: { port: 5601, addr: 127.0.0.1, target_port: 5601 }
  redis: { port: 6379 }
  postgres: { port: 5432 }
```
EOF
}

case "${1:-""}" in
"" | "help" | "-h" | "--help")
    display_usage
    exit 0
    ;;
esac

if [ $# -lt 2 ]; then
    >&2 echo '!!! args are required: <host> <service...>'
    exit 1
fi

host=$1
local_addr=${local_addr:-localhost}
config=${config:-~/apps/configs/ssh-bind.yaml}
ls $config > /dev/null

shift

for svc in $@; do
    port=$(yq .services.$svc.port $config)
    #echo "~~> service: $svc, $port"
    if [[ -z "$port" || "$port" == "null" ]]; then
        >&2 echo 'Sevice is unset in' $svc, $config
        exit 1
    fi
done

binds=$(
    for svc in $@; do
        port=$(yq .services.$svc.port $config)

        targetPort=$(
          yq '.services.'$svc'.targetPort |= "'$port'"' $config |
          yq .services.$svc.targetPort
        )

        addr=$(yq '.services.'$svc'.addr |= "localhost"' $config | yq .services.$svc.addr)

        echo "-L $local_addr:$port:$addr:$port"
    done
)

set -x
ssh -N $binds $host
