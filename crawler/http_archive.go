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
	"strconv"
	"time"
)

var (
	// _AchiveRE = regexp.MustCompile(`^[A-Za-z0-9_\.-{Han}]{8,64}$`)
	// _Logger       = slog.New(slog.NewTextHandler(os.Stderr, nil))

	_AchiveRE = regexp.MustCompile(`^[^^/\\]{8,64}$`)
	_Logger   = slog.New(slog.NewJSONHandler(os.Stderr, nil))
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
			// w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(`{"code":"not_found","msg":"not found"}`))
			return
		}

		now := time.Now()
		fn(w, r)

		data := httpContextGet(r)
		logger := _Logger.Info
		if err, ok := data["error"].(error); ok && err != nil {
			logger = _Logger.Error
		}

		logger(
			fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
			"query", r.URL.RawQuery,
			"ip", r.RemoteAddr,
			"latency", time.Since(now).String(),
			"data", data,
		)
	}
}

func httpContextSet(r *http.Request, data map[string]any) {
	ctx := context.WithValue(r.Context(), "_data", data)
	*r = *(r.WithContext(ctx))
}

func httpContextGet(r *http.Request) map[string]any {
	if data, ok := r.Context().Value("_data").(map[string]any); ok {
		return data
	} else {
		return make(map[string]any)
	}
}

func archive(w http.ResponseWriter, r *http.Request) {
	var (
		filename string
		date     string
		fp       string
		err      error
		file     *os.File
	)

	response := func(status int, code string, msgs ...string) {
		var msg string = ""

		if len(msgs) > 0 {
			msg = msgs[0]
		}

		// w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(status)
		// json.NewEncoder(w)
		bts, _ := json.Marshal(map[string]any{"code": code, "msg": msg})

		if err == nil {
			httpContextSet(r, map[string]any{"status": status, "code": code, "msg": msg})
		} else {
			httpContextSet(r, map[string]any{
				"status": status, "code": code, "msg": msg, "error": err,
			})
		}

		w.Write(bts)
	}

	// io.WriteString(w, "This is my website!\n")
	if filename = r.URL.Query().Get("filename"); !_AchiveRE.MatchString(filename) {
		response(http.StatusBadRequest, "invalid_filename")
		return
	}

	if len(r.Header["Content-Length"]) == 0 {
		response(http.StatusBadRequest, "empty_content")
		log.Println("!!! empty_content")
		return
	}

	// check if size > 10MB
	if size, _ := strconv.ParseUint(r.Header["Content-Length"][0], 10, 64); size > 1024*1024*10 {
		response(http.StatusBadRequest, "too_large")
		log.Println("!!! too_large")
		return
	}

	date = time.Now().Format(time.DateOnly)
	if err = os.MkdirAll(filepath.Join("data", date), 0755); err != nil {
		response(http.StatusInternalServerError, "service_error")
		return
	}

	fp = filepath.Join("data", date, filename)
	if file, err = os.Create(fp); err != nil {
		response(http.StatusInternalServerError, "service_error")
		return
	}
	_, err = io.Copy(file, r.Body)
	_ = file.Close()

	if err != nil {
		_ = os.Remove(fp)
		response(http.StatusInternalServerError, "service_error")
	} else {
		response(http.StatusOK, "ok")
	}
}
