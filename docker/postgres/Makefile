connect:
	docker exec -it --tty $(shell yq .services.postgres.container_name docker-compose.yaml) \
	  psql postgres://postgres@localhost:5432/postgres
