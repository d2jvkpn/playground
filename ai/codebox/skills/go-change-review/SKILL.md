---
name: go-change-review
description: >
  Review and validate current Go code changes, including staged, unstaged,
  and untracked files; correctness; error handling; concurrency; tests;
  formatting; and static analysis. This workflow is configured for explicit
  user invocation only.
license: MIT
compatibility: Requires Git, Bash, and a Go toolchain.
metadata:
  version: "3.0.0"
  invocation: "manual-only"
disable-model-invocation: true
---

# Go Change Review

Review current Go code changes for correctness, scope, maintainability, and
test coverage.

## Invocation policy

Run this workflow only after the user explicitly invokes the corresponding
skill or command.

Do not interpret an ordinary natural-language request as permission to load
this packaged workflow automatically.

## Determine the requested mode

Use the user's invocation arguments and current conversation to determine
whether the user wants:

- review only;
- review and focused fixes;
- a restricted file, package, or commit range;
- emphasis on a particular risk;
- narrow tests or full-project verification.

When the user requests review only, do not modify files.

When no explicit file, commit, or range is supplied, inspect the current
working tree, including staged, unstaged, and untracked Go files.

## Workflow

### 1. Read repository instructions

Before reviewing or modifying code, read applicable project instructions:

1. `AGENTS.md`
2. `CLAUDE.md`, when present
3. relevant `README.md` files
4. `Makefile`, `Taskfile.yml`, or equivalent build configuration
5. module-specific documentation near the changed files

Repository instructions override generic commands in this skill.

### 2. Inspect repository state

Run:

```bash
git status --short
git diff --stat
git diff
git diff --cached
```

Identify:

- modified, created, and deleted files;
- staged and unstaged changes;
- untracked files;
- generated files;
- unrelated pre-existing changes.

Do not discard, overwrite, stage, or amend existing user changes.

### 3. Understand the implementation

Read the complete surrounding implementation, not only changed lines.

Inspect:

- callers and callees;
- interfaces and implementations;
- related tests;
- configuration;
- database migrations;
- error types;
- public API contracts.

Determine intended behavior before proposing a change.

### 4. Review the code

Read `references/review-checklist.md` and apply it as the detailed checklist.

Prioritize findings in this order:

1. correctness and data-loss risks;
2. security issues;
3. concurrency and lifecycle problems;
4. incompatible API changes;
5. missing error handling;
6. missing or incorrect tests;
7. unnecessary complexity;
8. style and maintainability.

Do not report purely stylistic preferences as defects unless they conflict
with repository conventions.

### 5. Decide whether to modify files

When the user requests review only:

- do not modify files;
- report findings with file and line references;
- propose focused fixes.

When the user requests fixes:

- modify only files required by the requested task;
- preserve unrelated user changes;
- avoid broad refactoring;
- add or update tests for changed behavior.

### 6. Format and verify

When files were changed, run:

```bash
bash scripts/verify.sh
```

If the repository defines canonical verification commands, prefer those
commands over generic defaults.

Run the narrowest relevant tests first, followed by broader tests when
practical.

### 7. Handle failures

When verification fails:

1. determine whether the failure is caused by current changes;
2. capture the exact command and relevant error;
3. fix it only when it belongs to the requested scope;
4. rerun the affected check;
5. disclose every unresolved failure.

Never:

- delete a failing test merely to obtain a passing build;
- add blanket lint suppressions without justification;
- weaken assertions merely to make tests pass;
- claim success when commands failed or were not run.

## Constraints

Do not run the following unless explicitly requested:

```text
git add
git commit
git push
git reset --hard
git checkout -- <file>
git clean
git rebase
git merge
```

Also:

- do not change public APIs silently;
- do not manually edit generated files;
- do not expose secrets from configuration or environment files;
- do not refactor unrelated code;
- do not upgrade dependencies without a concrete need;
- do not run production migrations;
- do not use destructive database commands.

## Completion criteria

The task is complete only when:

- relevant changes have been inspected;
- important callers and tests have been reviewed;
- requested fixes are implemented;
- modified Go files are formatted;
- relevant tests have been run;
- unresolved failures and risks are clearly disclosed.

## Final response

Use this structure:

### Findings

List defects and risks in descending severity. Include file paths and line
numbers when possible.

### Changes

Describe files changed and the purpose of each change. If no files were
modified, state that explicitly.

### Verification

List exact commands executed and their results.

### Remaining risks

State tests that could not run, environmental limitations, assumptions, and
unresolved concerns.

Do not claim the code is ready to commit unless all material checks completed
successfully.
