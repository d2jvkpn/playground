run:
	npm run local

dev:
	npm run dev

build-dev:
	bash ./deployments/build.sh dev

deploy-dev:
	ssh USER@HOST bash -c "cd ~/docker_dev/react-web_dev && docker-compose pull && docker-compose-up -d"
