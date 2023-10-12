#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# @reboot bash ~/.cron/reverse_proxy.sh local_ssh

name=$1
config=${2:-${_path}/reverse_proxy.yaml}

export AUTOSSH_LOGFILE=${_path}/logs/reverse_proxy.$name.$(date +%Y-%m).log
export AUTOSSH_PIDFILE=${_path}/reverse_proxy.$name.pid

mkdir -p ${_path}/logs

ssh_host=$(yq .ssh_host $config)

ssh_username=$(yq .ssh_username $config)
ssh_ip=$(yq .ssh_ip $config)
ssh_port=$(yq .ssh_port $config)

port_mappings="-R $(yq '.port_mappings | join(" -R ")' reverse_proxy.yaml)"

if [[ "$ssh_host" == "null" || "$ssh_host" == "" ]]; then
    echo "==> reverse_proxy: ssh_username=$ssh_username, ssh_ip=$ssh_ip, ssh_port=$ssh_port"

    autossh -p $ssh_port -f -N $port_mappings \
      -o "ServerAliveInterval 5"    \
      -o "ServerAliveCountMax 2"    \
      -o "ExitOnForwardFailure yes" \
      $ssh_username@$ssh_ip
else
    echo "==> reverse_proxy: ssh_host=$ssh_host"

    autossh -f -N $port_mappings    \
      -o "ServerAliveInterval 5"    \
      -o "ServerAliveCountMax 2"    \
      -o "ExitOnForwardFailure yes" \
      $ssh_host
fi

exit

reverse_proxy.yaml
```yaml
ssh_username: d2jvkpn
ssh_ip: 192.168.1.42
ssh_port: 22

# REMOTE_IP:REMOTE_Port:LOCAL_IP:LOCAL_Port
port_maps:
- localhost:2022:localhost:22
```

reverse_proxy.yaml
```yaml
ssh_host: remote_host

# REMOTE_IP:REMOTE_Port:LOCAL_IP:LOCAL_Port
port_maps:
- localhost:2022:localhost:22
```
