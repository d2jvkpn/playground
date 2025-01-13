init:
	container=elastic01 kibana=kibana01 bash elastic-init.sh

elastic01:
	docker-compose -f=compose.elastic01.yaml up -d

check:
	port=9201 container=elastic01 bash elastic-test.sh check

test:
	port=9201 container=elastic01 bash elastic-test.sh test

kibana:
	port=9201 container=elastic01 kibana=kibana01 bash elastic-kibana.sh

elastic02:
	container=elastic01 bash elastic-node.sh elastic02 9202 172.22.0.12

elastic03:
	container=elastic01 bash elastic-node.sh elastic03 9203 172.22.0.13

up:
	docker-compose -f=compose.cluster.yaml up -d

down:
	docker-compose -fcompose.cluster.yaml down
