go:
	go mod tidy
	if [ -d vendor ]; then go mod vendor; fi
	go fmt ./...
	go vet ./...

build:
	mkdir -p target
	go build -o target/demo-api_swagger main.go

run:
	go run main.go
