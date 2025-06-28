package main

import (
	//"bytes"
	//"crypto/tls"
	"encoding/binary"
	"fmt"
	"io"
	"log"
	"net"
	//"os"
	"time"

	"golang.org/x/net/proxy"
)

const (
	SOCKS5Version     = 0x05
	SOCKS5CmdConnect  = 0x01
	SOCKS5ATypeIPv4   = 0x01
	SOCKS5ATypeDomain = 0x03
	SOCKS5ATypeIPv6   = 0x04
)

func main() {
	var (
		addr     string
		err      error
		listener net.Listener
	)

	addr = "127.0.0.1:1101"
	if listener, err = net.Listen("tcp", addr); err != nil {
		log.Fatal(err)
	}
	defer listener.Close()
	log.Printf("Socks5H proxy server started on %v", addr)

	for {
		var conn net.Conn
		if conn, err = listener.Accept(); err != nil {
			log.Printf("Accept error: %v", err)
			continue
		}

		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	var (
		buf       []byte
		version   byte
		nmethods  byte
		cmd       byte
		resv      byte
		atype     byte
		domainLen byte
		err       error

		addr       Socks5Addr
		targetConn net.Conn
		targetAddr string
		dialer     proxy.Dialer
	)

	defer conn.Close()

	// Handle Socks5 handshake
	buf = make([]byte, 2)
	if _, err = io.ReadFull(conn, buf); err != nil {
		log.Printf("handshake error: %v\n", err)
		return
	}

	version, nmethods = buf[0], buf[1]
	if version != SOCKS5Version {
		conn.Write([]byte{SOCKS5Version, 0xFF})
		return
	}

	buf = make([]byte, nmethods)
	if _, err = io.ReadFull(conn, buf); err != nil {
		log.Printf("handshake error: %v\n", err)
		return
	}
	conn.Write([]byte{SOCKS5Version, 0x00})

	// Handle Socks5 request
	buf = make([]byte, 4)
	if _, err = io.ReadFull(conn, buf); err != nil {
		log.Printf("request error: %v\n", err)
		return
	}

	version, cmd, resv, atype = buf[0], buf[1], buf[2], buf[3]
	if version != SOCKS5Version || cmd != SOCKS5CmdConnect || resv != 0x00 {
		conn.Write([]byte{SOCKS5Version, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
		return
	}

	switch atype {
	case SOCKS5ATypeIPv4:
		buf = make([]byte, 6)
		if _, err = io.ReadFull(conn, buf); err != nil {
			log.Printf("request error: %v\n", err)
			return
		}
		addr.ATYPE = SOCKS5ATypeIPv4
		addr.ADDR = buf[:4]
		addr.PORT = binary.BigEndian.Uint16(buf[4:])
	case SOCKS5ATypeDomain:
		if _, err = io.ReadFull(conn, buf[:1]); err != nil {
			log.Printf("request error: %v\n", err)
			return
		}

		domainLen = buf[0]
		buf = make([]byte, domainLen+2)
		if _, err = io.ReadFull(conn, buf); err != nil {
			log.Printf("request error: %v\n", err)
			return
		}

		addr.ATYPE = SOCKS5ATypeDomain
		addr.ADDR = buf[:domainLen]
		addr.PORT = binary.BigEndian.Uint16(buf[domainLen:])
	case SOCKS5ATypeIPv6:
		buf = make([]byte, 18)
		if _, err = io.ReadFull(conn, buf); err != nil {
			log.Printf("request error: %v\n", err)
			return
		}

		addr.ATYPE = SOCKS5ATypeIPv6
		addr.ADDR = buf[:16]
		addr.PORT = binary.BigEndian.Uint16(buf[16:])
	default:
		conn.Write([]byte{SOCKS5Version, 0x08, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
		return
	}

	log.Printf("Socks5 request to %s:%d", addr.String(), addr.PORT)

	targetAddr = fmt.Sprintf("%s:%d", string(addr.ADDR), addr.PORT)
	if addr.ATYPE == SOCKS5ATypeDomain {
		// auth := &proxy.Auth{User: "username", Password: "password"}
		if dialer, err = proxy.SOCKS5("tcp", "127.0.0.1:9050", nil, &net.Dialer{}); err != nil {
			log.Printf("proxy.SOCKS5: %v\n", err)
			return
		}
		targetConn, err = dialer.Dial("tcp", targetAddr)
	} else {
		targetConn, err = net.DialTimeout("tcp", targetAddr, 10*time.Second)
	}

	if err != nil {
		log.Printf("connect error: %v\n", err)
		conn.Write([]byte{SOCKS5Version, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
		return
	}
	defer targetConn.Close()

	conn.Write([]byte{SOCKS5Version, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

	go io.Copy(conn, targetConn)
	io.Copy(targetConn, conn)
}

type Socks5Addr struct {
	ATYPE byte
	ADDR  []byte
	PORT  uint16
}

func (a *Socks5Addr) String() string {
	switch a.ATYPE {
	case SOCKS5ATypeIPv4:
		return net.IP(a.ADDR).String()
	case SOCKS5ATypeDomain:
		return string(a.ADDR)
	case SOCKS5ATypeIPv6:
		return net.IP(a.ADDR).To16().String()
	default:
		return "unknown"
	}
}
