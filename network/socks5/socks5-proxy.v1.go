package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
)

const (
	Socks5Version  = 0x05
	AuthMethodNone = 0x00
	CmdConnect     = 0x01
	AddrTypeIPv4   = 0x01
	AddrTypeDomain = 0x03
	AddrTypeIPv6   = 0x04
)

func main() {
	var (
		addr     string
		listener net.Listener
		err      error
	)

	flag.StringVar(&addr, "addr", "127.0.0.1:1100", "listening address")
	flag.Parse()

	if listener, err = net.Listen("tcp", addr); err != nil {
		log.Fatalf("Failed to start server: %v\n", err)
	}
	defer listener.Close()
	log.Printf("SOCKS5 proxy server is running on %s\n", addr)

	for {
		var conn, err = listener.Accept()
		if err != nil {
			log.Printf("Failed to accept connection: %v\n", err)
			continue
		}
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	var (
		err     error
		buf     []byte
		version byte
		methods []byte
		request *Request
	)

	defer conn.Close()

	buf = make([]byte, 2)
	if _, err = io.ReadFull(conn, buf); err != nil {
		log.Printf("Failed to read version and methods: %v\n", err)
		return
	}

	if version = buf[0]; version != Socks5Version {
		log.Printf("Unsupported SOCKS version: %v\n", version)
		return
	}

	methods = make([]byte, buf[1])
	if _, err = io.ReadFull(conn, methods); err != nil {
		log.Printf("Failed to read methods: %v\n", err)
		return
	}

	_, err = conn.Write([]byte{Socks5Version, AuthMethodNone})
	if err != nil {
		log.Printf("Failed to write auth method: %v\n", err)
		return
	}

	if request, err = readRequest(conn); err != nil {
		log.Printf("Failed to read request: %v\n", err)
		return
	}

	if request.cmd == CmdConnect {
		handleConnect(conn, request)
	} else {
		log.Printf("Unsupported command: %v\n", request.cmd)
	}
}

type Request struct {
	version byte
	cmd     byte
	addr    string
	port    uint16
}

func readRequest(conn net.Conn) (*Request, error) {
	var (
		err       error
		buf       []byte
		version   byte
		cmd       byte
		addrType  byte
		ip        []byte
		domainLen []byte
		domain    []byte
		port      []byte
	)

	buf = make([]byte, 4)
	if _, err = io.ReadFull(conn, buf); err != nil {
		return nil, err
	}

	if version = buf[0]; version != Socks5Version {
		return nil, fmt.Errorf("Unsupported SOCKS version: %v\n", version)
	}

	cmd, addrType = buf[1], buf[3]

	var addr string
	switch addrType {
	case AddrTypeIPv4:
		ip = make([]byte, 4)
		if _, err = io.ReadFull(conn, ip); err != nil {
			return nil, err
		}
		addr = net.IP(ip).String()
	case AddrTypeDomain:
		domainLen = make([]byte, 1)

		if _, err = io.ReadFull(conn, domainLen); err != nil {
			return nil, err
		}
		domain = make([]byte, domainLen[0])

		if _, err = io.ReadFull(conn, domain); err != nil {
			return nil, err
		}
		addr = string(domain)
	case AddrTypeIPv6:
		ip = make([]byte, 16)

		if _, err := io.ReadFull(conn, ip); err != nil {
			return nil, err
		}
		addr = net.IP(ip).String()
	default:
		return nil, errors.New("unsupported address type")
	}

	port = make([]byte, 2)
	if _, err = io.ReadFull(conn, port); err != nil {
		return nil, err
	}

	return &Request{
		version: version,
		cmd:     cmd,
		addr:    addr,
		port:    uint16(port[0])<<8 | uint16(port[1]),
	}, nil
}

func handleConnect(conn net.Conn, req *Request) {
	var (
		err        error
		targetAddr string
		targetConn net.Conn
	)

	targetAddr = fmt.Sprintf("%s:%d", req.addr, req.port)

	if targetConn, err = net.Dial("tcp", targetAddr); err != nil {
		log.Printf("Failed to connect to target: %v\n", err)
		sendReply(conn, 0x04) // Host unreachable
		return
	}
	defer targetConn.Close()

	if err = sendReply(conn, 0x00); err != nil {
		log.Printf("Failed to send reply: %v\n", err)
		return
	}

	go io.Copy(targetConn, conn)
	io.Copy(conn, targetConn)
}

func sendReply(conn net.Conn, reply byte) (err error) {
	_, err = conn.Write([]byte{
		Socks5Version, reply, 0x00, AddrTypeIPv4,
		0x00, 0x00, 0x00, 0x00,
		0x00, 0x00,
	})

	return err
}
