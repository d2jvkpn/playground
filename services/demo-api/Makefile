#/bin/make
# include envfile
# export $(shell sed 's/=.*//' envfile)

work_dir = $(shell pwd)
build_hostname = $(shell hostname)

build_time = $(shell date +'%FT%T.%N%:z')
git_repository = $(shell git config --get remote.origin.url)
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
git_commit_id = $(shell git rev-parse --verify HEAD)
git_commit_time = $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

go:
	go mod tidy
	if [ -d vendor ]; then go mod vendor; fi
	go fmt ./...
	go vet ./...

swag-update:
	@if [ ! -d "swagger-go" ]; then \
	    git clone git@github.com:d2jvkpn/swagger-go.git /tmp/swagger-go; \
	    rsync -arvP --exclude .git /tmp/swagger-go ./; \
	    rm -rf /tmp/swagger-go; \
	fi
	bash swagger-go/swag.sh

swag-run:
	bash swagger-go/swag.sh
	./swagger-go/target/swagger-go

#### run and build
run:
	go run main.go -config=configs/local.yaml -http.addr=0.0.0.0:5031 -rpc.addr=0.0.0.0:5041

site-text:
	mkdir -p site
	date  +"Hello, world, %FT%T%:z!" > site/a01.txt

protoc-run:
	protoc --go-grpc_out=./ --go_out=./ --proto_path=./proto proto/*.proto
	sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go

build-bin:
	bash deployments/go_build.sh
#	mkdir -p target

#	@go build -ldflags="-w -s \
#	  -X main.build_hostname=$(build_hostname) \
#	  -X main.build_time=$(build_time) \
#	  -X main.git_repository=$(git_repository) \
#	  -X main.git_branch=$(git_branch) \
#	  -X main.git_commit_id=$(git_commit_id) \
#	  -X main.git_commit_time=$(git_commit_time)" \
#	  -o target/swagger-go main.go

image-local:
	GIT_Pull=false BUILD_Region=cn DOCKER_Pull=false DOCKER_Tag=dev \
	  time bash deployments/docker_build.sh master

image-dev:
	# BUILD_Region=cn DOCKER_Tag=dev bash deployments/docker_build.sh master
	DOCKER_Tag=dev \
	  time bash deployments/docker_build.sh master

image-remote:
	ssh -F configs/ssh.conf build_host "cd docker_build/playground/demo-api && \
	  git pull && DOCKER_Tag=dev bash deployments/docker_build.sh master"

deploy_dev:
	dryp_run=true bash deployments/docker_deploy.sh dev 5032 5042

#### database
create-db:
	echo "TODO: ..."

connect-db:
	echo "TODO: ..."
