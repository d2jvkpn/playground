package main

import (
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"testing"
)

func TestClient(t *testing.T) {
	addr := "https://localhost:8443"

	client := new(http.Client)
	client.Transport = &http.Transport{
		TLSClientConfig: &tls.Config{
			MinVersion:         tls.VersionTLS12,
			InsecureSkipVerify: true,
		},
	}

	req, _ := http.NewRequest("GET", addr, nil)
	// req.WithContext(ctx)

	res, err := client.Do(req)
	if err != nil {
		t.Fatal(err)
	}

	bts, err := ioutil.ReadAll(res.Body)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("~~~ response: %q\n", bts)
}
