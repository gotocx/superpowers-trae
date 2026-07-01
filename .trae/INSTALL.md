# Superpowers for Trae: variable + gate install flow

This file is an instruction document, not a script.

- Never execute `INSTALL.md` itself.
- Never treat this file as a command, a manual-run target, or a deletion target before the cleanup gate is open.
- Never create `.tmp-*`, `tmp`, `temp`, `.cache`, or any other temporary install directory.
- Never clone, fetch, or download `obra/superpowers-skills` or any other remote repository during installation.
- Never rename, copy, or clone this bootstrap repository again just to make its directory name match an example.

## 1. Minimal bootstrap package

The bootstrap repository is intentionally minimal. Its working tree should contain only:

- `./.trae`
- `./README.md`
- `./LICENSE`
- `./NOTICE.md`
- `./.gitignore`

A fresh clone may also contain `./.git`.

The `.trae` directory is the install payload. Before cleanup, it also contains install audit documents and validation scripts. After cleanup, the target project's `.trae` must contain only runtime payload: hooks, rules, skills, and memory.

Any direct child directory whose contents match this minimal structure is a bootstrap clone candidate. The directory name is not significant.

## 2. Required variables

Before any copy, delete, overwrite, or memory action, you must explicitly compute and confirm:

- `source_root`
- `target_root`
- `target_trae_path`
- `memory_title`

Fixed value:

- `memory_title = "Superpowers 严格工作流约束"`

If any variable is still ambiguous, do not proceed.

## 3. Root detection: allowed cases only

You must first list the direct children of the current workspace root, count all bootstrap clone candidates, then choose exactly one of these cases.

In nested mode, candidate directory names are not significant. `superpowers-trae`, `superpowers-trae-private`, or any other clone directory name may be valid if exactly one candidate exists. If there are zero candidates or more than one candidate, root detection fails. Do not rename, copy, clone again, or arbitrarily pick one candidate to continue.

### Case A: bootstrap mode

Conditions:

- The current workspace root is the bootstrap repository root.
- It is a true fresh clone of this repository.
- Its direct children are limited to:
  - `./.git`
  - `./.trae`
  - `./README.md`
  - `./LICENSE`
  - `./NOTICE.md`
  - `./.gitignore`

Variables:

- `source_root = .`
- `target_root = .`
- `target_trae_path = ./.trae`

### Case B: nested mode, running from the real target project root

Conditions:

- The current workspace root contains exactly one direct child that is a bootstrap clone candidate.
- That candidate matches the minimal bootstrap package structure above.
- The candidate does not have to be named `superpowers-trae`.

Variables:

- `source_root = ./<only bootstrap clone candidate>`
- `target_root = .`
- `target_trae_path = ./.trae`

### Case C: nested mode, but currently standing inside the bootstrap clone

Conditions:

- The current workspace root itself can be proven to be the bootstrap repository root.
- The current workspace root matches the minimal bootstrap package structure above, regardless of directory name.
- The parent directory is the real target project root.

Variables:

- `source_root = .`
- `target_root = ..`
- `target_trae_path = ../.trae`

### Root detection failure

If you cannot prove Case A, B, or C exactly:

- Do not copy anything.
- Do not delete anything.
- Do not inject memory.
- Report that root detection failed.

## 4. Gate 1: path self-check

Before copying files, all of these must be true:

1. `target_trae_path` is exactly the `.trae` directory under `target_root`.
2. In nested mode, `target_trae_path` is outside `source_root`.
3. In nested mode, the final destination must not be `source_root/.trae`.

If any path self-check fails:

- Do not enter the copy phase.
- Report that the target path was derived incorrectly.

## 5. Phase 1: copy or refresh target `.trae`

Use only `source_root/.trae` as source material.

Do not rename, duplicate, or reclone `source_root`. Its directory name does not affect installation eligibility.

Allowed actions:

1. Create `target_trae_path` only if missing.
2. Refresh `target_trae_path/rules/superpowers.md`.
3. Refresh `target_trae_path/UPSTREAM.md`.
4. Refresh `target_trae_path/hooks.json`.
5. Refresh `target_trae_path/hooks/`.
6. Refresh `target_trae_path/memory/superpowers.md`.
7. Copy missing official skills from `source_root/.trae/skills/`.
8. Refresh same-name official skills from `source_root/.trae/skills/`.
9. Preserve user custom rules and non-conflicting custom skills in the target project.

Forbidden during Phase 1:

- Deleting `target_trae_path/INSTALL.md`
- Deleting `source_root`
- Deleting any bootstrap clone candidate
- Deleting any user project directory

## 6. Gate 2: target `.trae` verification

After Phase 1, verify all of the following:

1. `target_trae_path/rules/superpowers.md` exists.
2. `target_trae_path/UPSTREAM.md` exists.
3. `target_trae_path/hooks.json` exists.
4. `target_trae_path/hooks/session-start.ps1` exists.
5. `target_trae_path/hooks/user-prompt-submit.ps1` exists.
6. `target_trae_path/hooks/pre-run-command-guard.ps1` exists.
7. `target_trae_path/hooks/validate-package.ps1` exists.
8. `target_trae_path/hooks/README.md` exists.
9. `target_trae_path/memory/superpowers.md` exists.
10. `target_trae_path/skills/` exists.
11. `target_trae_path/skills/` contains at least these core skills:
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
   - `using-git-worktrees`
   - `writing-plans`
   - `subagent-driven-development`
   - `systematic-debugging`
   - `test-driven-development`
   - `verification-before-completion`
   - `testing-anti-patterns`
   - `testing-skills-with-subagents`
   - `tracing-knowledge-lineages`
   - `when-stuck`
   - `writing-skills`
12. Run the package validator from the target project root when PowerShell is available:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1
   ```

If Gate 2 fails:

- Do not inject memory.
- Do not delete `target_trae_path/INSTALL.md`.
- Do not delete `source_root`.
- Report that `.trae` verification failed.

## 7. Phase 2: memory alignment

Only after Gate 2 passes may you call `manage_core_memory`.

Hooks, rules, and skills are the base runtime contract. Memory is persistent reinforcement for future sessions; it should be configured whenever the Trae memory tool is available, but a memory-tool failure must not undo a verified hooks/rules/skills install.

Required steps:

1. Delete any existing memory with the same title.
2. Read the canonical payload from `target_trae_path/memory/superpowers.md`.
3. Add one new memory using that title, keywords, and content.

## 8. Gate 3: memory self-check

Memory self-check must confirm:

1. The delete/add operation returned success.
2. The memory title exactly matches `memory_title`.
3. If the tool supports readback or confirmation, perform one same-title confirmation immediately.

If Gate 3 fails:

- Do not claim memory is configured.
- Do not roll back or delete the verified `.trae` runtime.
- Report that the base hooks/rules/skills install is usable but memory alignment is pending.

If `manage_core_memory` is unavailable:

- Do not block base installation.
- Report that memory alignment is pending because the memory tool is unavailable.

## 9. Phase 3: cleanup, only after base runtime gates pass

Cleanup is allowed only when both base runtime gates are true:

- Gate 1 path self-check passed.
- Gate 2 target `.trae` verification passed.

Final runtime `.trae` must be clean. Delete these install-only files after Gate 2 has passed:

- `target_trae_path/INSTALL.md`
- `target_trae_path/UPSTREAM.md`
- `target_trae_path/hooks/README.md`
- `target_trae_path/hooks/validate-package.ps1`

After cleanup, the target `.trae` top level must contain only:

- `hooks.json`
- `hooks/`
- `rules/`
- `skills/`
- `memory/`

The final `hooks/` directory must contain only runtime hook scripts:

- `session-start.ps1`
- `user-prompt-submit.ps1`
- `pre-run-command-guard.ps1`

### Cleanup in bootstrap mode

1. Delete the install-only files listed above from `./.trae`.
2. Delete everything else in the working tree except `./.trae`, including:
   - `./.git`
   - `./README.md`
   - `./LICENSE`
   - `./NOTICE.md`
   - `./.gitignore`

### Cleanup in nested mode

1. Delete the install-only files listed above from `target_trae_path`.
2. Only attempt to delete the exact `source_root` selected during root detection.
3. Before deleting `source_root`, verify that it is the only bootstrap clone candidate, its resolved absolute path is inside `target_root`, and it is neither `target_root` nor `target_trae_path`.
4. Do not delete sibling directories or broaden cleanup to old failed clones. If multiple candidates exist, root detection should already have failed.
5. Attempt recursive deletion of `source_root` at most once. If it fails, immediately follow the file-lock handling rules.
6. Stale `./.tmp-superpowers-*` residue from older failed runs is not created by this flow. Report it by path instead of deleting it automatically.

## 10. File-lock handling

If deleting `source_root` fails because of a Windows file lock:

1. Stop cleanup immediately.
2. Do not try another deletion strategy.
3. Do not use `cmd /c rmdir`.
4. Do not hide cleanup failures with `SilentlyContinue`.
5. Do not mass-change file attributes and retry recursive deletion.
6. Do not edit `target_trae_path` again.
7. Do not roll back the installed `.trae`.
8. Report the exact leftover path.
9. Tell the user to close the locking process or restart the IDE/system and delete that leftover path manually.

## 11. Success criteria

Installation may be declared successful only when all of the following are true:

1. `target_trae_path` is located under the correct `target_root`.
2. `target_trae_path/rules/superpowers.md` exists.
3. `target_trae_path/hooks.json` exists and defines `SessionStart`, `UserPromptSubmit`, and `PreToolUse` hooks.
4. `target_trae_path/hooks/session-start.ps1` exists.
5. `target_trae_path/hooks/user-prompt-submit.ps1` exists.
6. `target_trae_path/hooks/pre-run-command-guard.ps1` exists.
7. `target_trae_path/skills/` exists and contains the core skills.
8. `target_trae_path/memory/superpowers.md` exists.
9. The package validator passed before cleanup, or the same checks were manually verified if PowerShell was unavailable.
10. The final `.trae` top level contains only `hooks.json`, `hooks/`, `rules/`, `skills/`, and `memory/`.
11. The final `.trae/hooks/` directory contains only `session-start.ps1`, `user-prompt-submit.ps1`, and `pre-run-command-guard.ps1`.
12. `INSTALL.md`, `UPSTREAM.md`, `hooks/README.md`, and `hooks/validate-package.ps1` are absent from the final target `.trae`.

Memory may be declared configured only when Gate 3 passes. If Gate 3 is pending or unavailable, say "base installation complete; memory alignment pending" instead of "full installation complete."

Nested failure example:

- If the final result is `source_root/.trae` or any bootstrap candidate's `.trae` instead of `target_root/.trae`, installation is in the wrong directory and must not be reported as successful.
