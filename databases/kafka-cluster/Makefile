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
	bash kafka_generate.sh 1

generate-3:
	# kafka_version=4.0.0 make generate
	bash kafka_generate.sh 3
	# bash kafka_generate.sh 3 $(ip route show default | awk '{print $9}')

test:
	bash kafka_test.sh # $(ip route show default | awk '{print $9}')

echo:
	# TAG=0.1.0 make echo
	echo "==> user=${USER}, uid=${USER_UID}, gid=${USER_GID}, tag=${TAG}"

