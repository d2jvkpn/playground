package main

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"log/slog"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"time"
)

var (
	_AchiveRE = regexp.MustCompile(`^[A-Za-z0-9_\.-]{6,32}$`)
	// _Logger       = slog.New(slog.NewTextHandler(os.Stderr, nil))
	_Logger = slog.New(slog.NewJSONHandler(os.Stderr, nil))
)

func main() {
	var (
		addr        string
		certFile    string
		keyFile     string
		origin      string
		enableHttps bool
		err         error
		listener    net.Listener
		cert        tls.Certificate
		mux         *http.ServeMux
		server      *http.Server
	)

	flag.StringVar(&addr, "addr", ":3000", "http service address")
	flag.StringVar(&certFile, "cert", "", "tls cert file")
	flag.StringVar(&keyFile, "key", "", "tls key file")
	flag.StringVar(&origin, "origin", "*", "cors allow origin")
	flag.Parse()

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

	enableHttps = certFile != "" && keyFile != ""
	if enableHttps {
		if cert, err = tls.LoadX509KeyPair(certFile, keyFile); err != nil {
			log.Fatalln(err)
		}
		server.TLSConfig = &tls.Config{
			Certificates: []tls.Certificate{cert},
		}
	}

	// TODO: configure server, e.g. BaseContext
	// mux.Handle("/", middlewareHandler(http.HandlerFunc(archive)))
	mux.HandleFunc("/", middlewareFunc("PUT", origin, archive))

	if enableHttps {
		log.Printf("==> Https service is listening on %q\n", addr)
	} else {
		log.Printf("==> Http service is listening on %q\n", addr)
	}

	if err = server.Serve(listener); err != nil {
		log.Fatalln(err)
	}
}

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
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, OPTIONS, HEAD")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func middlewareFunc(method, origin string, fn http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", origin)
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

		if r.Method != method {
			w.WriteHeader(http.StatusBadRequest)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(`{"code":"not_found","msg":"not found"}`))
			return
		}

		now := time.Now()
		fn(w, r)

		data := getData(r)
		logger := _Logger.Info
		if err, ok := data["error"].(error); ok && err != nil {
			logger = _Logger.Error
		}

		logger(
			fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
			"query", r.URL.RawQuery,
			"ip", r.RemoteAddr,
			"elapsed", time.Since(now).String(),
			"data", data,
		)
	}
}

func setData(r *http.Request, data map[string]any) {
	ctx := context.WithValue(r.Context(), "_data", data)
	*r = *(r.WithContext(ctx))
}

func getData(r *http.Request) map[string]any {
	if data, ok := r.Context().Value("_data").(map[string]any); ok {
		return data
	} else {
		return make(map[string]any)
	}
}

func archive(w http.ResponseWriter, r *http.Request) {
	var (
		name string
		err  error
		file *os.File

		date string
	)

	response := func(status int, code string, msgs ...string) {
		var msg string = ""

		if len(msgs) > 0 {
			msg = msgs[0]
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(status)
		// json.NewEncoder(w)
		bts, _ := json.Marshal(map[string]any{"code": code, "msg": msg})

		if err == nil {
			setData(r, map[string]any{"status": status, "code": code, "msg": msg})
		} else {
			setData(r, map[string]any{"status": status, "code": code, "msg": msg, "error": err})
		}

		w.Write(bts)
	}

	// io.WriteString(w, "This is my website!\n")

	if name = r.URL.Query().Get("name"); !_AchiveRE.MatchString(name) {
		response(http.StatusBadRequest, "invalid_name")
		return
	}

	if len(r.Header["Content-Length"]) == 0 {
		response(http.StatusBadRequest, "empty_content")
		return
	}

	date = time.Now().Format(time.DateOnly)
	if err = os.MkdirAll(filepath.Join("data", date), 0755); err != nil {
		response(http.StatusInternalServerError, "service_error")
		return
	}

	if file, err = os.Create(filepath.Join("data", date, name)); err != nil {
		response(http.StatusInternalServerError, "service_error")
		return
	}
	defer file.Close()

	if _, err = io.Copy(file, r.Body); err != nil {
		response(http.StatusInternalServerError, "service_error")
	} else {
		response(http.StatusOK, "ok")
	}
}
