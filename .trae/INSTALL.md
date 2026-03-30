# Superpowers for Trae: existing/nested install flow

This file is an instruction document, not a script.

- Never execute `INSTALL.md` itself.
- Never treat this file as a command, manual-run target, or deletion target before installation is finished.

## 1. Goal

Make the real target project root contain a usable `./.trae`, preserve the user's project files, inject the required project memory, and then do only minimal safe cleanup.

## 2. Definitions

- Bootstrap repository root = the cloned `superpowers-trae` directory that contains this file.
- Target project root = the directory where Trae must finally read `./.trae`.
- Source `.trae` = `bootstrap-repo-root/.trae`.
- Redundant bootstrap clone = a nested `./superpowers-trae` directory under the target project root that clearly matches this bootstrap repository.
- Stale temp residue = an old `./.tmp-superpowers-*` directory left behind by a previous broken run.

## 3. Hard rules

- Use only `bootstrap-repo-root/.trae` as the installation source.
- Do not clone, fetch, or download `obra/superpowers-skills` or any other remote repository during installation.
- Do not create any `.tmp-*`, `tmp`, `temp`, or other temporary directories.
- Do not clear the project root.
- Do not delete user source files, configs, docs, custom rules, or custom skills.
- Do not modify the target `.trae` after it has passed verification, except for one final deletion of `target-project-root/.trae/INSTALL.md`.
- Do not delete any directory unless it can be clearly identified as a redundant bootstrap clone or stale temp residue.
- If cleanup fails because of a Windows file lock, do not treat that as an installation failure once the target `.trae` and project memory are already in place.

## 4. Required order

### Phase A: identify source and target

1. Treat the current workspace root as the target project root.
2. If `superpowers-trae` is nested under that target root, treat the nested `superpowers-trae/.trae` only as source material.
3. The final usable path must be `target-project-root/.trae`.
4. `bootstrap-repo-root/.trae` is never the final result in a nested-clone scenario.

### Phase B: copy or refresh target `.trae`

1. Create `target-project-root/.trae` only if it does not already exist.
2. Copy or refresh `rules/superpowers.md` from the source `.trae`.
3. Copy missing official skills from the source `.trae/skills/`.
4. Refresh same-name official skills from the source `.trae/skills/`.
5. Preserve custom target rules and custom target skills that do not conflict by name with official source files.
6. Do not delete `target-project-root/.trae/INSTALL.md` yet.

### Phase C: verify target `.trae`

Verify all of the following before doing anything else:

1. `target-project-root/.trae/rules/superpowers.md` exists.
2. `target-project-root/.trae/skills/` exists.
3. The target skills directory contains at least the core official skills copied from source, including `brainstorming`, `systematic-debugging`, `test-driven-development`, `writing-plans`, and `when-stuck`.

Once Phase C passes:

- Freeze the target `.trae`.
- Do not keep editing it.
- Do not start any temp-folder cleanup before this verification succeeds.

### Phase D: inject project memory

Use `manage_core_memory` at project level:

1. Delete any existing memory with the same title first.
2. Add one new memory with:
   - Title: `Superpowers 严格工作流约束`
   - Keywords: `superpowers|workflow|tdd|debugging|skills`
   - Content:
     本项目严格遵循 obra/superpowers 开发方法论：
     1. 功能开发必须先做设计与测试,遵循 brainstorming > using-git-worktrees > writing-plans > test-driven-development > code-review > finish-branch 的闭环。
     2. 遇到报错或测试失败时,禁止猜测,必须调用 systematic-debugging 做根因排查。
     3. 技能调用必须通过内置 Skill 工具真实执行。
     4. 多步骤流程使用 TodoWrite。
     5. 跨任务知识通过 manage_core_memory 沉淀。

If memory injection fails:

- Report the failure clearly.
- Do not destroy the already copied target `.trae`.

### Phase E: finalize target `.trae`

1. After the target `.trae` is verified and project memory injection succeeds, delete `target-project-root/.trae/INSTALL.md` exactly once.
2. Do not touch the target `.trae` again after that.

### Phase F: safe cleanup only

After Phase E, cleanup is limited to these items only:

1. Redundant bootstrap clone:
   - Delete the whole nested `target-project-root/superpowers-trae` directory if, and only if, it clearly matches this bootstrap repository.
   - Matching signals include: `README.md`, `NOTICE.md`, `LICENSE`, `deliverables/`, `docs/`, and a source `.trae` under that directory.
   - Do not delete any other similarly named user directory.

2. Stale temp residue from older broken runs:
   - Only directories named `./.tmp-superpowers-*` may be considered.
   - This workflow must not create them.
   - If such a directory exists from an older failed run, you may attempt one safe deletion at the very end.

## 5. File-lock handling

If deleting the redundant bootstrap clone or stale temp residue fails because files are locked on Windows:

1. Stop cleanup.
2. Do not retry by editing the target `.trae`.
3. Report the exact remaining path.
4. Tell the user to close the locking process or restart the IDE/system and delete that leftover directory manually.

## 6. Success criteria

Installation is successful when:

1. `target-project-root/.trae` is present and usable.
2. `target-project-root/.trae/rules/superpowers.md` exists.
3. `target-project-root/.trae/skills/` exists with the core official skills.
4. Project memory has been injected successfully.

Cleanup is best-effort after that:

- If the redundant bootstrap clone is deleted successfully, that is the ideal final state.
- If an old `.tmp-superpowers-*` residue is deleted successfully, that is also ideal.
- If either cleanup step is blocked by a Windows file lock, installation still counts as successful, but the leftover path must be reported clearly.
