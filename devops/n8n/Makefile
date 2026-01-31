build-1:
	docker build -f Containerfile.v1 --no-cache -t local/n8nio/n8n:1 ./

build-2:
	docker build -f Containerfile.v2 --no-cache -t local/n8nio/n8n:2 ./

run:
	mkdir -p data/bin data/n8n_data data/n8n_workspace
	cp compose.sqlite.yaml compose.yaml
	docker compose up -d
