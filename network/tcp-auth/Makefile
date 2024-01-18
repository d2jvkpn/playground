compile:
	mkdir -p target

	go fmt bin/client/tcp-auth_client.go
	go fmt bin/server/tcp-auth_server.go

	go build -o target/tcp-auth_client bin/client/tcp-auth_client.go
	go build -o target/tcp-auth_server bin/server/tcp-auth_server.go

client:
	go run bin/client/tcp-auth_client.go

server:
	go run bin/server/tcp-auth_server.go
