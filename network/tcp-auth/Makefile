compile:
	mkdir -p target

	go fmt bin/tcp-auth_client/tcp-auth_client.go bin/tcp-auth_server/tcp-auth_server.go
	go build -o target/tcp-auth_client bin/tcp-auth_client/tcp-auth_client.go
	go build -o target/tcp-auth_server bin/tcp-auth_server/tcp-auth_server.go

client:
	go run bin/tcp-auth_client/tcp-auth_client.go

server:
	go run bin/tcp-auth_server/tcp-auth_server.go
