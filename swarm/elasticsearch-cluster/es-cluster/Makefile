init:
	bash elastic-init.sh 3

up:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml up -d

down:
	docker-compose --env-file=configs/compose.env -f=compose.elastic.yaml down

test:
	bash elastic-test.sh configs/elastic.yaml
