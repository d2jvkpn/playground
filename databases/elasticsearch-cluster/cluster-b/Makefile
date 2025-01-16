pull:
	docker-compose --env-file=compose.env -f=compose.elastic.yaml pull

init:
	bash elastic-init.sh elastic

up:
	docker-compose --env-file=compose.env -f=compose.elastic.yaml up -d

check:
	bash elastic-test.sh configs/elastic.yaml check

test:
	bash elastic-test.sh configs/elastic.yaml test

kibana:
	bash elastic-kibana.sh

down:
	docker-compose --env-file=compose.env -f=compose.elastic.yaml down
