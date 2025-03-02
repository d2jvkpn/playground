up:
	mkdir -p data/opensearch-node01 data/opensearch-node02 data/opensearch-node03
	if [ ! -s compose.yaml ]; then cp compose.template.yaml compose.yaml; fi
	docker-compose -f compose.yaml up -d

down:
	docker-compose down
