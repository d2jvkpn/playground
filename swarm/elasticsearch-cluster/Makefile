init:
	bash elastic-init.sh

up:
	docker-compose -f=compose.cluster.yaml up -d

down:
	docker-compose -f=compose.nodes.yaml down
	docker-compose -f=compose.cluster.yaml down

test:
	port=9201 bash elastic-test.sh

node:
	bash elastic-node.sh elastic02 9202
