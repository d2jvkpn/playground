package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, world!")

	//
	model := NewModel[int]()
	model.Push(42)
	
	fmt.Printf("~~~ %+v\n", model)

	//
	gx := GX[string]{}
	gx.Item = "hello"
	gx.Print()
}

type Model[T any] struct {
	Data []T
}

func NewModel[T any]() Model[T] {
	return Model[T]{
		Data: make([]T, 0),
	}
}

func (m *Model[T]) Push(item T) {
	m.Data = append(m.Data, item)
}

type GX[T any] struct {
	Item T
}

func (self *GX[T]) Print() {
	fmt.Printf("~~~ GX: %v\n", self.Item)
}
