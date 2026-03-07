---
name: golang-backend
description: Implement and maintain Go backend services in this repo: layering (transport/service/repo), error handling, context rules, database access with PostgreSQL, migrations, and test strategy.
license: MIT
compatibility: opencode
metadata:
  language: go
  domain: backend
  db: postgres
---

## What I do

- Implement Go backend features with clean layering: `transport (HTTP)` → `service (use cases)` → `repo (DB)`.
- Enforce consistent error handling (`%w`, sentinel/typed errors) and `context.Context` propagation.
- Add or update PostgreSQL migrations when schema changes are required.
- Add unit tests (primarily service layer) and minimal integration tests when needed.

## When to use me

Use this skill when you need to:
- Add a new API endpoint / handler in Go
- Implement a new business use case in Go service layer
- Modify repository/SQL queries or add migrations
- Improve reliability, logging, or test coverage for Go backend code

## How to work (step-by-step)

1) **Identify entry point**
- If it’s an API change: find or create the handler in `internal/transport/http/...`
- Keep handler thin: parse/validate → call service → map response

2) **Implement business logic in service**
- Put rules, orchestration, permissions/state checks in `internal/service/...`
- Service should not depend on HTTP types

3) **Access data via repo**
- Add/modify DB access in `internal/repo/...`
- Use parameterized queries; never build SQL by string concatenation

4) **Errors**
- Wrap infra errors with context: `fmt.Errorf("repo.get user: %w", err)`
- Promote known errors to service-level sentinel/typed errors that handler can map to status codes

5) **Context**
- Handler receives `ctx := r.Context()` and passes it all the way down
- DB calls must take `ctx`

6) **Migrations**
- If schema changes: add a migration file under `migrations/`
- Migrations must be runnable in CI/dev without manual steps

7) **Tests**
- Add table-driven unit tests for service logic
- If repo logic is non-trivial, add integration test (e.g., against a test DB)

## Output format requirements (for agents)

When you propose changes, provide:
- A file list (new/modified)
- A short rationale per file
- Diffs or patch-ready edits (avoid unrelated refactors)

## Do / Don’t

### Do
- Keep changes minimal and focused
- Follow existing repo conventions and existing libraries already in use
- Prefer clarity over cleverness

### Don’t
- Don’t introduce new frameworks or dependencies unless absolutely necessary
- Don’t move files or “cleanup” unrelated code
- Don’t add timeouts deep in the stack (timeouts belong at edges/middleware)

## Quick checklist (self-review)

- [ ] Handler only does parse/validate/response mapping
- [ ] Service contains business logic and uses repo interfaces
- [ ] Repo uses parameterized SQL and `ctx`
- [ ] Errors are wrapped with `%w` and are mappable to API errors
- [ ] Migration added if schema changed
- [ ] Unit tests added/updated for core paths
