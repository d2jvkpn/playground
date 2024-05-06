package main

import (
	"flag"
	"fmt"
	"log"
	"time"
)

func main() {
	var (
		start     string
		end       string
		startTime time.Time
		endTime   time.Time
		ans       time.Duration
		err       error
	)

	flag.StringVar(&start, "start", "", "start date")
	flag.StringVar(&end, "end", "", "end date")
	flag.Parse()

	if start == "" {
		log.Fatalln("-start is unset")
	}

	if startTime, err = time.ParseInLocation(time.DateOnly, start, time.Local); err != nil {
		log.Fatalln(err)
	}

	endTime = time.Now()
	if end == "" {
		end = endTime.Format(time.DateOnly)
	}

	if endTime, err = time.ParseInLocation(time.DateOnly, end, time.Local); err != nil {
		log.Fatalln(err)
	}

	ans = endTime.Sub(startTime)
	fmt.Printf("Ans: %dd\n", ans/(time.Hour*24))
}
