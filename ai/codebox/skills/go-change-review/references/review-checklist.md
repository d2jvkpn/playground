# Go Review Checklist

## Correctness

- Does the implementation satisfy the requested behavior?
- Are boundary conditions handled?
- Are nil and zero values handled correctly?
- Are partial failures handled?
- Can data be silently lost or overwritten?
- Are return values and errors checked?

## Error handling

- Are errors wrapped with useful context?
- Can callers use `errors.Is` or `errors.As` when needed?
- Are sentinel errors used consistently?
- Are retries limited and safe?
- Are cleanup errors handled when relevant?

Prefer contextual errors:

```go
return fmt.Errorf("load session %q: %w", sessionID, err)
```

## Resource lifecycle

Check whether the code correctly closes or releases:

- files;
- HTTP response bodies;
- database rows and statements;
- transactions;
- timers and tickers;
- goroutines;
- channels;
- network connections.

Check every early-return path.

## Context handling

- Is `context.Context` passed through call boundaries?
- Is context stored in a struct unnecessarily?
- Are cancellations and deadlines respected?
- Does background work accidentally use request-scoped context?
- Are blocking calls context-aware?

## Concurrency

- Is shared mutable state protected?
- Can goroutines leak?
- Can channel operations block forever?
- Is channel ownership clear?
- Are channels closed by the sender?
- Is code safe under concurrent calls?
- Would `go test -race` add meaningful coverage?

## Database code

- Are transactions committed or rolled back correctly?
- Is rollback deferred safely?
- Are rows and statements closed?
- Are queries parameterized?
- Are `sql.ErrNoRows` and cancellation handled?
- Are schema and application changes rollout-compatible?
- Can retries duplicate writes?

## HTTP and API code

- Are status codes correct?
- Are request bodies bounded and validated?
- Are response bodies closed?
- Are timeouts configured?
- Are authentication and authorization distinct?
- Are sensitive values excluded from logs?
- Are public JSON fields backward compatible?

## Tests

- Is changed behavior covered?
- Are success, failure, and boundary cases tested?
- Do tests assert behavior rather than implementation details?
- Are tests deterministic?
- Can tests run in parallel safely?
- Do table-driven test names explain the scenario?
- Would a small fake be clearer than a mock?

## Maintainability

- Is the implementation more complex than necessary?
- Is duplication meaningful or accidental?
- Are abstractions introduced too early?
- Are names accurate?
- Do comments explain why rather than restate what?
- Does the change follow surrounding conventions?

## Scope

- Are unrelated files modified?
- Is there an unnecessary dependency upgrade?
- Is generated output mixed with handwritten changes?
- Does the diff contain debugging code?
- Are temporary logs or commented-out blocks left behind?
