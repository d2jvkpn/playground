package main

import (
	"fmt"
	"sync"
)

func main() {
	n := 0
	ch := make(chan struct{}, 1)
	var wg sync.WaitGroup

	wg.Add(2)

	go func() {
		for i := 0; i < 5; i++ {
			select {
			case <-ch:
				n += 1
				fmt.Println(n)
				ch <- struct{}{}
			}
		}

		wg.Done()
	}()

	go func() {
		for i := 0; i < 5; i++ {
			<-ch
			n += 1
			fmt.Println(n)
			ch <- struct{}{}
		}

		wg.Done()
	}()

	ch <- struct{}{}
	wg.Wait()
}
