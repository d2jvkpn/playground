init:
	bash cluster-init.sh 3

up:
	docker-compose --env-file=configs/compose.env -f=compose.cluster.yaml up -d

down:
	docker-compose --env-file=configs/compose.env -f=compose.cluster.yaml down

test:
	bash cluster-test.sh configs/elastic.yaml
