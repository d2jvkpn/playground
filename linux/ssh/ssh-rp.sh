#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)


#### 1. functionss
function display_usage() {
>&2 cat <<'EOF'
Usage of ssh-rp.sh

#### 1. Run
- local_addr=127.0.0.1 ssh-rp.sh <name> <services...>
- ssh-rp.sh ali postgres redis
- ssh-rp.sh config

#### 2. environment variables
local_addr=localhost
config=~/apps/configs/ssh.yaml

#### 3. Configuration file:
```yaml
aws:
  _args: -F /path/to/ssh.conf remote_host
  kibana: { port: 5601, host: 127.0.0.1, local_port: 5601 }
  kafka: { port: 9092 }

ali:
  _command: sshpass -F configs/ssh.pass ssh
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
config=${config:-~/apps/configs/ssh-rp.yaml}

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

if [ $# -eq 1 ]; then
   name=$1
   yq ".$name" $config
   exit 0
elif [ $# -lt 2 ]; then
    >&2 echo '!!! Args are required: name <services...>'
    exit 1
fi

ls $config > /dev/null

#### 3. load
name=$1
shift

command=$(yq ".$name._command" $config)
if [[ "$command" == "null" ]]; then
    command="ssh"
fi
args=$(yq ".$name._args" $config)

for svc in $@; do
    port=$(yq .$name.$svc.port $config)
    if [[ -z "$port" || "$port" == "null" ]]; then
        >&2 echo '!!! Port is unset in ': .$name.$svc, $config
        exit 1
    fi
done

binds=$(
    for svc in $@; do
        key="$name.$svc"
        port=$(yq .$key.port $config)

        local_port=$(yq .$key'.local_port // "'$port'"' $config)
        host=$(yq .$key'.host // "localhost"' $config)

        echo "--> $svc: $local_port -> $host:$port" >&2
        echo "-L $local_addr:$local_port:$host:$port"
    done
)

#### 4. run
function on_exit() {
    echo -e "\n==> $(date +%FT%T%:z) Exit"
}

trap on_exit SIGINT
echo "==> $(date +%FT%T%:z) Starting"
args="-o TCPKeepAlive=yes -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes $args"

#echo "+ $command -N $binds $args"
$command -N $binds $args
