package main

import (
	"encoding/json"
	"fmt"
)

type MyError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

func (err *MyError) Error() string {
	return fmt.Sprintf("MyError: code=%d, message=%q", err.Code, err.Message)
}

func main() {
	_, err := call()
	fmt.Printf("~~~ %v\n", err)
	
	bts, _ := json.Marshal(err)
	fmt.Printf("==> json: %s\n", bts)
}

func call() (string, error) {
	return "", &MyError{Code: 1, Message: "XXXX"}
}
