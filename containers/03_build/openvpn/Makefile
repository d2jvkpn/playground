image:
	bash deploy/docker_build.sh

image-cn:
	region=cn bash deploy/docker_build.sh

archive:
	mkdir -p data
	docker save kylemanna/openvpn:local -o data/kylemanna_openvpn_local.tar
	pigz -f data/kylemanna_openvpn_local.tar
	ls -alh data/kylemanna_openvpn_local.tar.gz

test:
	nc -uvw1 localhost 1194

connect:
	openvpn --auth-nocache --config configs/client.ovpn --askpass configs/client.ovpn.pass
	openvpn --auth-nocache --config configs/client.ovpn -auth-user-pass configs/client.ovpn.auth
