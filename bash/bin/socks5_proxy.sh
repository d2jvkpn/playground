#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# @reboot ~/.cron/socks5_proxy.sh start

function start {
    host=$1; port=$2

    # export AUTOSSH_LOGFILE=$(readlink -f $0).$(date +%F_%s).log
    export AUTOSSH_LOGFILE=${_path}/logs/socks5_proxy.$port.$(date +%Y-%m).log
    export AUTOSSH_PIDFILE=${_path}/socks5_proxy.$port.pid
    mkdir -p ${_path}/logs

    echo "==> autossh socks5 proxy: host=$host, port=$port"
    # -M 2000:2001
    autossh -f -NC -D $port \
      -o "ServerAliveInterval 5"    \
      -o "ServerAliveCountMax 2"    \
      -o "ExitOnForwardFailure yes" \
      $host
}

function stop {
    port=$1
    pid_file=${_path}/socks5_proxy.$port.pid
    [ ! -f $pid_file ] && return

    pid=$(cat $pid_file)
    if [[ "$(cat /proc/$pid/cmdline | xargs -0 echo)" == *autossh* ]]; then
       echo "==> killing process: $pid"
       kill $pid
    else
       2&>1 echo "==> not a process created by autossh: $pid"
       exit 1
    fi
}


cmd=$1
config=${2:-${_path}/socks5_proxy.yaml}

case $cmd in
"start")
    for e in $(yq '.socks5_proxy[] | .host + ":" + .port' $config); do
        start $(echo $e | sed 's/:/ /')
    done
    ;;
"stop")
    for port in $(yq .socks5_proxy[].port $config); do
        stop $port
    done
    ;;
*)
    2>&1 echo "unknown cmd: $cmd"
    exit 1;
esac

exit

${_path}/socks5_proxy.yaml
```yaml
socks5_proxy:
- { host: host, port: 1080 }
- { host: host-01, port: 1081 }
```