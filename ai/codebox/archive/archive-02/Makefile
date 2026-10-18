# make docker_build build_args="--no-cache"
# build_args := --no-cache
build_base:
	docker build $(build_args) -f Containerfile.base \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/codebox:base ./

# make docker_build build_args="--no-cache"
# build_args := --no-cache
build_latest:
	docker build $(build_args) -f Containerfile.latest \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/codebox:latest ./
