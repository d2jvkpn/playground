compile:
	mkdir -p target
	go build -o target/tcp-auth_client tcp-auth_client.go
	go build -o target/tcp-auth_server tcp-auth_server.go

run-client:
	go run tcp-auth_client.go

run-server:
	go run tcp-auth_server.go
