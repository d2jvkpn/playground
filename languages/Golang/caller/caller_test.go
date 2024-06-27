package main

import (
	"runtime"
	"testing"
)

type Trace struct {
	Fn   string
	File string
	Line int
}

func testF1() Trace {
	trace := Trace{
		Fn:   "",
		File: "",
		Line: 0,
	}

	return trace
}

func testF2() Trace {
	var (
		pc    uintptr
		trace Trace
	)

	pc, trace.File, trace.Line, _ = runtime.Caller(1)

	trace.Fn = runtime.FuncForPC(pc).Name()
	return trace
}

// go test -run none -bench=F1 -benchmem -count=8
func BenchmarkCallerF1(b *testing.B) {
	for i := 0; i < b.N; i++ {
		testF1()
	}
}

// go test -run None -bench=F2 -benchmem -count=8
func BenchmarkCallerF2(b *testing.B) {
	for i := 0; i < b.N; i++ {
		testF2()
	}
}

/*
go test -run none -bench=. -benchmem -count=8

BenchmarkCallerF1-16    	1000000000	         0.4023 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.3955 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4328 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4264 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4322 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4127 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4317 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF1-16    	1000000000	         0.4110 ns/op	       0 B/op	       0 allocs/op
BenchmarkCallerF2-16    	 1000000	      1024 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1201866	      1005 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1000000	      1021 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1000000	      1023 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1205571	       959.3 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1354831	       926.9 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1239904	       943.0 ns/op	     232 B/op	       2 allocs/op
BenchmarkCallerF2-16    	 1228904	       915.9 ns/op	     232 B/op	       2 allocs/op
*/
