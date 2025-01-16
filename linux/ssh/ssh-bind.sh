#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


function display_usage() {
>&2 cat <<'EOF'
Usage of ssh-bind.sh

#### 1. Run
- ssh-bind.sh host postgres redis
- ssh-bind.sh "-F path/to/ssh.conf host" postgres redis

#### 2. environment variables
local_addr=localhost
config=~/apps/configs/ssh-bind.yaml

#### 3. Configuration file:
```yaml
host:
  kibana: { port: 5601, addr: 127.0.0.1, target_port: 5601 }
  redis: { port: 6379 }
  postgres: { port: 5432 }

#### 4. Examples
- Bind a local port to access the postgres service on a remote server.
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
    >&2 echo '!!! Args are required: host <service...>'
    exit 1
fi

host=$1
local_addr=${local_addr:-localhost}
config=${config:-~/apps/configs/ssh-bind.yaml}
ls $config > /dev/null

shift

for svc in $@; do
    port=$(yq .$svc.port $config)
    #echo "~~> service: $svc, $port"
    if [[ -z "$port" || "$port" == "null" ]]; then
        >&2 echo 'Sevice is unset in' $svc, $config
        exit 1
    fi
done

binds=$(
    for svc in $@; do
        port=$(yq .$svc.port $config)

        targetPort=$(
          yq '.'$svc'.targetPort |= "'$port'"' $config |
          yq .$svc.targetPort
        )

        addr=$(yq '.'$svc'.addr |= "localhost"' $config | yq .$svc.addr)

        echo "-L $local_addr:$port:$addr:$port"
    done
)

set -x
ssh -N $binds $host
