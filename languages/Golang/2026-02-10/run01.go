package main

import (
	"fmt"
)

func run(n int) (r int) {
	defer func() { // defer1
		fmt.Println("~~~ 3:", r) // r = 6
		r += n
		fmt.Println("~~~ 4:", r) // r = 9
	}()

	defer func() { // defer2
		fmt.Println("~~~ 1:", r) // r = 4: r = n+1
		r += 2
		fmt.Println("~~~ 2:", r) // r = 6
	}()

	return n + 1
	// r = n + 1
	// defer2()
	// defer1()
	// return r
}

func main() {
	ans := run(3)
	fmt.Println("ans:", ans) // 9
}
