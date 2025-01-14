init:
	bash elastic-init.sh elastic.template.yaml

up:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml up -d

test:
	bash elastic-test.sh configs/elastic.yaml

kibana:
	bash elastic-kibana.sh

down:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml down
