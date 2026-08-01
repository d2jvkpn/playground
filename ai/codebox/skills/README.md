# Manual-Only Cross-Agent Skill Example

This package contains a reusable Go change-review workflow configured for
**manual invocation only** in:

- Claude Code
- OpenAI Codex
- Pi Coding Agent
- OpenCode

The skill is model-independent. It does not hard-code a provider or model.
Each coding agent uses the model currently selected in that agent, including
OpenAI, Anthropic, Google, Moonshot, DeepSeek, local models, and compatible
third-party providers supported by the host agent.

## Package layout

```text
manual-go-change-review-skill/
├── README.md
├── go-change-review/
│   ├── SKILL.md
│   ├── agents/
│   │   └── openai.yaml
│   ├── references/
│   │   └── review-checklist.md
│   └── scripts/
│       └── verify.sh
├── install.sh
└── config-snippets/
    ├── claude-settings.local.json
    ├── codex-openai.yaml
    ├── opencode-manual-only.jsonc
    └── pi-settings.json
```

`go-change-review/` is the single source package. The installer copies it to
`.agents/skills/go-change-review` and creates a Claude-compatible symbolic
link at `.claude/skills/go-change-review`.

## Manual-only behavior by agent

| Agent | Manual-only mechanism | Manual invocation |
|---|---|---|
| Claude Code | `disable-model-invocation: true` in `SKILL.md` | `/go-change-review ...` |
| Codex | `allow_implicit_invocation: false` in `agents/openai.yaml` | `$go-change-review ...` |
| Pi | `disable-model-invocation: true` in `SKILL.md` | `/skill:go-change-review ...` |
| OpenCode | Native skill access is denied; an explicit custom command reads the same `SKILL.md` | `/go-change-review ...` |

## Install into a project

Run the installer from this package directory:

```bash
./install.sh /path/to/repository
```

When the target project is the current directory:

```bash
./install.sh
```

To replace an existing installation of this example:

```bash
./install.sh /path/to/repository --force
```

The installer performs these operations:

1. Copies `go-change-review/` to:

   ```text
   .agents/skills/go-change-review/
   ```

2. Creates a Claude Code symbolic link:

   ```text
   .claude/skills/go-change-review
     -> ../../.agents/skills/go-change-review
   ```

3. Copies `config-snippets/opencode-manual-only.jsonc` to the project root
   as `opencode.jsonc` only when neither `opencode.json` nor
   `opencode.jsonc` already exists.

4. Creates `.pi/settings.json` only when it does not already exist.

Existing OpenCode and Pi configuration files are not overwritten. When they
already exist, merge the matching file from `config-snippets/`. When no
OpenCode configuration exists, the installer copies
`config-snippets/opencode-manual-only.jsonc` to the project root as
`opencode.jsonc`.

## Claude Code

Claude Code discovers project skills from:

```text
.claude/skills/<skill-name>/SKILL.md
```

The installer creates a symbolic link so Claude Code and the other agents use
the same physical skill files.

The shared `SKILL.md` includes:

```yaml
disable-model-invocation: true
```

This hides the skill from Claude's model-visible skill catalog and prevents
Claude from invoking it automatically. The user can still invoke it directly:

```text
/go-change-review Review the current changes without modifying files.
```

### Alternative Claude configuration

When you cannot or do not want to edit a third-party `SKILL.md`, Claude Code
also supports a visibility override in `.claude/settings.local.json`:

```json
{
  "skillOverrides": {
    "go-change-review": "user-invocable-only"
  }
}
```

This alternative is included at:

```text
config-snippets/claude-settings.local.json
```

It is not required for this package because the shared `SKILL.md` already
contains `disable-model-invocation: true`.

## OpenAI Codex

Codex discovers the project skill at:

```text
.agents/skills/go-change-review/SKILL.md
```

Codex-specific behavior is configured in:

```text
.agents/skills/go-change-review/agents/openai.yaml
```

The relevant setting is:

```yaml
policy:
  allow_implicit_invocation: false
```

This prevents Codex from choosing the skill from an ordinary natural-language
prompt. Explicit invocation remains available:

```text
$go-change-review Review the current changes without modifying files.
```

The Codex adapter does not contain a model field, so it uses the model selected
for the current Codex session.

A copy of the Codex-specific configuration is included at:

```text
config-snippets/codex-openai.yaml
```

That copy is documentation and merge reference only. The active file is the
one inside `go-change-review/agents/`.

## Pi Coding Agent

Pi discovers the project skill from:

```text
.agents/skills/go-change-review/SKILL.md
```

The shared frontmatter contains:

```yaml
disable-model-invocation: true
```

Pi therefore hides the skill from the system prompt. The model cannot select
it automatically, and the user must invoke it explicitly:

```text
/skill:go-change-review Review the current changes without modifying files.
```

Skill commands must be enabled. The installer creates this project setting
when `.pi/settings.json` does not already exist:

```json
{
  "enableSkillCommands": true
}
```

When the project already has `.pi/settings.json`, merge the file:

```text
config-snippets/pi-settings.json
```

The setting does not select a provider or model.

## OpenCode

OpenCode can discover skills from `.agents/skills`, but its standard Agent
Skills implementation does not provide a portable manual-only field equivalent
to Claude Code and Pi.

For strict manual-only behavior, this package uses two controls in
`opencode.jsonc`.

### 1. Deny native skill loading

```jsonc
"permission": {
  "skill": {
    "go-change-review": "deny"
  }
}
```

This hides the native skill from OpenCode agents and rejects model-initiated
skill loading.

Do not replace `deny` with `ask` when strict manual-only behavior is required.
`ask` still permits the model to select the skill and only adds an approval
prompt.

### 2. Define an explicit custom command

```jsonc
"command": {
  "go-change-review": {
    "description": "Manually run the shared Go change review workflow",
    "template": "..."
  }
}
```

The command template includes:

```text
@.agents/skills/go-change-review/SKILL.md
@.agents/skills/go-change-review/references/review-checklist.md
```

OpenCode expands these file references only after the user invokes:

```text
/go-change-review Review the current changes without modifying files.
```

The custom command has no `model` property. OpenCode therefore uses the
currently active agent and model.

## Existing OpenCode configuration

When the project already has `opencode.json` or `opencode.jsonc`, the installer
does not overwrite it.

Merge the contents of:

```text
config-snippets/opencode-manual-only.jsonc
```

The required sections are:

```jsonc
{
  "permission": {
    "skill": {
      "go-change-review": "deny"
    }
  },
  "command": {
    "go-change-review": {
      "description": "Manually run the shared Go change review workflow",
      "template": "..."
    }
  }
}
```

Preserve existing providers, models, MCP servers, agents, permissions, and
commands.

OpenCode merges configuration from multiple locations, but a project-root
configuration may override global defaults. Check for later or more specific
permission rules that re-enable the skill.

## Purpose of `config-snippets`

`config-snippets/` contains merge references for projects that already have
configuration files.

These files are not loaded automatically from this package directory:

| File | Purpose |
|---|---|
| `claude-settings.local.json` | Optional Claude Code user-only visibility override |
| `codex-openai.yaml` | Reference copy of the active Codex invocation policy |
| `opencode-manual-only.jsonc` | Complete manual-only OpenCode configuration; copy it into a new project or merge its sections into an existing config |
| `pi-settings.json` | Property to merge into an existing Pi project settings file |

After installation and successful configuration merging, the snippets are not
required at runtime.

## Manual invocation summary

```text
Claude Code:
/go-change-review Review current Go changes.

Codex:
$go-change-review Review current Go changes.

Pi:
/skill:go-change-review Review current Go changes.

OpenCode:
/go-change-review Review current Go changes.
```

## Expected non-trigger behavior

The following ordinary prompts must not load this packaged skill automatically:

```text
Review the current Go changes.
Check whether this branch is ready to commit.
Run Go tests and inspect the diff.
```

An agent may independently perform similar work using its normal instructions
and tools. Manual-only configuration controls loading of this packaged skill;
it does not prohibit the model from understanding or answering an ordinary
request.

To guarantee that this workflow is used, invoke the explicit command for the
selected coding agent.

## Workflow behavior

The skill reviews:

- staged, unstaged, and untracked Go changes;
- correctness and data-loss risks;
- error handling;
- resource lifecycle;
- concurrency;
- API compatibility;
- test coverage;
- formatting and static analysis.

The included verification script runs:

```text
gofmt -l <changed Go files>
go test ./...
go vet ./...
staticcheck ./...    # only when installed
```

The script does not automatically modify files.

## Safety behavior

The workflow does not run these commands unless explicitly requested:

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

It also prohibits unrelated refactoring, destructive database commands,
production migrations, silent public API changes, and manual editing of
generated files.

Review every skill and bundled script before installing it into a trusted
repository.

## Troubleshooting

### Claude Code does not show `/go-change-review`

Check:

```bash
ls -l .claude/skills/go-change-review
test -f .claude/skills/go-change-review/SKILL.md
```

Restart Claude Code after installing a new skill.

### Codex does not show the skill

Check:

```bash
test -f .agents/skills/go-change-review/SKILL.md
test -f .agents/skills/go-change-review/agents/openai.yaml
```

Invoke it explicitly using `$go-change-review`.

### Pi does not register the command

Check `.pi/settings.json`:

```json
{
  "enableSkillCommands": true
}
```

Restart Pi and invoke `/skill:go-change-review`.

### OpenCode still advertises the native skill

Confirm that the final merged OpenCode configuration contains:

```jsonc
"permission": {
  "skill": {
    "go-change-review": "deny"
  }
}
```

OpenCode permission object rules use last-match-wins behavior. Ensure no later
matching rule changes the result to `allow` or `ask`.

### OpenCode command cannot read the skill

Run OpenCode from the project root or a descendant of the same Git worktree,
and confirm:

```bash
test -f .agents/skills/go-change-review/SKILL.md
```

## Official documentation

- Claude Code skills:
  https://code.claude.com/docs/en/skills
- OpenAI Codex skills:
  https://developers.openai.com/codex/build-skills
- Pi skills:
  https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md
- Pi settings:
  https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/settings.md
- OpenCode skills:
  https://opencode.ai/docs/skills/
- OpenCode commands:
  https://opencode.ai/docs/commands/
- OpenCode permissions:
  https://opencode.ai/docs/permissions/
