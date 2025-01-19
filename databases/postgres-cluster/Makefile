#!/bin/make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

up:
	bash ./bin/postgres_config.sh
	docker-compose up -d

test:
	bash bin/postgres_test.sh

set-password:
	bash bin/postgres_set-password.sh

down:
	docker-compose down

hello:
	psql --username=hello --host=127.0.0.1 --port=5441

connect-direct:
	docker exec -it -u postgres postgres-node03 psql --user postgres

connect-local:
	./connect.exp
