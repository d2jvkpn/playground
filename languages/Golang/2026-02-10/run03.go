package main

import (
	"fmt"
	"sync"
)

func main() {
	var (
		n  int
		ch chan struct{}
		wg sync.WaitGroup
	)

	ch = make(chan struct{}, 0)
	wg.Add(2)

	go func() {
		for i := 0; i < 5; i++ {
			<-ch
			n += 1
			fmt.Printf("--> %d\n", n)
			if n < 10 {
				ch <- struct{}{}
			}
		}

		wg.Done()
	}()

	go func() {
		for i := 0; i < 5; i++ {
			<-ch
			n += 1
			fmt.Printf("<-- %d\n", n)
			if n < 10 {
				ch <- struct{}{}
			}
		}

		wg.Done()
	}()

	ch <- struct{}{}
	wg.Wait()
}

/*
<-- 1
--> 2
<-- 3
--> 4
<-- 5
--> 6
<-- 7
--> 8
<-- 9
--> 10
*/
