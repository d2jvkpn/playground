TAG = 3.7.0
UserID = $(shell id -u)
GroupID = $(shell id -g)

build-cn:
	BUILD_Region=cn bash docker_build.sh

build-local:
	bash docker_build.sh

build-remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/swarm/kafka_kraft && git pull && bash docker_build.sh"

generate:
	bash step01_generate.sh

echo:
	echo ${GroupID}, ${UserID}
