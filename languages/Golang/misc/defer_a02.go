package main

import (
	"fmt"
)

func main() {
	fmt.Println("==> A")
	defer fmt.Println("==> a")

	fmt.Println("Hello, world!")

	// code block
	{
		fmt.Println("==> B")
		defer fmt.Println("==> b")
	}

	// anony func
	func() {
		fmt.Println("==> C")
		defer fmt.Println("==> c")
	}()

	fmt.Println("42")

	return
}

/* Output:
==> A
Hello, world!
==> B
==> C
==> c
42
==> b
==> a
*/
