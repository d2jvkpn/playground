# make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

build_time = $(shell date +'%FT%T%:z')
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
# git_commit_id = $(shell git rev-parse --verify HEAD)
# git_commit_time = $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

# git_tree_state="clean"
# uncommitted=$(git status --short)
# unpushed=$(git diff origin/$git_branch..HEAD --name-status)
# -- [[ ! -z "$uncommitted$unpushed" ]] && git_tree_state="dirty"

app=$(shell yq .app project.yaml)

git-init:
	git remote set-url --add origin git@githubc.com:d2jvkpn/collector.git
	git push --set-upstream origin master
	git branch dev
	git checkout dev
	git push --set-upstream origin dev

go-build:
	bash deployments/go_build.sh

run-local:
	go run main.go --config=configs/local.yaml --addr=0.0.0.0:5021

docker-build:
	# GIT_Pull, DOCKER_Pull
	# REGION=cn bash deployments/docker_build.sh dev
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/$(app) && git pull && bash deployments/docker_build.sh dev"

run-dev:
	ssh remote_dev_server "cd docker_dev/app_dev && docker-compose pull && docker-compose up -d"

go-check:
	go fmt ./...
	go vet ./...
	# git diff
