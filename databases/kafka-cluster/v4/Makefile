#!/bin/make

SHELL = /bin/bash
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)

image:
	bash build.sh

image-cn:
	region=cn bash build.sh

generate-1:
	# kafka_version=4.0.0 make generate
	bash generate.sh 1

generate-3:
	# kafka_version=4.0.0 make generate
	bash generate.sh 3

down:
	bash down.sh

echo:
	# TAG=0.1.0 make echo
	echo "==> user=${USER}, uid=${USER_UID}, gid=${USER_GID}, tag=${TAG}"
