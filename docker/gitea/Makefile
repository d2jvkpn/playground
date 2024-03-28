docker_up:
	bash docker_deploy.sh

remove_password:
	docker-compose down
	sed 's/env_file: /# env_file: /' docker-compose.yaml
	docker-compose up -d
	# rm -f configs/gitea.env
