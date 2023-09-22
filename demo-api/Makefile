# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

build_time = $(shell date +'%FT%T.%N%:z')
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
# git_commit_id = $(shell git rev-parse --verify HEAD)
# git_commit_time = $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

#### run and build
run:
	go run main.go -config=configs/local.yaml -http_addr=0.0.0.0:5031 -rpc_addr=0.0.0.0:5041

protoc_run:
	protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto

protoc_impl:
	sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go
	go fmt ./... && go vet ./...

build_bin:
	bash scripts/go_build.sh

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
	echo "TODO: ..."

connect-db:
	echo "TODO: ..."
