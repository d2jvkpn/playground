BIN     := target/http3-demo
MODULE  := http3-demo
ADDR    ?= :8443
CERT    ?= configs/cert.pem
KEY     ?= configs/key.pem

.PHONY: all build run test clean mkcert

all: build

build:
	@mkdir -p target
	go build -o $(BIN) .

run: build
	./$(BIN) -addr=$(ADDR) -cert=$(CERT) -key=$(KEY)

mkcert:
	mkcert -install
	mkcert -cert-file $(CERT) -key-file $(KEY) localhost 127.0.0.1

test:
	go test -v -run TestHTTP3 .

clean:
	rm -rf target configs/cert.pem configs/key.pem

test_h3check:
	go test -v -run TestHTTP3 .
