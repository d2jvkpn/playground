#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export PATH="$HOME/Apps/bin:$(go env GOPATH)/bin:$PATH"

# go get -u github.com/golang/protobuf/{proto,protoc-gen-go}@v1.31.0
go get -u google.golang.org/grpc
go get -u google.golang.org/protobuf

mkdir -p proto

cat > proto/auth.proto << EOF
syntax = "proto3";

package proto;

option go_package="./proto";

message Msg {
	uint32 http_code = 1;
	string msg       = 2;
}

message CreateQ {
	string password = 1;
}

message CreateA {
	Msg    msg = 1;
	string id  = 2;
}

message VerifyQ {
	string id       = 1;
	string password = 2;
}

message VerifyA {
	Msg    msg    = 1;
	string status = 2;
}

message GetOrUpdateQ {
	string id       = 1;
	string password = 2;
	string status   = 3;
}

message GetOrUpdateA {
	Msg    msg    = 1;
	string status = 2;
}

service AuthService {
	rpc Create(CreateQ) returns (CreateA) {};
	rpc Verify(VerifyQ) returns (VerifyA) {};
	rpc GetOrUpdate(GetOrUpdateQ) returns (GetOrUpdateA) {};
}
EOF

protoc --go_out=./  --go-grpc_out=./  proto/auth.proto

ls -al proto/
go fmt ./... && go vet ./...

sed -i '/^\tmustEmbedUnimplemented/s#\t#\t// #' proto/*_grpc.pb.go
