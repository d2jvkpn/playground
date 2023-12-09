wk_path = $(/home/ubuntu/docker_build)

build_remote:
	scp -F configs/ssh.conf -r bin/ docker_build.sh build_host:$(wk_path)/gaussian-splatting

	ssh -F configs/ssh.conf build_host "cd $(wk_path) && bash docker_build.sh"
