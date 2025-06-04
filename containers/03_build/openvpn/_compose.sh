#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# https://github.com/kylemanna/docker-openvpn
host=$1 # ip or domain
port=$2 # 1194

#### 1. initialize
# rm -r data/openvpn/
mkdir -p data/openvpn logs

# local/openvpn:dev
docker run --rm -it -v $PWD/data/openvpn:/etc/openvpn \
  -e EASYRSA_KEY_SIZE=4096 \
  local/openvpn:dev \
  bash -c "ovpn_genconfig -u udp://$host && ovpn_initpki"

sudo sed -i "/OVPN_PORT=/s/1194/$port/" data/openvpn/ovpn_env.sh
sudo sed -i "/^port /s/1194/$port/" data/openvpn/openvpn.conf
sudo mkdir -p data/openvpn/ccd
# TODO: replace 192.168.255.0/24

cat | sudo tee -a data/openvpn/openvpn.conf <<EOF

#### custom
client-config-dir      /etc/openvpn/ccd
log-append             /apps/logs/openvpn.log
ifconfig-pool-persist  /etc/openvpn/ifconfig-pool-persist.txt 3600
# client-connect        /apps/target/client_connect.sh
# client-disconnect     /apps/target/client_disconnect.sh
# push                  "redirect-gateway def1 bypass-dhcp"
EOF

# Enter New CA Key Passphrase:
# Re-Enter New CA Key Passphrase: hello
# Common Name(...): $host
# Enter pass phrase for /etc/openvpn/pki/private/ca.key: hello


#### 2. deploy
USER_UID=$(id -u) USER_GID=$(id -g) UDP_Port=$port \
  envsubst < ${_dir}/compose.server-host.yaml > compose.yaml
# envsubst < ${_dir}/compose.server-bridge.yaml > compose.yaml


#### 3. Run and NAT
exit
docker-compose up -d

iptables -A FORWARD -i tun0 -j ACCEPT   # up command, traffic in
iptables -A FORWARD -o tun0 -j ACCEPT   # up command, traffic out
# iptables -D FORWARD -i tun0 -j ACCEPT # down command
# iptables -D FORWARD -o tun0 -j ACCEPT # down command

device=$(ip route | awk '/^default /{print $5}')
cdir=192.168.255.0/24
iptables -t nat -A POSTROUTING -s $cdir -o $device -j MASQUERADE # up command
#iptables -t nat -D POSTROUTING -s $cdir -o $device -j MASQUERADE # down command

iptables -t nat -L -n -v

ip route get 8.8.8.8 | awk '{print $5}'
tcpdump -i $device port $port

# ?? sudo ip route add 192.168.1.0/24 via 10.8.0.1 dev tun0

#### 4. create a client
exit

container=$(yq .services.openvpn.container_name compose.yaml)
account=d2jvkpn

# docker exec -it $container easyrsa build-client-full $account nopass
docker exec -it $container easyrsa build-client-full $account
# TODO:

docker exec -it $container ovpn_getclient $account > $account.ovpn

sudo openvpn --config data/$account.ovpn
# --route-noexec --route-nopull
# --verb 4
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


#### 7. fix ip of client
exit
grep "^server " /etc/openvpn/openvpn.conf # server 192.168.255.0 255.255.255.0
echo "ifconfig-push 192.168.255.4 192.168.255.1" > /etc/openvpn/ccd/client1


#### 8. firewall and network
exit

sudo ufw allow 1194/udp
sudo sysctl -w net.ipv4.ip_forward=1

####
sysctl net.ipv4.ip_forward
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sysctl -p
