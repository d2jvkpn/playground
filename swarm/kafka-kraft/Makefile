#!/bin/make

TAG = 3.9.0
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)

build-cn:
	region=cn bash build.sh

build-local:
	bash build.sh

generate:
	bash step01_generate.sh

echo:
	echo "==> ${USER_UID}, ${USER_GID}"
