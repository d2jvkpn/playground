#!/bin/make

SHELL = /bin/bash
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)

build-cn:
	region=cn bash build.sh

build:
	bash build.sh

generate:
	bash generate.sh

down:
	bash down.sh

echo:
	# TAG=0.1.0 make echo
	echo "==> user=${USER}, uid=${USER_UID}, gid=${USER_GID}, tag=${TAG}"
