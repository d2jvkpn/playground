wd = $(shell pwd)
# user = $(shell id -u):$(shell id -g)
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)
container_name = ipython_$(shell tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 8 | head -n1)

build-local:
	bash docker_build.sh

build-cn:
	BUILD_Region=cn bash docker_build.sh

build-remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/docker/ipython && git pull && bash docker_build.sh"

ipython-container:
	mkdir -p data

	docker run -d --name ipython -v $(wd)/data:/app/data \
	  --user $(USER_UID):$(USER_GID) -v USER_GID=$(USER_GID) \
	  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev sleep infinity

ipython-cli:
	mkdir -p data

	docker run --rm -it --name $(container_name) -v $(wd)/data:/app/data \
	  --user $(USER_UID):$(USER_GID) -v USER_GID=$(USER_GID) \
	  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev ipython
