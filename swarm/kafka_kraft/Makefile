build:
	bash build.sh

build-cn:
	REGION=cn bash build.sh

build-remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/deploy/swarm/kafka_kraft && git pull && bash build.sh"

create-single:
	echo ">>> create a kafka cluster with 1 node"
	cp deploy_single-node.yaml docker-compose.yaml
	docker-compose up -d

create-triple:
	echo ">>> create a kafka cluster with 3 nodes"
	cp deploy_external.yaml docker-compose.yaml
	docker-compose up -d
