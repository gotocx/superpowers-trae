# Superpowers for Trae

Trae project package for the Superpowers agentic workflow. The install payload is `./.trae`.

This repository is a bootstrap package, not a runtime dependency. After installation and cleanup, the target project's `.trae` directory must contain only:

- `hooks.json`
- `rules/`
- `skills/`

No separate memory setup is required. The persistent Superpowers reminders live in `.trae/rules/superpowers.md`.

## AI install prompt

Open the target project in Trae, clone this repository if needed, then give the agent this prompt:

```text
Install Superpowers for Trae into the current project.

Use the cloned `gotocx/superpowers-trae` repository as the bootstrap source. Follow `README.md` and `.trae/INSTALL.md` as instruction documents only; do not execute Markdown files.

Before copying or deleting anything, compute and report:
- source_root
- target_root
- target_trae_path

Then follow the install gates:
1. Detect whether this is bootstrap mode, nested mode from target root, or nested mode while standing inside the bootstrap clone.
2. Verify `target_trae_path` is the real target project's `.trae`, not the bootstrap clone's `.trae`.
3. Copy or refresh rules, hooks.json, hooks/, and all official skills from `source_root/.trae`.
4. Before cleanup, run:
   powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
5. Cleanup only after validation passes.
6. Delete only install-time files: `.trae/INSTALL.md`, `.trae/UPSTREAM.md`, `.trae/hooks/`, and any stale legacy memory directory if present.
7. Do not delete `.trae/hooks.json`.
8. Delete the bootstrap clone only if nested-mode path checks prove it is safe.
9. Final `.trae` must contain only `hooks.json`, `rules/`, and `skills/`.
10. Report evidence for each gate.
```

## Hook validation

Before cleanup, from the target project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
```

The validator checks:

- `hooks.json` defines `SessionStart`, `UserPromptSubmit`, and `PreToolUse`.
- Encoded hook commands match the install-time templates.
- Runtime hooks are self-contained and do not depend on `.trae/hooks/` after cleanup.
- Required rules, skills, and upstream support scripts exist.
- SessionStart, UserPromptSubmit, and PreToolUse smoke tests pass.

## Runtime hooks

The final runtime hook config is `.trae/hooks.json`.

- `SessionStart`: injects `using-superpowers`.
- `UserPromptSubmit`: injects a compact workflow reminder.
- `PreToolUse` with matcher `RunCommand`: blocks common install/cleanup mistakes and asks before destructive git cleanup.

`.trae/hooks/` is an install-time template and validation directory. It is deleted after validation. `hooks.json` must remain.

## Manual Trae acceptance checklist

After installation, open the target project in Trae and verify:

1. `SessionStart` injects the `using-superpowers` bootstrap.
2. A normal prompt receives the compact Superpowers reminder.
3. `RunCommand` `git status --short` is allowed.
4. `RunCommand` `powershell -File ./.trae/INSTALL.md` is denied.
5. `RunCommand` `Remove-Item .\.trae\hooks.json -Force` is denied.
6. `RunCommand` `Remove-Item .\.trae\hooks -Recurse -Force` is allowed only during the post-validation cleanup step.

## Upstream sync

Upstream source: `obra/superpowers`.

This package keeps the upstream skills current and adapts hooks/rules to Trae's project-local `.trae` runtime. See `.trae/UPSTREAM.md` before cleanup for the audited upstream commit and generated flat skills.
