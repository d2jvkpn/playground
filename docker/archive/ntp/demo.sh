#! /usr/bin/env bash
set -eu -o pipefail

wd=$(pwd)

## 1
go run main.go server --port 8080

go run main.go client --addr http://127.0.0.1:8080 --delay 10


## 2
sh deploy/build.sh latest

sh deploy/deploy.sh latest 1024
