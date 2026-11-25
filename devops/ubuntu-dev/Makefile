COMPOSE_FILE := compose.ubuntu.yaml
IMAGE ?= q.local/ubuntu:dev
build_args ?= --no-cache

.PHONY: build compose-build

build:
	docker build $(build_args) -f Containerfile -t $(IMAGE) ./

#compose-build:
#	docker compose -f $(COMPOSE_FILE) build ubuntu
