init:
	bash elastic-init.sh elastic.template.yaml 172.24.0

up:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml up -d

check:
	bash elastic-test.sh configs/elastic.yaml check

test:
	bash elastic-test.sh configs/elastic.yaml test

kibana:
	bash elastic-kibana.sh

down:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml down
