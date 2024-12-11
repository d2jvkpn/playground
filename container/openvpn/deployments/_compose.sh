#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://github.com/kylemanna/docker-openvpn
server=${1:-127.0.0.1}
UDP_Port=${2:-1194}

export USER_UID=$(id -u) USER_GID=$(id -g) UDP_Port=$UDP_Port

#### 1. initialize
# rm -r data/openvpn/
mkdir -p data/openvpn logs

# -e EASYRSA_KEY_SIZE=4096
# kylemanna/openvpn:latest
docker run --rm -it -v $PWD/data/openvpn:/etc/openvpn \
  kylemanna/openvpn:local \
  bash -c "ovpn_genconfig -u udp://$server && ovpn_initpki"

sudo sed -i "/OVPN_PORT=/s/1194/$UDP_Port/" data/openvpn/ovpn_env.sh

sudo sed -i "/^port /s/1194/$UDP_Port/" data/openvpn/openvpn.conf

echo -e "\n#### custom\nlog-append /apps/logs/openvpn.log" |
  sudo tee -a data/openvpn/openvpn.conf

# Enter New CA Key Passphrase:
# Re-Enter New CA Key Passphrase: hello
# Common Name(...): $server
# Enter pass phrase for /etc/openvpn/pki/private/ca.key: hello

#### 2. deploy
envsubst < ${_path}/compose.bridge.yaml > compose.yaml

#### 3. run
exit
docker-compose up -d

#### 4. build client
exit

container=$(yq .services.openvpn.container_name compose.yaml)
account=d2jvkpn

# docker exec -it $container easyrsa build-client-full $account nopass
docker exec -it $container easyrsa build-client-full $account

docker exec -it $container ovpn_getclient $account > $account.ovpn

sudo openvpn --config data/$account.ovpn
# ... Initialization Sequence Completed

#### 5. connect
exit

cat > ${account}.ovpn.pass <<EOF
123456
EOF

sudo openvpn --config $account.ovpn --auth-nocache --askpass ${account}.ovpn.pass
# ... Initialization Sequence Completed

#### 6. revoke client
exit

docker exec -it $container easyrsa revoke $account
# docker exec $container ls /etc/openvpn/pki/issued
docker exec -it $container easyrsa gen-crl
docker restart $container
# sudo openvpn --config data/$account.ovpn

#### 6. firewall and network
exit

sudo ufw allow 1194/udp
sudo sysctl -w net.ipv4.ip_forward=1
