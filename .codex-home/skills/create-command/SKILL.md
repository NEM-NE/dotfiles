---
name: create-command
description: Run the claudesidian command spec at .claude/commands/create-command.md. Use when the user asks for create-command workflow or its slash-command equivalent.
---

# create-command (Codex Command Wrapper)

Run this workflow by following the command spec in ".claude/commands/create-command.md".

## Required behavior

1. Confirm ".claude/commands/create-command.md" exists in the current workspace.
2. Read and follow that file exactly.
3. Treat the user's current request as the command argument/context.
4. Complete the workflow end-to-end instead of only summarizing steps.
5. If the file is missing, ask the user for the vault root path and stop.
