# make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

init:
	echo yes | bash step05_down.sh
	bash step01_generate.sh
	bash step02_up.sh

config:
	bash step03_config.sh

up:
	docker-compose up -d

tests:
	bash step04_tests.sh

connect:
	expect connect.exp

down:
	echo no | bash step05_down.sh
