package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"strings"
)

func main() {
	var (
		addr    string
		token   string
		message string
		err     error
		reader  *bufio.Reader
		conn    net.Conn
	)

	flag.StringVar(&addr, "addr", "localhost:8000", "tcp server address")
	flag.Parse()

	if conn, err = net.Dial("tcp", addr); err != nil {
		log.Fatalln(err)
	}

	reader = bufio.NewReader(os.Stdin)
	fmt.Print("==> Enter token: ")
	if token, err = reader.ReadString('\n'); err != nil {
		log.Fatalln(err)
	}
	token = strings.TrimSpace(token)

	fmt.Fprintf(conn, token+"\n")

	if message, err = bufio.NewReader(conn).ReadString('\n'); err != nil {
		log.Printf("read error: %s\n", err)
		conn.Close()
		return
	}

	log.Printf("==> Message from server: %s\n", message)
}
