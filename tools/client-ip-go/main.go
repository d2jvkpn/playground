package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
	"time"
)

func init() {
	log.SetFlags(0)
	log.SetOutput(os.Stdout)
}

func main() {
	var (
		addr      string
		cert, key string
		err       error
		listener  net.Listener
		server    *http.Server
	)

	flag.StringVar(&addr, "addr", ":8080", "http listening address")
	flag.StringVar(&cert, "cert", "", "tls cert file path")
	flag.StringVar(&key, "key", "", "tls key file path")
	flag.Parse()

	if listener, err = net.Listen("tcp", addr); err != nil {
		log.Fatal(err)
		return
	}

	server = NewServer()

	if cert != "" && key != "" {
		log.Printf("[%s] HTTPS service is starting: addr=%q\n", now(), addr)
		err = server.ServeTLS(listener, cert, key)
	} else {
		log.Printf("[%s] HTTP service is starting: addr=%q\n", now(), addr)
		err = server.Serve(listener)
	}

	if err != nil {
		log.Fatal(err)
	}
}

/*
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "%s\n", getClientIP(r))
	})

	http.ListenAndServe(addr, nil)
*/

func NewServer() (server *http.Server) {
	var mux *http.ServeMux

	mux = http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		ip := getClientIP(r)
		log.Printf("[%s] client: ip=%q\n", now(), ip)
		fmt.Fprintf(w, "%s\n", ip)
	})

	return &http.Server{
		Handler:           mux,
		ReadHeaderTimeout: 3 * time.Second,
		WriteTimeout:      3 * time.Second,
	}
}

func now() string {
	return time.Now().Format(time.RFC3339)
}

func getClientIP(r *http.Request) string {
	var (
		ip  string
		err error
	)

	// case insensitive
	if ip = r.Header.Get("X-Forwarded-For"); ip != "" {
		return strings.TrimSpace(strings.Split(ip, ",")[0])
	}

	if ip = r.Header.Get("X-Real-IP"); ip != "" {
		return ip
	}

	if ip, _, err = net.SplitHostPort(r.RemoteAddr); err == nil {
		return ip
	}

	return ""
}
