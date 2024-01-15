package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"log/slog"
	"net"
	"net/http"
	"os"
	"path"
	"regexp"
)

var (
	_AchiveRegexp = regexp.MustCompile(`[A-Za-z0-9_\.-]+`)
	_Logger       = slog.New(slog.NewTextHandler(os.Stderr, nil))
)

func middlewareHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
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

		next.ServeHTTP(w, r)
	})
}

func middlewareFunc(fn http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		// Content-Type, Authorization, X-CSRF-Token
		w.Header().Set(
			"Access-Control-Expose-Headers",
			"Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type, Content-Length",
		)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, OPTIONS, HEAD")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		fn(w, r)
	}
}

func archive(w http.ResponseWriter, r *http.Request) {
	var (
		name string
		err  error
		file *os.File

		code int
		msg  string
	)

	response := func(status int) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(status)
		// json.NewEncoder(w)
		bts, _ := json.Marshal(map[string]any{"code": code, "msg": msg})

		r.Context()

		if err == nil {
			_Logger.Info(
				fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
				"query", r.URL.RawQuery,
				"ip", r.RemoteAddr,
				"code", code,
				"msg", msg,
			)
		} else {
			_Logger.Info(
				fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
				"query", r.URL.RawQuery,
				"ip", r.RemoteAddr,
				"code", code,
				"msg", msg,
				"error", err,
			)
		}

		w.Write(bts)
	}

	// io.WriteString(w, "This is my website!\n")

	if name = r.URL.Query().Get("name"); !_AchiveRegexp.MatchString(name) {
		code, msg = -1, "invalid name"
		response(http.StatusBadRequest)
		return
	}

	if file, err = os.Create(path.Join("data", name)); err != nil {
		code, msg = 1, "service error"
		response(http.StatusInternalServerError)
		return
	}
	defer file.Close()

	if _, err = io.Copy(file, r.Body); err != nil {
		code, msg = 2, "service error"
		response(http.StatusInternalServerError)
	} else {
		code, msg = 0, "ok"
		response(http.StatusOK)
	}
}

func main() {
	var (
		addr     string
		err      error
		listener net.Listener
		mux      *http.ServeMux
		server   *http.Server
	)

	flag.StringVar(&addr, "addr", ":3000", "http service address")
	flag.Parse()

	if err = os.MkdirAll("data", 0755); err != nil {
		log.Fatalln(err)
	}

	/*
		http.HandleFunc("/", archive)

		log.Printf("==> Http service is listening on %q\n", addr)
		if err = http.ListenAndServe(addr, nil); err != nil {
			log.Fatalln(err)
		}
	*/

	if listener, err = net.Listen("tcp", addr); err != nil {
		log.Fatalln(err)
	}

	mux, server = http.NewServeMux(), new(http.Server)
	server.Handler = mux
	// TODO: configure server, e.g. BaseContext
	// mux.Handle("/", middlewareHandler(http.HandlerFunc(archive)))
	mux.HandleFunc("/", middlewareFunc(archive))

	log.Printf("==> Http service is listening on %q\n", addr)
	if err = server.Serve(listener); err != nil {
		log.Fatalln(err)
	}
}
