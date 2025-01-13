init:
	container=es bash ../elastic-init.sh

up:
	docker-compose -f=compose.single.yaml up -d

check:
	port=9200 container=es bash ../elastic-test.sh check

test:
	port=9200 container=es bash ../elastic-test.sh test

kibana:
	port=9200 container=es bash ../elastic-kibana.sh kibana

down:
	docker-compose -f=compose.single.yaml down
