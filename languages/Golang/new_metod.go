package main

import (
	"fmt"
)

var (
	NilData *Data
)

func main() {
	// fmt.Println("Hello, world!")
	var data = NewData(42)
	fmt.Printf("~~~ data: %v\n", data)

	d1 := (&Data{}).New(42)
	d1 = NilData.New(42)
	fmt.Printf("~~~ d1: %v\n", d1)
}

type Data struct {
	value uint
}

func NewData(value uint) Data {
	return Data{value: value}
}

// not static method in golang
func (*Data) New(value uint) Data {
	return Data{value: value}
}
