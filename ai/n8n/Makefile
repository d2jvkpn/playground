build:
	docker build -f Containerfile --no-cache -t local/n8nio/n8n:stable ./

run:
	mkdir -p data/bin data/n8n_data data/n8n_workspace
	cp compose.sqlite.yaml compose.yaml
	docker compose up -d
