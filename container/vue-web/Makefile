run:
	# node_modules/vite/bin/vite.js
	# --mode dev # load config .env.dev
	npm run serve

build:
	#rm -rf dist
	rm -rf target/static
	npm run build -- --dest ./target/static/site # --mode dev
	cp ./target/static/site/index.html ./target/static/

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash containers/build.sh main
