---
name: research-assistant
description: Run the claudesidian command spec at .claude/commands/research-assistant.md. Use when the user asks for research-assistant workflow or its slash-command equivalent.
---

# research-assistant (Codex Command Wrapper)

Run this workflow by following the command spec in ".claude/commands/research-assistant.md".

## Required behavior

1. Confirm ".claude/commands/research-assistant.md" exists in the current workspace.
2. Read and follow that file exactly.
3. Treat the user's current request as the command argument/context.
4. Complete the workflow end-to-end instead of only summarizing steps.
5. If the file is missing, ask the user for the vault root path and stop.
