package main

import (
	"crypto/tls"
	// "fmt"
	"net"
	"time"
)

type Options struct {
	err error

	tlsCrt string
	tlsKey string
	cert   tls.Certificate

	addr     string
	listener net.Listener

	readTimeout       time.Duration
	writeTimeout      time.Duration
	readHeaderTimeout time.Duration
	maxHeaderBytes    int
}

func NewOptions() *Options {
	return &Options{
		readTimeout:       10 * time.Second,
		writeTimeout:      10 * time.Second,
		readHeaderTimeout: 2 * time.Second,
		maxHeaderBytes:    2 << 11,
	}
}

func (opts *Options) Tls(tlsCrt, tlsKey string) *Options {
	if opts.err != nil {
		return opts
	}

	opts.cert, opts.err = tls.LoadX509KeyPair(tlsCrt, tlsKey)
	return opts
}

func (opts *Options) Addr(addr string) *Options {
	if opts.err != nil {
		return opts
	}

	opts.listener, opts.err = net.Listen("tcp", addr)
	return opts
}

func (opts *Options) ReadTimeout(d time.Duration) *Options {
	if opts.err != nil {
		return opts
	}

	if d > 0 {
		opts.readTimeout = d
	}
	return opts
}

func (opts *Options) WriteTimeout(d time.Duration) *Options {
	if opts.err != nil {
		return opts
	}

	if d > 0 {
		opts.writeTimeout = d
	}
	return opts
}

func (opts *Options) ReadHeaderTimeout(d time.Duration) *Options {
	if opts.err != nil {
		return opts
	}

	if d > 0 {
		opts.readHeaderTimeout = d
	}
	return opts
}

func (opts *Options) MaxHeaderBytes(bytes int) *Options {
	if opts.err != nil {
		return opts
	}

	if bytes > 0 {
		opts.maxHeaderBytes = bytes
	}

	return opts
}

func (opts *Options) Err() (err error) {
	if opts.err != nil {
		return opts.err
	}

	// more validations...
	return nil
}
