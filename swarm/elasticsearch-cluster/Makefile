init:
	bash elastic-init.sh

up:
	docker-compose -f=compose.cluster.yaml up -d

down:
	ls compose.*.local 2> /dev/null | xargs -i docker-compose -f={} down || true
	docker-compose -f=compose.cluster.yaml down

test:
	port=9201 bash elastic-test.sh

elastic02:
	bash elastic-node.sh elastic02 9202

elastic03:
	bash elastic-node.sh elastic03 9203

kibana:
	bash elastic-kibana.sh
