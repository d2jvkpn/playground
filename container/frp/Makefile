image:
	BUILD_Region=cn bash docker_build.sh

client:
	bash docker_deploy.sh client

server:
	bash docker_deploy.sh server

tls:
	server_ip=127.0.0.1 bash frp_tls.sh
