# Superpowers for Trae: variable and gate install flow

This file is an instruction document, not a script.

- Never execute `INSTALL.md` itself.
- Never treat Markdown files as command targets.
- Never create `.tmp-*`, `tmp`, `temp`, `.cache`, or any other temporary install directory.
- Never clone, fetch, or download `obra/superpowers`, `obra/superpowers-skills`, or any other remote repository during installation.
- Never rename, copy, or clone this bootstrap repository again just to make its directory name match an example.
- Never delete `.trae/hooks.json`. It is runtime configuration, not an install-only hook script.

## 1. Minimal bootstrap package

The bootstrap repository working tree should contain only:

- `./.trae`
- `./README.md`
- `./INSTALL.md`
- `./UPSTREAM.md`
- `./LICENSE`
- `./NOTICE.md`
- `./.gitignore`

A fresh clone may also contain `./.git`.

The `.trae` directory is the complete Trae runtime payload. After installation, the target project's `.trae` must contain:

- `hooks.json`
- `hooks/`
- `agents/`
- `rules/`
- `skills/`

Any direct child directory whose contents match the minimal structure above is a bootstrap clone candidate. The directory name is not significant.

## 2. Required variables

Before any copy, overwrite, or source-clone removal action, explicitly compute and confirm:

- `source_root`
- `target_root`
- `target_trae_path`

If any variable is ambiguous, stop.

## 3. Root detection: allowed cases only

First list the direct children of the current workspace root and count all bootstrap clone candidates. Continue only in one of these cases.

### Case A: bootstrap mode

Conditions:

- The current workspace root is the bootstrap repository root.
- Its direct children are limited to `.git`, `.trae`, `README.md`, `INSTALL.md`, `UPSTREAM.md`, `LICENSE`, `NOTICE.md`, and `.gitignore`.

Variables:

- `source_root = .`
- `target_root = .`
- `target_trae_path = ./.trae`

### Case B: nested mode from the target project root

Conditions:

- The current workspace root contains exactly one bootstrap clone candidate.
- The candidate matches the minimal bootstrap package structure.

Variables:

- `source_root = ./<only bootstrap clone candidate>`
- `target_root = .`
- `target_trae_path = ./.trae`

### Case C: nested mode while standing inside the bootstrap clone

Conditions:

- The current workspace root itself is the bootstrap repository root.
- The parent directory is the real target project root.

Variables:

- `source_root = .`
- `target_root = ..`
- `target_trae_path = ../.trae`

### Root detection failure

If you cannot prove Case A, B, or C exactly:

- Do not copy anything.
- Do not delete anything.
- Report that root detection failed.

## 4. Gate 1: path self-check

Before copying files, all of these must be true:

1. `target_trae_path` is exactly the `.trae` directory under `target_root`.
2. In nested mode, `target_trae_path` is outside `source_root`.
3. In nested mode, the final destination is not `source_root/.trae`.

If any path self-check fails, stop and report the incorrect path.

## 5. Phase 1: copy or refresh target `.trae`

Use only `source_root/.trae` as source material. Do not rename, duplicate, or reclone `source_root`.

Allowed actions:

1. Create `target_trae_path` only if missing.
2. Refresh `target_trae_path/rules/superpowers.md`.
3. Refresh `target_trae_path/hooks.json`.
4. Refresh `target_trae_path/hooks/`.
5. Refresh `target_trae_path/agents/`.
6. Copy missing official skills from `source_root/.trae/skills/`.
7. Refresh same-name official skills from `source_root/.trae/skills/`.
8. Preserve user custom rules, custom agents, and non-conflicting custom skills in the target project.

Forbidden during Phase 1:

- Deleting `target_trae_path/hooks.json`
- Deleting `source_root`
- Deleting any bootstrap clone candidate
- Deleting any user project directory

## 6. Gate 2: target `.trae` verification

After Phase 1, verify all of the following:

1. `target_trae_path/rules/superpowers.md` exists.
2. `target_trae_path/hooks.json` exists.
3. `target_trae_path/hooks/session-start.ps1` exists.
4. `target_trae_path/hooks/user-prompt-submit.ps1` exists.
5. `target_trae_path/hooks/pre-run-command-guard.ps1` exists.
6. `target_trae_path/hooks/validate-package.ps1` exists.
7. `target_trae_path/agents/` exists.
8. `target_trae_path/agents/` contains at least these agent definitions:
   - `superpowers-implementer.md`
   - `superpowers-task-reviewer.md`
   - `superpowers-code-reviewer.md`
   - `superpowers-plan-reviewer.md`
9. `target_trae_path/skills/` exists.
10. `target_trae_path/skills/` contains at least these core skills:
   - `using-superpowers`
   - `brainstorming`
   - `collision-zone-thinking`
   - `condition-based-waiting`
   - `defense-in-depth`
   - `dispatching-parallel-agents`
   - `executing-plans`
   - `finishing-a-development-branch`
   - `inversion-exercise`
   - `meta-pattern-recognition`
   - `preserving-productive-tensions`
   - `receiving-code-review`
   - `requesting-code-review`
   - `root-cause-tracing`
   - `scale-game`
   - `simplification-cascades`
   - `subagent-driven-development`
   - `systematic-debugging`
   - `test-driven-development`
   - `testing-anti-patterns`
   - `testing-skills-with-subagents`
   - `tracing-knowledge-lineages`
   - `using-git-worktrees`
   - `verification-before-completion`
   - `when-stuck`
   - `writing-plans`
   - `writing-skills`
11. Run the package validator from the target project root when PowerShell is available:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
   ```

If Gate 2 fails:

- Do not remove the bootstrap source clone.
- Do not delete `source_root`.
- Report that `.trae` verification failed.

## 7. Phase 2: source clone removal after Gate 2

After Gate 2 passes, the target `.trae` is already final runtime. Do not alter, prune, slim, normalize, or delete anything inside `target_trae_path`.

Source clone removal is allowed only when both base runtime gates passed:

- Gate 1 path self-check passed.
- Gate 2 target `.trae` verification passed.

Hard rule: do not run `Remove-Item`, `rm`, `del`, `rmdir`, or any wildcard deletion against `target_trae_path` or any child of `target_trae_path`.

Keep all current runtime entries:

- `target_trae_path/hooks.json`
- `target_trae_path/hooks/`
- `target_trae_path/agents/`
- `target_trae_path/rules/`
- `target_trae_path/skills/`

If non-runtime entries exist inside `target_trae_path`, report them by name. Do not delete them automatically during this flow.

Immediately before declaring success, verify `target_trae_path/hooks.json`, `target_trae_path/hooks/`, and `target_trae_path/agents/` still exist.

### Bootstrap mode

In bootstrap mode, the bootstrap repository root is also the target project root. Do not delete anything automatically after Gate 2. Report that installation is complete and that repository files outside `.trae` can be removed manually if the user wants a `.trae`-only folder.

### Nested mode

1. Only attempt to delete the exact `source_root` selected during root detection.
2. Before deleting `source_root`, verify that it is the only bootstrap clone candidate, its resolved absolute path is inside `target_root`, and it is neither `target_root` nor `target_trae_path`.
3. Do not delete sibling directories or broaden cleanup to old failed clones.
4. Attempt recursive deletion of `source_root` at most once. If it fails, immediately follow the file-lock handling rules.

## 8. File-lock handling

If deleting `source_root` fails because of a Windows file lock:

1. Stop source clone removal immediately.
2. Do not try another deletion strategy.
3. Do not use `cmd /c rmdir`.
4. Do not hide source clone removal failures with `SilentlyContinue`.
5. Do not mass-change file attributes and retry recursive deletion.
6. Do not edit `target_trae_path` again.
7. Do not roll back the installed `.trae`.
8. Report the exact leftover path.
9. Tell the user to close the locking process or restart the IDE/system and delete that leftover path manually.

## 9. Success criteria

Installation may be declared successful only when all of the following are true:

1. `target_trae_path` is located under the correct `target_root`.
2. `target_trae_path/rules/superpowers.md` exists.
3. `target_trae_path/hooks.json` exists.
4. `target_trae_path/hooks/` exists and contains the readable hook scripts.
5. `target_trae_path/agents/` exists and contains the Superpowers subagent definitions.
6. `target_trae_path/hooks.json` defines `SessionStart`, `UserPromptSubmit`, and `PreToolUse` hooks.
7. `target_trae_path/hooks.json` calls the scripts in `target_trae_path/hooks/`.
8. `target_trae_path/skills/` exists and contains the core skills.
9. The package validator passed, or equivalent manual checks passed if PowerShell was unavailable.
10. The final `.trae` top level contains at least `hooks.json`, `hooks/`, `agents/`, `rules/`, and `skills/`.
11. No current runtime entry was deleted from `target_trae_path`.

No memory setup is required. The persistent Superpowers reinforcement lives in `.trae/rules/superpowers.md`.

Nested failure example:

- If the final result is `source_root/.trae` or any bootstrap candidate's `.trae` instead of `target_root/.trae`, installation is in the wrong directory and must not be reported as successful.
