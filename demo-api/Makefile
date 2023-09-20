# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

build_time = $(shell date +'%FT%T%:z')
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
# git_commit_id = $(shell git rev-parse --verify HEAD)
# git_commit_time = $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

#### run
run:
	go run main.go --config=configs/local.yaml --addr=0.0.0.0:5031

run-dev:
	echo "TODO"

protoc:
	protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto

#### build
build:
	echo ">>> git branch: $(git_branch)"
	mkdir -p target
	go build -o target/main -ldflags="-X main.build_time=$(build_time) \
	  -X main.git_branch=$(git_branch) -X main.git_commit_id=unknown" main.go

build_offline:
	GIT_Pull=false BUILD_Region=cn DOCKER_Pull=false DOCKER_Tag=dev \
	bash scripts/docker_build.sh master

build_local:
	BUILD_Region=cn DOCKER_Tag=dev bash deployments/docker_build.sh master

build_remote:
	ssh -F configs/ssh.conf build_host "cd docker_build/playground/demo-api && \
	  git pull && DOCKER_Tag=dev bash deployments/docker_build.sh master"

#### database
create-db:
	echo "TODO"

connect-db:
	echo "TODO"
