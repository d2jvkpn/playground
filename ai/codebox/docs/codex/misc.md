#### 1.
```
                 User
                   │
                   ▼
        Codex parent / architect
                   │
       ┌───────────┴────────────┐
       │                        │
Superpowers               repo context
brainstorming              AGENTS.md
       │                        │
       └───────────┬────────────┘
                   ▼
               design.md
                   │
                   ▼
          Codex /plan
              或
   Superpowers writing-plans
                   │
                   ▼
                plan.md
                   │
             ──────┼──────
                   ▼
          fresh execution context
                   │
                   ▼
          Codex native subagents
          ┌────────┼────────┐
          ▼        ▼        ▼
       task A    task B   exploration
          │        │        │
          └────────┼────────┘
                   ▼
              integration
                   │
                   ▼
 Superpowers verification-before-completion
                   │
                   ▼
             Codex /review
```

#### 2.
```
AGENTS.md
      │
      ├── project conventions
      ├── architecture
      ├── verification
      └── agent rules

Superpowers
      │
      ├── brainstorming
      ├── systematic-debugging
      ├── writing-plans
      └── verification-before-completion

Codex
      │
      ├── /plan
      ├── native subagents
      ├── worktrees
      ├── implementation
      └── /review

docs/
      ├── architecture/
      ├── designs/
      └── plans/
```

#### 3.
```
                 request
                    │
                    ▼
            complexity check
               /          \
            simple       substantial
              │              │
              │       $brainstorming
              │              │
              │           design
              │              │
              │        plan if needed
              │              │
              └──────┬───────┘
                     ▼
             Codex execution
                     │
             native subagents
                     │
                     ▼
                   tests
                     │
                     ▼
 $verification-before-completion
                     │
                     ▼
                  review
```

#### 4.
```
implementation
↓
build
↓
tests
↓
lint
↓
runtime verification
↓
completion
```
