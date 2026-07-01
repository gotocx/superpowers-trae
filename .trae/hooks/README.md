# Trae hooks

This install-time directory contains hook templates, documentation, and validation for the Trae hook migration. Final user installs remove this directory after validation because `.trae/hooks.json` is self-contained.

## Files

- `.trae/hooks.json`: self-contained project hook registration for Trae.
- `session-start.ps1`: install-time template for the encoded `SessionStart` command.
- `user-prompt-submit.ps1`: install-time template for the encoded `UserPromptSubmit` command.
- `pre-run-command-guard.ps1`: install-time template for the encoded `PreToolUse` `RunCommand` guard.
- `validate-package.ps1`: local smoke test for rules, hooks, memory payload, required skills, upstream support scripts, and hook output.

## Why this differs from upstream

`obra/superpowers` ships Claude/Cursor plugin hooks that resolve a plugin root and output harness-specific JSON. Trae project hooks live at `.trae/hooks.json`; for `SessionStart` and `UserPromptSubmit`, Trae can consume stdout directly as additional model context. For `PreToolUse`, Trae reads JSON hook decisions, so the guard emits `permissionDecision` values.

This package ports the upstream behavior instead of copying the exact upstream command lines. Upstream `run-hook.cmd`, `session-start`, and `session-start-codex` depend on plugin root variables such as `CLAUDE_PLUGIN_ROOT`; the Trae package encodes PowerShell hook templates directly into `.trae/hooks.json`.

## Upstream event audit

At upstream commit `f268f7c953744036f0fa7e9d4b73535c04e57cb8`, the shipped hook configs register only `SessionStart`. Trae `UserPromptSubmit` and `PreToolUse` are package hardening layers, not missing upstream hook migrations.

After install cleanup, `.trae/hooks/` must be removed from the target project. Runtime hooks live only in `.trae/hooks.json`.

Run validation from the target project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
```
