---
name: pragmatic-review
description: Run the claudesidian command spec at .claude/commands/pragmatic-review.md. Use when the user asks for pragmatic-review workflow or its slash-command equivalent.
---

# pragmatic-review (Codex Command Wrapper)

Run this workflow by following the command spec in ".claude/commands/pragmatic-review.md".

## Required behavior

1. Confirm ".claude/commands/pragmatic-review.md" exists in the current workspace.
2. Read and follow that file exactly.
3. Treat the user's current request as the command argument/context.
4. Complete the workflow end-to-end instead of only summarizing steps.
5. If the file is missing, ask the user for the vault root path and stop.
