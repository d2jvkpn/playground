#!/bin/make

SHELL = /bin/bash
USER_UID = $(shell id -u)
USER_GID = $(shell id -g)

sh_files := $(wildcard *.sh)
app_env ?= "dev"

nums += 1
nums += 2

echo:
	echo "==> user=${USER}, uid=${USER_UID}, gid=${USER_GID}, nums=${nums}"

sh_files:
	echo "==> sh_files: ${sh_files}"

# app_env=prod make app_env
app_env:
	echo "==> app_env: ${app_env}"
