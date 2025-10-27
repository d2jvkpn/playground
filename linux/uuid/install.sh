#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

#### bash
sudo apt install uuid
uuid

#### go
mkdir uuidv7-go
go mod init uuidv7-go
go get github.com/google/uuid

cat > main.go <<'EOF'
package main
import (
  "fmt"
  "github.com/google/uuid"
)

func main() {
  id, _ := uuid.NewV7()
  fmt.Println(id.String())
}
EOF

go run main.go

#### rust
cargo new uuidv7-rs
cd uuidv7-rs

cargo add uuid --features=v7

# src/main.rs
cat > src/main.rs <<'EOF'
use uuid::Uuid;

fn main() {
    println!("{}", Uuid::now_v7());
}
EOF

cargo run
