
# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

build_time = $(shell date +'%FT%T.%N%:z')
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
# git_commit_id = $(shell git rev-parse --verify HEAD)
# git_commit_time = $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

go:
	go mod tidy
	if [ -d vendor ]; then go mod vendor; fi
	go fmt ./...
	go vet ./...
	bash scripts/swagger.sh

#### run and build
run:
	# -config=configs/local.yaml
	go run main.go -http_addr=0.0.0.0:5031 -rpc_addr=0.0.0.0:5041

check:
	go fmt ./...
	go vet ./...

site:
	mkdir -p site
	echo "Hello, world!" > site/a.txt

protoc-run:
	protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto
	sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go

build-bin:
	bash scripts/go_build.sh

build-offline:
	GIT_Pull=false BUILD_Region=cn DOCKER_Pull=false DOCKER_Tag=dev \
	bash deployments/docker_build.sh master

build-local:
	# BUILD_Region=cn DOCKER_Tag=dev bash deployments/docker_build.sh master
	DOCKER_Tag=dev bash deployments/docker_build.sh master

build-remote:
	ssh -F configs/ssh.conf build_host "cd docker_build/playground/demo-api && \
	  git pull && DOCKER_Tag=dev bash deployments/docker_build.sh master"

#### database
create-db:
	echo "TODO: ..."

docker-dev:
	bash scripts/docker_dev.sh
connect-db:
	echo "TODO: ..."
