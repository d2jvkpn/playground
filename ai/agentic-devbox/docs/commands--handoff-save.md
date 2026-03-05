---
description: Generate a /handoff-style summary and save it into a markdown file
agent: build
---

You are generating a handoff document (same intent as /handoff), but you MUST save it to a file.

Target file path:
- If $ARGUMENTS is not empty, use it as the file path.
- Otherwise default to HANDOFF.md at repo root.

Before writing, gather lightweight repo context (do NOT dump huge files):
- git status, recent commits, diff stats, and current date/time.

Context:
- Now: !`date -Iseconds`
- Branch: !`git rev-parse --abbrev-ref HEAD`
- Status: !`git status --porcelain=v1`
- Recent commits: !`git log --oneline -10`
- Diff stat: !`git diff --stat`

Write a Markdown document with these sections:
1) Overview (goal, why)
2) What’s done (bullet list)
3) What’s next (ordered checklist)
4) Key decisions & constraints (MUST/MUST-NOT)
5) Important files & entry points (paths + 1-line notes)
6) How to verify (commands to run + expected outcome)
7) Risks / gotchas

Then save it to the target file path using the edit tool (create if missing, replace if exists).
Finally, reply with:
- ✅ Saved path
- A short 5-line excerpt of the top of the file
- The exact command the user should run next session to continue (e.g., “Paste this HANDOFF.md into a new session”).
