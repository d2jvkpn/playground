build:
	bash containers/build.sh

build-cn:
	BUILD_Region=cn bash containers/build.sh

archive:
	mkdir -p data
	docker save kylemanna/openvpn:local -o data/kylemanna_openvpn_local.tar
	pigz -f data/kylemanna_openvpn_local.tar
	ls -alh data/kylemanna_openvpn_local.tar.gz

test:
	nc -uvw1 localhost 1194

connect:
	bash openvpn_conn.sh configs/client.ovpn configs/client.ovpn.pass
