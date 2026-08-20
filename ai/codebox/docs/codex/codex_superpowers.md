# Global Coding Workflow

## General

Use Codex native capabilities as the primary agent harness.

Use Superpowers skills selectively for software engineering methodology.
Do not automatically follow the complete Superpowers workflow.

## Superpowers

Use these skills when appropriate:

- `brainstorming`
  - Use for new features, architectural changes, ambiguous requirements,
    or work involving significant design decisions.
  - Do not use for trivial fixes or straightforward changes.

- `systematic-debugging`
  - Use for non-trivial bugs, unexplained failures, regressions,
    or when an initial obvious fix does not solve the problem.

- `verification-before-completion`
  - Use before declaring substantial implementation or bug-fix work complete.
  - Verify using actual tests, builds, linting, or runtime checks where appropriate.

- `writing-plans`
  - Use for large or multi-step implementations after the design is sufficiently clear.
  - Do not require it for small changes.

- `requesting-code-review`
  - Use when useful for substantial changes.

## Codex-native orchestration

Prefer Codex native capabilities for:

- planning
- subagents
- parallel agents
- worktrees
- implementation orchestration
- code review

Do not automatically invoke these Superpowers skills unless explicitly requested
or clearly beneficial:

- `using-git-worktrees`
- `dispatching-parallel-agents`
- `subagent-driven-development`
- `executing-plans`
- `finishing-a-development-branch`

## TDD

Do not enforce strict TDD globally.

Use `test-driven-development` when:
- explicitly requested,
- fixing regressions where a failing test should be captured first,
- implementing critical logic that benefits from test-first development.

Otherwise, require appropriate tests but do not require RED-GREEN-REFACTOR.

## Workflow

For substantial feature work, prefer:

1. Understand repository context and existing architecture.
2. Use `brainstorming` when design work is needed.
3. Record significant design decisions in the repository documentation.
4. Produce an implementation plan when the work is sufficiently complex.
5. Execute using Codex native subagents when parallelization or context isolation helps.
6. Run relevant tests and checks.
7. Use `verification-before-completion`.
8. Perform code review for substantial changes.

For simple and obvious changes, keep the workflow lightweight.
