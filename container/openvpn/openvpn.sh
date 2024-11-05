#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://github.com/kylemanna/docker-openvpn
server=$1
UDP_Port=${2:-1194}

#### 1. initialize
mkdir -p data/openvpn

docker run --rm -v $PWD/data/openvpn:/etc/openvpn kylemanna/openvpn:latest \
  ovpn_genconfig -u udp://$server

# -e EASYRSA_KEY_SIZE=4096
docker run --rm -it -v $PWD/data/openvpn:/etc/openvpn \
  kylemanna/openvpn:latest ovpn_initpki

# Enter New CA Key Passphrase:
# Re-Enter New CA Key Passphrase: hello
# Common Name(...): $server
# Enter pass phrase for /etc/openvpn/pki/private/ca.key: hello

#### 2. deploy
export USER_UID=$(id -u) USER_GID=$(id -g) UDP_Port=$UDP_Port
envsubst < container_deploy.yaml > docker-compose.yaml

#### 3. run
exit
docker-compose up -d

#### 4. build client
container=$(yq .services.openvpn.container_name docker-compose.yaml)
account=d2jvkpn

docker exec -it $container easyrsa build-client-full $account nopass

docker run -v $PWD/data/openvpn:/etc/openvpn --rm \
  kylemanna/openvpn:latest ovpn_getclient $account > data/$account.ovpn

sudo openvpn --config data/$account.ovpn
# ... Initialization Sequence Completed

#### 5. revoke client
docker exec -it $container easyrsa revoke $account
# docker exec $container ls /etc/openvpn/pki/issued
docker exec -it $container easyrsa gen-crl
docker restart $container
# sudo openvpn --config data/$account.ovpn

#### 6. firewall and network
sudo ufw allow 1194/udp
sudo sysctl -w net.ipv4.ip_forward=1
