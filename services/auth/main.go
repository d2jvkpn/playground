package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

func main() {
	conf := &oauth2.Config{
		ClientID:     "your-client-id",
		ClientSecret: "your-client-secret",
		RedirectURL:  "http://localhost:8080/callback",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}

	url := conf.AuthCodeURL("state", oauth2.AccessTypeOffline)
	fmt.Printf("==> Visit the URL to authenticate: %s\n", url)

	http.HandleFunc("/callback", func(w http.ResponseWriter, r *http.Request) {
		code := r.URL.Query().Get("code")
		fmt.Printf("==> Code: %s\n", code)

		token, err := conf.Exchange(context.Background(), code)
		if err != nil {
			http.Error(w, "Failed to exchange token", http.StatusInternalServerError)
			log.Printf("Error exchanging token: %v", err)
			return
		}

		fmt.Fprintf(w, "Access Token: %s\n", token.AccessToken)
		fmt.Printf("Access Token: %s\n", token.AccessToken)
	})

	log.Fatal(http.ListenAndServe(":9090", nil))
}

