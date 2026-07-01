# Upstream sync status

This package tracks `obra/superpowers` and keeps a small Trae adaptation layer.

## Current upstream

- Repository: `https://github.com/obra/superpowers`
- Commit synced: `f268f7c953744036f0fa7e9d4b73535c04e57cb8`
- Upstream version observed: `6.1.0`
- Sync date: `2026-07-01`

## Sync contract

The following upstream skill directories are mechanically synced into `.trae/skills/` and should remain byte-for-byte identical unless Trae requires a documented adapter:

- `brainstorming`
- `dispatching-parallel-agents`
- `executing-plans`
- `finishing-a-development-branch`
- `receiving-code-review`
- `requesting-code-review`
- `systematic-debugging`
- `test-driven-development`
- `using-git-worktrees`
- `verification-before-completion`
- `writing-plans`
- `writing-skills`

The following directories intentionally differ:

- `using-superpowers`: Trae-specific bootstrap, tool mapping, hooks/rules/memory contract.
- `subagent-driven-development`: upstream v6 task-brief/review-package/task-reviewer flow with Trae `Task`, `TodoWrite`, and `Skill(name=...)` wording.
- `writing-skills/SKILL.md`: one upstream trailing space is removed so Trae package checks pass.

The following flat Trae skills are generated from upstream reference files so Trae can trigger them directly:

- `condition-based-waiting` from `systematic-debugging/condition-based-waiting.md`
- `defense-in-depth` from `systematic-debugging/defense-in-depth.md`
- `root-cause-tracing` from `systematic-debugging/root-cause-tracing.md`
- `testing-anti-patterns` from `test-driven-development/testing-anti-patterns.md`
- `testing-skills-with-subagents` from `writing-skills/testing-skills-with-subagents.md`

The following Trae-only skills are local problem-solving additions. They are shipped at the same install level as the upstream skills, but they are not overwritten by upstream sync unless deliberately migrated or deprecated:

- `collision-zone-thinking`
- `inversion-exercise`
- `meta-pattern-recognition`
- `preserving-productive-tensions`
- `scale-game`
- `simplification-cascades`
- `tracing-knowledge-lineages`
- `when-stuck`

## Hook migration contract

Upstream uses Claude/Cursor plugin hooks under `hooks/`:

- `hooks/hooks.json`
- `hooks/hooks-cursor.json`
- `hooks/run-hook.cmd`
- `hooks/session-start`
- `hooks/session-start-codex`

Full-repository hook event audit for upstream commit `f268f7c953744036f0fa7e9d4b73535c04e57cb8` found one runtime event registered by the shipped hook configs:

- `SessionStart`

References to `PreToolUse` in upstream docs/specs are planning or design notes, not shipped runtime hook registrations at this commit. References to git hooks under `.git/hooks` are repository internals and are not Superpowers plugin runtime hooks.

Trae uses project hooks at `.trae/hooks.json`. The migrated behavior is:

- `SessionStart` injects the full `using-superpowers` skill at session start.
- `UserPromptSubmit` injects a compact reminder before each user turn so the skill contract survives long sessions.
- `PreToolUse` with matcher `RunCommand` blocks executing install Markdown as scripts, blocks recursive deletion of the active `.trae` runtime, and asks before destructive git cleanup.
- stdout is used as Trae additional context for context hooks.
- Trae `PreToolUse` JSON output is used for command permission decisions.
- PowerShell scripts are the default because Trae on Windows can run them without depending on Git Bash.
- `.trae/hooks/validate-package.ps1` smoke-tests all hook registrations, hook outputs, required runtime files, required skills, and upstream support scripts.

Do not copy upstream hook commands verbatim; they depend on plugin root variables such as `CLAUDE_PLUGIN_ROOT`. Port behavior, not harness-specific paths.

Trae `UserPromptSubmit` and `PreToolUse` are Trae-specific hardening layers. They are not upstream parity requirements, but they are part of this package's install contract and must be validated before release.

## Script migration contract

Upstream root `scripts/` currently contains repository maintenance helpers:

- `scripts/bump-version.sh`
- `scripts/lint-shell.sh`
- `scripts/sync-to-codex-plugin.sh`

These are not runtime payload for Trae installs and are not copied into `.trae/`. Upstream skill support scripts are runtime payload and must be present under `.trae/skills/`; the validator checks the brainstorming, subagent-driven-development, systematic-debugging, and writing-skills support scripts.
