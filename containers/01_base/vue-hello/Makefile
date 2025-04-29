#!/bin/make

#include .env

SHELL = /bin/bash

run:
	# node node_modules/vite/bin/vite.js --help
	npm run dev -- --port=${PORT} --host=0.0.0.0 # --mode dev

build:
	rm -rf target/dist
	# node node_modules/vite/bin/vite.js build --help
	npm run build -- --base=${VITE_BASE} --outDir=target/dist${VITE_BASE} # --mode dev
	ls -alt target/dist

image-local:
	region=cn GIT_Pull=false DOCKER_Pull=false DOCKER_Push=false bash deploy/build.sh local

image-dev-cn:
	region=cn DOCKER_Pull=false DOCKER_Push=false bash deploy/build.sh dev

image-dev:
	DOCKER_Pull=false DOCKER_Push=false bash deploy/build.sh dev

image-test:
	DOCKER_Pull=false DOCKER_Push=false bash deploy/build.sh test

image-main:
	DOCKER_Pull=false DOCKER_Push=false bash deploy/build.sh main
