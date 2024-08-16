package biz

import (
	"context"
	// "fmt"
	"log"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

func Hello(ctx context.Context) (name string) {
	var value int64 = 42

	World(ctx, 42)

	labels := []attribute.KeyValue{
		attribute.Int64("biz.Hello:", value),
	}

	time.Sleep(time.Duration(1000/value) * time.Millisecond)

	span := trace.SpanFromContext(ctx)
	span.SetAttributes(labels...)

	//.. zap.String("traceId", span.SpanContext().TraceID().String())
	log.Printf(
		"==> biz.Hello: trace_id=%s, span_id=%s\n",
		span.SpanContext().TraceID().String(),
		span.SpanContext().SpanID().String(),
	)

	return "d2jvkpn"
}

func World(ctx context.Context, value int64) {
	tracer := otel.Tracer("biz.World")

	_, span := tracer.Start(ctx, "World.xxxx")
	defer span.End()
	time.Sleep(time.Duration(value) * time.Millisecond)

	log.Printf(
		"==> biz.World: trace_id=%s, span_id=%s\n",
		span.SpanContext().TraceID().String(),
		span.SpanContext().SpanID().String(),
	)

	// write to log
	opts := []trace.EventOption{
		trace.WithAttributes(attribute.Int64("World.value", value)),
	}

	span.AddEvent("successfully finished call World", opts...)
}
