pull:
	docker-compose -f=compose.template.yaml pull

init:
	bash elastic-init.sh elastic

up:
	#docker-compose --env-file=compose.env -f=compose.template.yaml up -d
	docker-compose -f=compose.template.yaml up -d

check:
	bash elastic-test.sh configs/elastic.yaml check

test:
	bash elastic-test.sh configs/elastic.yaml test

kibana:
	bash elastic-kibana.sh

down:
	docker-compose -f=compose.template.yaml down
