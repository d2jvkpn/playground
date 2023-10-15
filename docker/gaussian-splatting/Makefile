build_remote:
	scp -F configs/ssh.conf 3dgs_conda.sh 3dgs_install.sh docker_build.sh \
	  build_host:/home/ubuntu/docker_build/gaussian-splatting

	ssh -F configs/ssh.conf build_host \
	  "cd /home/ubuntu/docker_build/gaussian-splatting && bash docker_build.sh"
