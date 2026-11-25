.PHONY: init build compose-build
.DEFAULT_GOAL := init

#COMPOSE_FILE := compose.ubuntu.yaml
IMAGE ?= q.local/ubuntu:dev

proxy :=
build_args ?= --no-cache

init:
	echo "~~~ init: proxy=$(proxy), build_args=\"$(build_args)\""

#compose-build:
#	docker compose -f $(COMPOSE_FILE) build ubuntu

build:
	docker build $(build_args) -f Containerfile \
	--build-arg https_proxy=$(proxy) \
	--build-arg http_proxy=$(proxy) \
	-t $(IMAGE) ./
