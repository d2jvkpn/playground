build:
	bash build.sh

build_cn:
	REGION=cn bash build.sh

docker_build:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/deploy/productions/ipython && git pull && bash build.sh"
