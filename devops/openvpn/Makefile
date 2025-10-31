image:
	bash deploy/docker_build.sh

image-cn:
	region=cn bash deploy/docker_build.sh

test:
	nc -uvw1 localhost 1194

connect:
	openvpn --auth-nocache --config configs/client.ovpn --askpass configs/client.ovpn.pass
	openvpn --auth-nocache --config configs/client.ovpn -auth-user-pass configs/client.ovpn.auth
