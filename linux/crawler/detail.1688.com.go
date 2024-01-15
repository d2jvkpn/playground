package main

import (
	"context"
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
	_AchiveRegexp = regexp.MustCompile(`^[A-Za-z0-9_\.-]{6,32}$`)
	// _Logger       = slog.New(slog.NewTextHandler(os.Stderr, nil))
	_Logger = slog.New(slog.NewJSONHandler(os.Stderr, nil))
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
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, OPTIONS, HEAD")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func middlewareFunc(method string, fn http.HandlerFunc) http.HandlerFunc {
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

		if r.Method != method {
			w.WriteHeader(http.StatusBadRequest)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(`{"code":-1,"msg":"not_found"}`))
			return
		}

		now := time.Now()
		fn(w, r)

		data := getData(r)
		if err, ok := data["error"].(error); ok && err == nil {
			_Logger.Info(
				fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
				"query", r.URL.RawQuery,
				"ip", r.RemoteAddr,
				"elapsed", time.Since(now).String(),
				"data", data,
			)
		} else {
			_Logger.Info(
				fmt.Sprintf("%s@%s", r.Method, r.URL.Path),
				"query", r.URL.RawQuery,
				"ip", r.RemoteAddr,
				"elapsed", time.Since(now).String(),
				"data", data,
			)
		}
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

		code int
		msg  string
		date string
	)

	response := func(status int) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(status)
		// json.NewEncoder(w)
		bts, _ := json.Marshal(map[string]any{"code": code, "msg": msg})
		setData(r, map[string]any{
			"status": status, "error": err,
			"code": code, "msg": msg,
		})
		w.Write(bts)
	}

	// io.WriteString(w, "This is my website!\n")

	if name = r.URL.Query().Get("name"); !_AchiveRegexp.MatchString(name) {
		code, msg = -10, "invalid_name"
		response(http.StatusBadRequest)
		return
	}

	if len(r.Header["Content-Length"]) == 0 {
		code, msg = -11, "empty_content"
		response(http.StatusBadRequest)
		return
	}

	date = time.Now().Format(time.DateOnly)
	if err = os.MkdirAll(filepath.Join("data", date), 0755); err != nil {
		code, msg = 11, "service_error"
		response(http.StatusInternalServerError)
		return
	}

	if file, err = os.Create(filepath.Join("data", date, name)); err != nil {
		code, msg = 12, "service_error"
		response(http.StatusInternalServerError)
		return
	}
	defer file.Close()

	if _, err = io.Copy(file, r.Body); err != nil {
		code, msg = 13, "service_error"
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
	mux.HandleFunc("/", middlewareFunc("PUT", archive))

	log.Printf("==> Http service is listening on %q\n", addr)
	if err = server.Serve(listener); err != nil {
		log.Fatalln(err)
	}
}
