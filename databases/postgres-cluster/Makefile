#!/bin/make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

init:
	bash ./bin/postgres_config.sh

up:
	docker-compose up -d

test:
	bash bin/postgres_test.sh

reset-password:
	bash bin/postgres_reset-password.sh

down:
	docker-compose down

hello:
	psql --username=hello --host=127.0.0.1 --port=5441

connect:
	./connect.exp

connect-container:
	docker exec -it -u postgres postgres-node03 psql --user postgres
