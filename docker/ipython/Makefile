build_local:
	bash docker_build.sh

build_cn:
	REGION=cn bash docker_build.sh

build_remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/docker/ipython && git pull && bash docker_build.sh"

ipython:
	mkdir -p data

	docker run --rm -it -v $(shell pwd)/data:/app/data \
	  --name ipython_$(shell tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 8 | head -n1) \
	  registry.cn-shanghai.aliyuncs.com/d2jvkpn/ipython:dev ipython
