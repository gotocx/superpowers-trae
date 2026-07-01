# Superpowers for Trae

Trae project package for the Superpowers agentic workflow. The install payload is `./.trae`.

This repository is a bootstrap package, not a runtime dependency. After installation, the target project's `.trae` directory must contain:

- `hooks.json`
- `hooks/`
- `agents/`
- `rules/`
- `skills/`

No separate memory setup is required. The persistent Superpowers reminders live in `.trae/rules/superpowers.md`.

## AI install prompt

Open the target project in Trae, clone this repository if needed, then give the agent this prompt:

```text
Install Superpowers for Trae into the current project.

Use the cloned `gotocx/superpowers-trae` repository as the bootstrap source. Follow `README.md` and `INSTALL.md` as instruction documents only; do not execute Markdown files.

The install guide is `INSTALL.md` at the repository root.
If a bootstrap clone already exists in the target project, do not run `git clone` again during this install attempt.

Before moving, copying, or refreshing anything, compute and report:
- source_root
- target_root
- target_trae_path

Then follow the install gates:
1. Detect whether this is bootstrap mode, nested mode from target root, or nested mode while standing inside the bootstrap clone.
2. Verify `target_trae_path` is the real target project's `.trae`, not the bootstrap clone's `.trae`.
3. If `target_trae_path` does not exist, move `source_root/.trae` to `target_trae_path`. If `target_trae_path` already exists, copy or refresh hooks.json, hooks/, agents/, rules/, and all official skills from `source_root/.trae`.
4. After moving, copying, or refreshing, run:
   powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
5. After validation, do not modify target `.trae` again.
6. Do not delete `.trae/hooks.json`, `.trae/hooks/`, `.trae/agents/`, `.trae/rules/`, or `.trae/skills/`; they are runtime files.
7. Delete the bootstrap clone only by running `./.trae/hooks/self-prune-source.ps1` from the target project root after validation. In bootstrap mode, do not delete anything automatically.
8. Final `.trae` must contain `hooks.json`, `hooks/`, `agents/`, `rules/`, and `skills/`.
9. If stale legacy entries exist inside target `.trae`, report them instead of deleting them automatically.
10. Report evidence for each gate.
```

## Hook validation

After moving, copying, or refreshing, from the target project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
```

The validator checks:

- `hooks.json` defines `SessionStart`, `UserPromptSubmit`, and `PreToolUse`.
- `hooks.json` directly calls readable scripts in `.trae/hooks/`.
- `.trae/agents/` contains the Superpowers named subagent definitions.
- `.trae/hooks/self-prune-source.ps1` refuses unsafe bootstrap source cleanup.
- Required rules, skills, and upstream support scripts exist.
- SessionStart, UserPromptSubmit, and PreToolUse smoke tests pass.

## Runtime hooks

The final runtime hook config is `.trae/hooks.json`.

- `SessionStart`: injects `using-superpowers`.
- `UserPromptSubmit`: injects a compact workflow reminder.
- `PreToolUse` with matcher `RunCommand`: blocks runtime deletion mistakes and asks before destructive git cleanup.

`.trae/hooks/` is runtime code and must remain installed. Keeping scripts readable makes hook debugging and upgrades straightforward.

`.trae/agents/` is runtime code too. When Trae's Subagents directory support is enabled, Trae auto-loads these named agents:

- `superpowers-implementer`
- `superpowers-task-reviewer`
- `superpowers-code-reviewer`
- `superpowers-plan-reviewer`

## Manual Trae acceptance checklist

After installation, open the target project in Trae and verify:

1. `SessionStart` injects the `using-superpowers` bootstrap.
2. A normal prompt receives the compact Superpowers reminder.
3. `RunCommand` `git status --short` is allowed.
4. `RunCommand` `powershell -File ./INSTALL.md` is denied.
5. `RunCommand` `Remove-Item .\.trae\hooks.json -Force` is denied.
6. `RunCommand` `Remove-Item .\.trae\hooks -Recurse -Force` is denied.
7. `RunCommand` `Remove-Item .\.trae\agents -Recurse -Force` is denied.

## Upstream sync

Upstream source: `obra/superpowers`.

This package keeps the upstream skills current and adapts hooks/rules to Trae's project-local `.trae` runtime. See `UPSTREAM.md` in the bootstrap repository for the audited upstream commit and generated flat skills.
