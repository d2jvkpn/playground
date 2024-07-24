package main

import (
	"fmt"
	"regexp"
)

func main() {
	re := regexp.MustCompile("^(?i)hello$")

	fmt.Printf("~~~ %t\n", re.MatchString("HellO"))
}
