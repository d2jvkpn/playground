package main

import (
	"fmt"
	"flag"
	"io"
	"log"
	"net/http"
	"os"
	"path"
)

func archive(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	// Content-Type, Authorization, X-CSRF-Token
	w.Header().Set(
		"Access-Control-Expose-Headers",
		"Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type, Content-Length",
	)
	w.Header().Set("Access-Control-Allow-Credentials", "true")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS, HEAD")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	fmt.Println("???", r.Method)

	var (
		name string
		err  error
		file *os.File
	)

	// io.WriteString(w, "This is my website!\n")
	if name = r.URL.Query().Get("name"); name == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if file, err = os.Create(path.Join("data", name)); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	defer file.Close()

	_, _ = io.Copy(file, r.Body)
	w.WriteHeader(http.StatusOK)
}

func main() {
	var (
		addr string
		err  error
	)

	flag.StringVar(&addr, "addr", ":3000", "http service address")
	flag.Parse()

	if err = os.MkdirAll("data", 0755); err != nil {
		log.Fatalln(err)
	}

	http.HandleFunc("/", archive)

	log.Printf("==> Http service is listening on %s\n", addr)
	if err = http.ListenAndServe(addr, nil); err != nil {
		log.Fatalln(err)
	}
}
