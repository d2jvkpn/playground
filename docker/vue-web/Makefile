run-local:
	# load config .env.local
	# node_modules/vite/bin/vite.js
	npm run local

run-dev:
	# load config .env.dev
	npm run dev

build-dev:
	npm run build

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash deployments/docker_build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash deployments/docker_build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash deployments/docker_build.sh main
