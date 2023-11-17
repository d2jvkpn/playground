build_local:
	bash docker_build.sh

build_cn:
	REGION=cn bash docker_build.sh

build_remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/docker/ipython && git pull && bash docker_build.sh"
