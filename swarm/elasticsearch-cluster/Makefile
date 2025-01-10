init:
	bash es-init.sh 3

up:
	docker-compose --env-file=configs/compose.env -f=compose.template.yaml up -d

down:
	docker-compose --env-file=configs/compose.env -f=compose.template.yaml down
