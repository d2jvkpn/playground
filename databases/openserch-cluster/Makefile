up:
	mkdir -p data/opensearch-node01 data/opensearch-node02 data/opensearch-node03
	if [ ! -s compose.yaml ]; then cp compose.template.yaml compose.yaml; fi
	docker-compose -f compose.template.yaml up -d

test:
	bash opensearch-test.sh 9201

down:
	docker-compose -f compose.template.yaml down
