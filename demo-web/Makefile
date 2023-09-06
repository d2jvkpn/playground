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

#### build
build:
	echo ">>> git branch: $(git_branch)"
	mkdir -p target
	go build -o target/main -ldflags="-X main.build_time=$(build_time) \
	  -X main.git_branch=$(git_branch) -X main.git_commit_id=unknown" main.go

docker_build:
	GIT_Pull=false DOCKER_Pull=false REGION=cn bash deployments/docker_build.sh master

docker_build_remote:
	ssh -F configs/ssh.conf build_host \
	  "cd docker_build/playground/demo-web && git pull && bash deployments/docker_build.sh master"

#### database
create-db:
	echo "TODO"

connect-db:
	echo "TODO"
