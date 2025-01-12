init:
	container=es kibana=kibana bash ../elastic-init.sh

up:
	docker-compose -f=compose.single.yaml up -d

down:
	docker-compose -f=compose.single.yaml down

test:
	port=9200 container=es bash ../elastic-test.sh

kibana:
	port=9200 container=es kibana=kibana bash ../elastic-kibana.sh
