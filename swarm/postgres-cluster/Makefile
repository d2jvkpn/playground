# make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

up:
	./step01_config.sh && ./step02_run.sh up

tests:
	bash step02_tests.sh

change-password:
	docker exec -it -u postgres postgres-node01 psql -x -c '\password postgres'

hello:
	psql --username=hello --host=127.0.0.1 --port=5441

connect-direct:
	docker exec -it -u postgres postgres-node03 psql --user postgres

connect-local:
	expect connect.expect

down:
	docker-compose down
