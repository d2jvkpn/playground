package main

import (
	"crypto/tls"
	"encoding/json"
	"net/http"
	"strings"
	"testing"

	"github.com/quic-go/quic-go/http3"
)

var h3Client = &http.Client{
	Transport: &http3.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	},
}

func TestHTTP3Hello(t *testing.T) {
	resp, err := h3Client.Get("https://localhost:8443/api/hello?name=Tester")
	if err != nil {
		t.Fatalf("request failed: %v", err)
	}
	defer resp.Body.Close()

	if !strings.HasPrefix(resp.Proto, "HTTP/3") {
		t.Errorf("expected HTTP/3, got %s", resp.Proto)
	}

	var r Response
	if err := json.NewDecoder(resp.Body).Decode(&r); err != nil {
		t.Fatalf("decode: %v", err)
	}
	if r.Code != "ok" {
		t.Errorf("expected code=ok, got %s", r.Code)
	}
	t.Logf("proto=%s  body=%+v", resp.Proto, r)
}

func TestHTTP3Time(t *testing.T) {
	resp, err := h3Client.Get("https://localhost:8443/api/time")
	if err != nil {
		t.Fatalf("request failed: %v", err)
	}
	defer resp.Body.Close()

	if !strings.HasPrefix(resp.Proto, "HTTP/3") {
		t.Errorf("expected HTTP/3, got %s", resp.Proto)
	}

	var r Response
	if err := json.NewDecoder(resp.Body).Decode(&r); err != nil {
		t.Fatalf("decode: %v", err)
	}
	if r.Code != "ok" {
		t.Errorf("expected code=ok, got %s", r.Code)
	}
	t.Logf("proto=%s  body=%+v", resp.Proto, r)
}

func TestHTTP3Echo(t *testing.T) {
	body := `{"message":"hello","value":1}`
	resp, err := h3Client.Post(
		"https://localhost:8443/api/echo",
		"application/json",
		strings.NewReader(body),
	)
	if err != nil {
		t.Fatalf("request failed: %v", err)
	}
	defer resp.Body.Close()

	if !strings.HasPrefix(resp.Proto, "HTTP/3") {
		t.Errorf("expected HTTP/3, got %s", resp.Proto)
	}

	var r Response
	if err := json.NewDecoder(resp.Body).Decode(&r); err != nil {
		t.Fatalf("decode: %v", err)
	}
	if r.Code != "ok" {
		t.Errorf("expected code=ok, got %s", r.Code)
	}
	echo, _ := r.Data["echo"].(map[string]any)
	if echo["_protocol"] != "HTTP/3.0" {
		t.Errorf("expected _protocol=HTTP/3.0, got %v", echo["_protocol"])
	}
	t.Logf("proto=%s  body=%+v", resp.Proto, r)
}
