#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


# https://github.com/kylemanna/docker-openvpn
host=$1 # ip or domain
port=$2 # 1194

#### 1. initialize
# rm -r data/openvpn/
mkdir -p data/openvpn logs

# kylemanna/openvpn:latest
docker run --rm -it -v $PWD/data/openvpn:/etc/openvpn \
  -e EASYRSA_KEY_SIZE=4096 \
  kylemanna/openvpn:local \
  bash -c "ovpn_genconfig -u udp://$host && ovpn_initpki"

sudo sed -i "/OVPN_PORT=/s/1194/$port/" data/openvpn/ovpn_env.sh
sudo sed -i "/^port /s/1194/$port/" data/openvpn/openvpn.conf

cat | sudo tee -a data/openvpn/openvpn.conf <<EOF

#### custom
log-append /apps/logs/openvpn.log
ifconfig-pool-persist /etc/openvpn/ifconfig-pool-persist.txt 3600
EOF

# Enter New CA Key Passphrase:
# Re-Enter New CA Key Passphrase: hello
# Common Name(...): $host
# Enter pass phrase for /etc/openvpn/pki/private/ca.key: hello

#### 2. deploy
USER_UID=$(id -u) USER_GID=$(id -g) UDP_Port=$port \
  envsubst < ${_path}/compose.server-host.yaml > compose.yaml
# envsubst < ${_path}/compose.server-bridge.yaml > compose.yaml

#### 3. run
exit
docker-compose up -d

#### 4. build client
exit

container=$(yq .services.openvpn.container_name compose.yaml)
account=d2jvkpn

# docker exec -it $container easyrsa build-client-full $account nopass
docker exec -it $container easyrsa build-client-full $account
# TODO:

docker exec -it $container ovpn_getclient $account > $account.ovpn

sudo openvpn --config data/$account.ovpn
# ... Initialization Sequence Completed

ls data/openvpn/pki/issued/$account.crt \
  data/openvpn/pki/private/$account.key \
  data/openvpn/pki/reqs/$account.req \
  data/openvpn/pki/inline/private/$account.inline

#### 5. connect
exit

cat > ${account}.ovpn.pass <<EOF
123456
EOF

sudo openvpn --config $account.ovpn --auth-nocache --askpass ${account}.ovpn.pass
# ... Initialization Sequence Completed

grep "Peer Connection Initiated with" logs/openvpn.log

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
