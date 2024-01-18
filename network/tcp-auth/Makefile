compile:
	mkdir -p target

	go fmt tcp-auth_client.go tcp-auth_server.go
	go build -o target/tcp-auth_client tcp-auth_client.go
	go build -o target/tcp-auth_server tcp-auth_server.go

run-client:
	go fmt tcp-auth_client.go
	go run tcp-auth_client.go

run-server:
	go fmt tcp-auth_server.go
	go run tcp-auth_server.go
