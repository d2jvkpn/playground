package tests

import (
	"context"
	"flag"
	// "fmt"
	"log"

	"demo-api/proto"

	"github.com/d2jvkpn/gotk/cloud-logging"
	"google.golang.org/grpc"
)

type GrpcClient struct {
	conn *grpc.ClientConn
	proto.LogServiceClient
}

func NewGrpcClient(conn *grpc.ClientConn) *GrpcClient {
	return &GrpcClient{
		conn:             conn,
		LogServiceClient: proto.NewLogServiceClient(conn),
	}
}

func grpcClient(args []string) {
	var (
		addr    string
		tls     bool
		err     error
		flagSet *flag.FlagSet
		ctx     context.Context
		conn    *grpc.ClientConn
		client  *GrpcClient
		in      *proto.LogData
		res     *proto.LogId
	)

	/*
		flag.StringVar(&addr, "addr", "localhost:5041", "grpc address")
		flag.BoolVar(&tls, "tls", false, "enable tls")
		flag.Parse()
	*/

	flagSet = flag.NewFlagSet("grpc_client", flag.ContinueOnError)
	flagSet.StringVar(&addr, "addr", "localhost:5041", "grpc address")
	flagSet.BoolVar(&tls, "tls", false, "enable tls")
	flagSet.Parse(args)

	defer func() {
		if conn != nil {
			conn.Close()
		}

		if err != nil {
			log.Fatal(err)
		}
	}()

	ctx = context.TODO()

	inte := logging.GrpcCliLogger{
		Headers: map[string]string{"hello": "world"},
	}

	opts := []grpc.DialOption{
		grpc.WithUnaryInterceptor(inte.Unary()),
		grpc.WithStreamInterceptor(inte.Stream()),
	}
	if !tls {
		opts = append(opts, grpc.WithInsecure())
	}

	if conn, err = grpc.Dial(addr, opts...); err != nil {
		log.Fatal(err)
	}
	log.Println(">> grpc.Dial:", addr)

	client = NewGrpcClient(conn)

	in = &proto.LogData{
		Name:    "demo-api_test",
		Version: "0.1.0",
	}
	if res, err = client.Push(ctx, in); err != nil {
		return
	}

	log.Printf(">> Create response: %+#v\n", res)
}
