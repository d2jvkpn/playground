run-local:
	# load config .env.local
	# node_modules/vite/bin/vite.js
	npm run local

run-dev:
	npm run dev

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh main
