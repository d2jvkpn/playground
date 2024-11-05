create:
	docker run --name mongo -p 127.0.0.1:27017:27017 \
	  -e MONGO_INITDB_ROOT_USERNAME=root \
	  -e MONGO_INITDB_ROOT_PASSWORD=root \
	  -d mongo:6
	# >>> # >>> run conatiner by docker-compose
	#$ docker-compose -f docker-compose.yaml up -d
	docker exec -it mongo mongosh --username root --password root --eval \
	  'db = db.getSiblingDB("admin"); db.changeUserPassword("root", passwordPrompt())'

connect:
	docker exec -it mongo mongosh --username root --password
