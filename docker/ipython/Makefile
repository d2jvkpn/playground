wd = $(shell pwd)
# user = $(shell id -u):$(shell id -g)
user = $(shell id -u)
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

	docker run -d -v $(wd)/data:/app/data --user $(user) --name ipython \
	  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev sleep infinity

ipython-cli:
	mkdir -p data

	docker run --rm -it -v $(wd)/data:/app/data --user $(user) --name $(container_name) \
	  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev ipython
