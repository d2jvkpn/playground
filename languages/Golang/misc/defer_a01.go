package main

import (
	"fmt"
)

func main() {
	NewD(true)
	NewD(false)
}

type D struct{}

func NewD(ok bool) (d *D, err error) {
	defer func() {
		if err != nil {
			fmt.Println("No")
		} else {
			fmt.Println("Yes")
		}
	}()

	if ok {
		return &D{}, nil
	} else {
		return nil, fmt.Errorf("not ok")
	}
}
