#!/bin/make

SHELL = /bin/bash

build:
	bash build.sh

run:
	mkdir -p apps.local/ssh logs
	docker run -d --name=ubuntu-ssh \
	  -e TZ=Asia/Shanghai -p 2022:22 \
	  -v $(PWD)/apps.local:/root/apps \
	  -v $(PWD)/logs:/var/log \
	  ubuntu-ssh:local
