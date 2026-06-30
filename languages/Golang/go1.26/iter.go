package main

import (
	"fmt"
	"iter"
)

func main() {
	for v := range Count(5) {
		fmt.Println(v)
	}

	pair := map[string]int{
		"hello": 1,
		"word":  2,
		"a": 3,
	}

	for k, v := range Pairs(pair) {
		fmt.Println(k, v)

		if k == "a" {
			break
		}
	}
}

func Count(n int) iter.Seq[int] {
	return func(yield func(int) bool) {
		for i := 0; i < n; i++ {
			if !yield(i) {
				return
			}
		}
	}
}

func Pairs(m map[string]int) iter.Seq2[string, int] {
	return func(yield func(string, int) bool) {
		for k, v := range m {
			if !yield(k, v) {
				return
			}
		}
	}
}
