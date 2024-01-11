package main

import (
	"fmt"
)

func main() {
	data := map[string]int{"hello": 1, "world": 2}
	fmt.Printf("~~~ %v, %d\n", data, len(data))

	clear(data)
	fmt.Printf("~~~ %v, %d\n", data, len(data))

	arr := make([]int, 0, 3)
	arr = append(arr, 1)
	fmt.Printf("~~~ %v, %d, %d\n", arr, len(arr), cap(arr))

	clear(arr)
	fmt.Printf("~~~ %v, %d, %d\n", arr, len(arr), cap(arr))

	fmt.Println("~~~", max(1.2, 2.1), min(1.2, 2.1))
}
