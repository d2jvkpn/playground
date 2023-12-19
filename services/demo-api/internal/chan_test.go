package internal

import (
	"fmt"
	"testing"
)

func TestChan(t *testing.T) {
	errch := make(chan error, 3)
	fmt.Println(cap(errch))
}
