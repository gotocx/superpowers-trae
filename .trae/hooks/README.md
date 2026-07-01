# Trae hooks

This directory implements the Trae equivalent of upstream Superpowers hook injection and adds Trae-specific guardrails.

## Files

- `.trae/hooks.json`: project hook registration for Trae.
- `session-start.ps1`: emits the full `using-superpowers` skill as `SessionStart` additional context.
- `user-prompt-submit.ps1`: emits a compact per-turn reminder on `UserPromptSubmit`.
- `pre-run-command-guard.ps1`: checks `PreToolUse` `RunCommand` payloads for common install and cleanup mistakes.
- `validate-package.ps1`: local smoke test for rules, hooks, memory payload, required skills, upstream support scripts, and hook output.

## Why this differs from upstream

`obra/superpowers` ships Claude/Cursor plugin hooks that resolve a plugin root and output harness-specific JSON. Trae project hooks live at `.trae/hooks.json`; for `SessionStart` and `UserPromptSubmit`, Trae can consume stdout directly as additional model context. For `PreToolUse`, Trae reads JSON hook decisions, so the guard emits `permissionDecision` values.

This package ports the upstream behavior instead of copying the exact upstream command lines. Upstream `run-hook.cmd`, `session-start`, and `session-start-codex` depend on plugin root variables such as `CLAUDE_PLUGIN_ROOT`; the Trae package uses PowerShell scripts rooted at project `.trae/`.

## Upstream event audit

At upstream commit `f268f7c953744036f0fa7e9d4b73535c04e57cb8`, the shipped hook configs register only `SessionStart`. Trae `UserPromptSubmit` and `PreToolUse` are package hardening layers, not missing upstream hook migrations.

Run validation from the target project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
```
