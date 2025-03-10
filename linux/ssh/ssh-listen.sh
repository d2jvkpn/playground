#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. functionss
function display_usage() {
>&2 cat <<'EOF'
Usage of ssh-listen.sh

#### 1. Run
- ssh-listen.sh <name> <services...>
- ssh-listen.sh ali postgres redis
- ssh-listen.sh config

#### 2. environment variables
local_addr=localhost
config=~/apps/configs/ssh-listen.yaml

#### 3. Configuration file:
```yaml
ssh_tunnel:
  aws:
    _args: -F path/to/ssh.conf remote_host
    kibana: { port: 5601, host: 127.0.0.1, local_port: 5601 }
    kafka: { port: 9092 }

  ali:
    _args: ali-web-prod
    redis: { port: 6379 }
    postgres: { port: 5432 }
```

#### 4. Examples
- Bind a local port to access the postgres service on a remote server.
EOF
}

function on_exit() {
    echo
    echo "<== $(date +%FT%T%:z) received SIGINT, exit."
    exit 0
}

#### 2. configure
local_addr=${local_addr:-localhost}
config=${config:-~/apps/configs/ssh-tunnel.yaml}

case "${1:-""}" in
"" | "help" | "-h" | "--help")
    display_usage
    exit 0
    ;;
"config")
    cat $config
    exit 0
    ;;
esac

if [ $# -lt 2 ]; then
    >&2 echo '!!! Args are required: name <services...>'
    exit 1
fi

ls $config > /dev/null

#### 3. load
name=$1
shift

args=$(yq ".ssh_tunnel.$name._args" $config)

for svc in $@; do
    port=$(yq .ssh_tunnel.$name.$svc.port $config)
    if [[ -z "$port" || "$port" == "null" ]]; then
        >&2 echo '!!! Port is unset in ': .ssh_tunnel.$name.$svc, $config
        exit 1
    fi
done

binds=$(
    for svc in $@; do
        key="ssh_tunnel.$name.$svc"
        port=$(yq .$key.port $config)

        local_port=$(yq .$key'.local_port // "'$port'"' $config)
        host=$(yq .$key'.host // "localhost"' $config)

        echo "-L $local_addr:$local_port:$host:$port"
    done
)

#### 4. run
trap on_exit SIGINT
echo "==> $(date +%FT%T%:z) run"
args="-o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes $args"

echo "+ ssh -N $binds $args"
ssh -N $binds $args
