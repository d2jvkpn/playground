include .env

run:
	# node node_modules/@vue/cli-service/bin/vue-cli-service.js serve --help
	npm run serve -- --port=$(PORT) --host=0.0.0.0

build:
	#rm -rf dist
	rm -rf target/static
	npm run build -- --dest ./target/static$(VUE_APP_PUBLIC_PATH) # --mode dev

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh main
