#!/bin/make

SHELL = /bin/bash

build:
	bash deploy/build.sh

run:
	mkdir -p data/apps data/ssh logs
	docker run -d --name=ssh-in-container \
	  -e TZ=Asia/Shanghai -p 2022:22 \
	  -v $(PWD)/data/apps:/root/apps \
	  -v $(PWD)/data/ssh:/root/.ssh \
	  -v $(PWD)/logs:/var/log \
	  ssh-in-container:local

compose:
	mkdir -p data/apps data/ssh logs
	if [ ! -s compose.yaml ]; then cp deploy/compose.template.yaml compose.yaml; fi
	docker-compose up -d

exec:
	docker exec -it ssh-in-container bash

connect:
	ssh-keyscan -p 2022 -H ssh-in-container,127.0.0.1 > configs/ssh.known_hosts
	docker exec ssh-in-container chown -R root:root /root/.ssh
	ssh -F configs/ssh.conf ssh-in-container
