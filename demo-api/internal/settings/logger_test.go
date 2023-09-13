package settings

import (
	"fmt"
	"testing"
	"time"
)

func TestX01(t *testing.T) {
	d := 1 * time.Second
	fmt.Printf("~~~ %d\n", d.Microseconds())
}
