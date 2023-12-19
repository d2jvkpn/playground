package internal

import (
	"fmt"
	"testing"
	"time"
)

func TestChan(t *testing.T) {
	errch := make(chan error, 3)
	fmt.Println(cap(errch))

	var lifetime <-chan time.Time
	<-lifetime // always block

	// lifetime = time.After(time.Second * 5)
	// <-lifetime // always block

	fmt.Println("exit")
}
