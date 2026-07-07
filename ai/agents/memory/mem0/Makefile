build_server:
	mkdir -p data
	git clone https://github.com/mem0ai/mem0 data/mem0ai--mem0.git
	docker build \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -f server.Containerfile -t q.local/mem0-server:latest ./

build_dashboard:
	cd ./data/mem0ai--mem0.git/server/dashboard/ && \
	docker build \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -f ./Dockerfile \
	  -t q.local/mem0-dashboard:latest ./

shell:
	docker exec -it mem0-server bash
