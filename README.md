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
Install Superpowers for Trae into the current project from git.

1. First check whether the current target project already contains a `superpowers-trae` clone.
   - If it does not exist, run:
     git clone https://github.com/gotocx/superpowers-trae.git
   - If it already exists, do not run git clone again during this install attempt.

2. Follow `superpowers-trae/README.md` and `superpowers-trae/INSTALL.md`.
   They are instruction documents, not scripts. Do not execute Markdown files.

3. Before moving, copying, or refreshing anything, compute and report:
   - source_root
   - target_root
   - target_trae_path

4. Detect whether this is bootstrap mode, nested mode from target root, or nested mode while standing inside the bootstrap clone.

5. Verify `target_trae_path` is the real target project's `.trae`, not the bootstrap clone's `.trae`.

6. If `target_trae_path` does not exist, move `source_root/.trae` to `target_trae_path`.
   If `target_trae_path` already exists, refresh only:
   - hooks.json
   - hooks/
   - agents/
   - rules/
   - skills/

7. After moving, copying, or refreshing, run from the target project root:
   powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1

8. No memory setup is required. Do not call manage_core_memory.

9. After validation passes, do not modify target `.trae` again.
   Final `.trae` must keep:
   - hooks.json
   - hooks/
   - agents/
   - rules/
   - skills/

10. Do not delete `.trae/hooks.json`, `.trae/hooks/`, `.trae/agents/`, `.trae/rules/`, or `.trae/skills/`.

11. Delete the bootstrap source clone only by running this from the target project root:
    powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/self-prune-source.ps1 -SourceRoot "<source_root>" -TargetRoot "<target_root>" -TargetTraePath "<target_trae_path>"

12. If the source clone cannot be removed because of a Windows file lock, report the leftover path. Do not use another delete command and do not run git clone again.

13. Report evidence for each gate.
```

## Hook validation

After moving, copying, or refreshing, from the target project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
```

The validator checks:

- `hooks.json` defines `SessionStart` and `UserPromptSubmit`.
- `hooks.json` directly calls readable scripts in `.trae/hooks/`.
- `.trae/agents/` contains the Superpowers named subagent definitions.
- `.trae/hooks/self-prune-source.ps1` refuses unsafe bootstrap source cleanup.
- Required rules, skills, and upstream support scripts exist.
- SessionStart and UserPromptSubmit smoke tests pass.

## Runtime hooks

The final runtime hook config is `.trae/hooks.json`.

- `SessionStart`: injects `using-superpowers`.
- `UserPromptSubmit`: injects a compact workflow reminder.
The old `pre-run-command-guard.ps1` file is now a fail-open compatibility stub. `PreToolUse` is not registered by default because some Windows Trae host versions can leave hook stdin open and strand PowerShell processes.

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
3. Repeated normal prompts do not leave growing `powershell.exe` hook processes.
4. A normal development task still receives Superpowers skill reminders.

## Upstream sync

Upstream source: `obra/superpowers`.

This package keeps the upstream skills current and adapts hooks/rules to Trae's project-local `.trae` runtime. See `UPSTREAM.md` in the bootstrap repository for the audited upstream commit and generated flat skills.
