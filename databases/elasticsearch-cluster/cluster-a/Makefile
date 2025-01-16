#### cluster
init:
	container=elastic01 bash elastic-init.sh

elastic01:
	docker-compose -f=compose.elastic01.yaml up -d

check:
	port=9201 container=elastic01 bash elastic-test.sh check

test:
	port=9201 container=elastic01 bash elastic-test.sh test

kibana:
	port=9201 container=elastic01 bash elastic-kibana.sh kibana01

elastic02:
	container=elastic01 bash elastic-node.sh elastic02 9202 172.22.0.12

elastic03:
	container=elastic01 bash elastic-node.sh elastic03 9203 172.22.0.13

up:
	docker-compose -f=compose.cluster.yaml up -d

down:
	docker-compose -f=compose.cluster.yaml down

#### single node
es-init:
	container=es bash elastic-init.sh

es-up:
	docker-compose -f=compose.single.yaml up -d

es-check:
	port=9200 container=es bash elastic-test.sh check

es-test:
	port=9200 container=es bash elastic-test.sh test

es-kibana:
	port=9200 container=es bash elastic-kibana.sh kibana

es-down:
	docker-compose -f=compose.single.yaml down
