#!/bin/make
include local.env
SHELL = /bin/bash
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)

sh_files := $(wildcard *.sh)
app_env ?= "dev"

nums += 1
nums += 2

echo:
	echo "==> user=${USER}, uid=${USER_UID}, gid=${USER_GID}, nums=${nums}, VENV=${VENV}"

sh_files:
	echo "==> sh_files: ${sh_files}"

# app_env=prod make app_env
app_env:
	echo "==> app_env: ${app_env}"

COMMIT_HASH := $(shell git rev-parse HEAD)
COMMIT_TIME := $(shell git log -1 --format=%cI)
BRANCH      := $(shell git rev-parse --abbrev-ref HEAD)
BUILT_AT    := $(shell date -Iseconds)
GIT_STATUS  := $(shell git status --porcelain | grep -q . && echo dirty || echo clean)
