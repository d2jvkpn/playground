build:
	bash deployments/build.sh

save:
	mkdir -p data
	docker save kylemanna/openvpn:local -o data/kylemanna_openvpn_local.tar
	pigz -f data/kylemanna_openvpn_local.tar

test:
	nc -uvw1 localhost 1194
