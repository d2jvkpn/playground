TAG = 3.6.0
UserID = $(shell id -u)
GroupID = $(shell id -g)

build-cn:
	REGION=cn bash docker_build.sh

build-remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/swarm/kafka_kraft && git pull && bash docker_build.sh"

echo:
	echo ${GroupID}, ${UserID}
