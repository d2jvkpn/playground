package main

import (
	"crypto/tls"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/quic-go/quic-go/http3"
)

// ---- Main ----
func main() {
	var (
		domain   string
		addr     string
		port     string
		certPath string
		keyPath  string
		err      error

		tlsCert tls.Certificate
		tlsCfg  *tls.Config
		mux     *http.ServeMux
		errChan chan error
		h3srv   *http3.Server
		h12srv  *http.Server
	)

	flag.StringVar(&domain, "domain", "localhost", "domain")
	flag.StringVar(&addr, "addr", ":8443", "listen address")
	flag.StringVar(&certPath, "cert", "configs/cert.pem", "TLS certificate file")
	flag.StringVar(&keyPath, "key", "configs/key.pem", "TLS private key file")
	flag.Parse()

	_, port, err = net.SplitHostPort(addr)
	if err != nil {
		log.Fatal("Error:", err)
	}

	if _, err = os.Stat(certPath); os.IsNotExist(err) {
		log.Printf("Generating self-signed TLS certificate → %s / %s", certPath, keyPath)
		log.Printf("Note: browsers often keep localhost on HTTP/2 when HTTP/3 uses an untrusted self-signed cert; use `make mkcert` for a locally trusted cert")
		if err = generateCert(certPath, keyPath, domain); err != nil {
			log.Fatalf("Cert generation failed: %v", err)
		}
	}

	if tlsCert, err = tls.LoadX509KeyPair(certPath, keyPath); err != nil {
		log.Fatalf("load cert: %v", err)
	}
	tlsCfg = &tls.Config{
		Certificates: []tls.Certificate{tlsCert},
		NextProtos:   []string{"h3", "h2", "http/1.1"},
		MinVersion:   tls.VersionTLS13,
	}

	mux = http.NewServeMux()
	mux.HandleFunc("/api/hello", handleHello)
	mux.HandleFunc("/api/time", handleTime)
	mux.HandleFunc("/api/echo", handleEcho)
	mux.Handle("/", http.FileServer(http.Dir("site")))

	handler := logger(altSvc(addr, mux))

	h3srv = &http3.Server{
		Addr:      addr,
		TLSConfig: tlsCfg,
		Handler:   handler,
	}

	h12srv = &http.Server{
		Addr:      addr,
		TLSConfig: tlsCfg,
		Handler:   handler,
	}

	errChan = make(chan error, 2)
	log.Printf("Note: a quic-go UDP receive buffer warning is non-fatal for this local demo; it mainly affects HTTP/3 performance under load")
	go func() {
		log.Printf("HTTP/3   listening on https://%s:%s", domain, port)
		errChan <- h3srv.ListenAndServe()
	}()

	go func() {
		log.Printf("HTTP/1+2 listening on https://%s:%s", domain, port)
		errChan <- h12srv.ListenAndServeTLS(certPath, keyPath)
	}()

	log.Fatal(<-errChan)
}

// ---- Response ----
type Response struct {
	Code string         `json:"code"`
	Data map[string]any `json:"data"`
}

func apiOk(data map[string]any) Response {
	if data == nil {
		data = map[string]any{}
	}
	return Response{Code: "ok", Data: data}
}

func apiFail(code string, data map[string]any) Response {
	if data == nil {
		data = map[string]any{}
	}
	return Response{Code: code, Data: data}
}

func writeJSON(w http.ResponseWriter, status int, v Response) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}

// ---- API handlers ----
func handleHello(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "World"
	}
	writeJSON(w, http.StatusOK, apiOk(map[string]any{
		"message":   fmt.Sprintf("Hello, %s!", name),
		"_protocol": r.Proto,
	}))
}

func handleTime(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, apiOk(map[string]any{
		"utc":       time.Now().UTC().Format(time.RFC3339),
		"_protocol": r.Proto,
	}))
}

func handleEcho(w http.ResponseWriter, r *http.Request) {
	var body map[string]any

	if r.Method != http.MethodPost {
		writeJSON(w, http.StatusMethodNotAllowed, apiFail("method_not_allowed", map[string]any{
			"reason":    "only POST is accepted",
			"_protocol": r.Proto,
		}))
		return
	}

	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		writeJSON(w, http.StatusBadRequest, apiFail("bad_request", map[string]any{
			"reason":    err.Error(),
			"_protocol": r.Proto,
		}))
		return
	}

	// body["_echoed_at"] = time.Now().UTC().Format(time.RFC3339)
	writeJSON(w, http.StatusOK, apiOk(map[string]any{
		"echo":      body,
		"_protocol": r.Proto,
	}))
}

// ---- Middleware ----
func altSvc(addr string, next http.Handler) http.Handler {
	hdr := fmt.Sprintf(`h3="%s"; ma=86400`, addr)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Alt-Svc", hdr)
		next.ServeHTTP(w, r)
	})
}

func logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s  %s %s", r.Proto, r.Method, r.URL.Path)
		next.ServeHTTP(w, r)
	})
}
