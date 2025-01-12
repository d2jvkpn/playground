init:
	container=elastic01 kibana=kibana01 bash elastic-init.sh

up:
	docker-compose -f=compose.cluster.yaml up -d

down:
	ls compose.*.local 2> /dev/null | xargs -i docker-compose -f={} down || true
	docker-compose -f=compose.cluster.yaml down

test:
	port=9201 container=elastic01 bash elastic-test.sh

elastic02:
	container=elastic01 bash elastic-node.sh elastic02 9202

elastic03:
	container=elastic01 bash elastic-node.sh elastic03 9203

kibana:
	port=9201 container=elastic01 kibana=kibana01 bash elastic-kibana.sh
