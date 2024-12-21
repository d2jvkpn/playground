run:
	# node_modules/vite/bin/vite.js
	# --mode dev # load config .env.dev
	npm run serve

build:
	rm -rf dist
	# --mode dev
	npm run build -- --dest ./dist/static

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh main
