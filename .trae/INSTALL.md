# Installing Superpowers for Trae into an Existing Project

## Scope

This file is for **existing projects** that already contain user source code, configs, docs, or an existing `.trae` folder.

If the root `README.md` detects any extra files or cannot prove the current directory is a fresh clone of the bootstrap repository, the workflow should automatically continue with this incremental path instead of stopping.

## Root Definitions

- Bootstrap repository root = the directory that contains this file in the cloned `superpowers-trae` repository.
- Target project root = the directory where Trae must finally see `./.trae`.
- If the bootstrap repository is nested inside another project, treat the bootstrap repository only as the source of `.trae`.
- In that nested-clone case, the final usable path must be `target-project-root/.trae`, not `bootstrap-repo-root/.trae`.
- If the nested bootstrap clone sits under the target project root, remove that redundant bootstrap clone directory after the target-root `.trae` is installed and verified.

## Safety Rules

- Never delete user source files, configs, docs, or unrelated project files.
- Never clear the project root.
- Only inject or incrementally refresh `.trae` contents.
- If this file is being read from a nested bootstrap clone, copy or refresh `.trae` into the real target project root instead of leaving it only inside the bootstrap clone.
- After successful installation, delete the redundant nested bootstrap clone directory itself when it is clearly just the copied `superpowers-trae` source repository, not user project content.
- Delete `.trae/INSTALL.md` after setup is complete.
- If there is any uncertainty, choose this incremental path instead of destructive cleanup.

## Recommended Prompt

Copy and paste this into Trae from the target project root:

> Please install or refresh Superpowers for this existing project from the current project root. If the `superpowers-trae` bootstrap repository is nested under this project, use it only as the source of `.trae` and install into the current project root instead of `superpowers-trae/.trae`. After the target-root `.trae` is installed and verified, remove the redundant nested bootstrap source directory itself instead of only deleting `superpowers-trae/.trae/INSTALL.md`. Preserve all user source files, configs, docs, custom rules, and custom skills. Only inject and incrementally update `.trae`, refresh `.trae/rules/superpowers.md`, add missing official skills, refresh same-name official skills, and delete `.trae/INSTALL.md` after setup.

## What the AI should complete

1. Treat the current workspace root as the target project root.
2. If this file came from a nested bootstrap clone, read source files from that clone but write the final result to the target project root.
3. Create `.trae` only if it does not already exist in the target project root.
4. Install or refresh `.trae/rules/superpowers.md`.
5. Fetch the latest `https://github.com/obra/superpowers-skills.git` into a temporary folder.
6. Incrementally copy missing official skills into `.trae/skills/`.
7. Refresh same-name official skills when needed.
8. Preserve user source files, configs, docs, custom rules, and custom skills.
9. Rename `using-skills` to `using-superpowers` if needed.
10. If a nested bootstrap source directory remains under the target project root and it is clearly the copied `superpowers-trae` repository, delete that entire redundant directory after the target-root `.trae` is verified.
11. Delete temporary folders and delete `.trae/INSTALL.md` from the final installed `.trae` when setup is complete.
12. Register the project core memory by deleting any existing same-title memory first, then adding a new one.
13. Do not declare success unless the target project root now contains a usable `./.trae` and the redundant nested bootstrap source directory has been removed.

## Project Memory To Register

Please add one project-level memory with:

- Title: Superpowers 严格工作流约束
- Keywords: superpowers|workflow|tdd|debugging|skills
- Category: Knowledge
- Via: request
- Content: 本项目严格遵循 obra/superpowers 开发方法论：知识沉淀与测试驱动开发优先；系统化过程胜于临时猜测；简化复杂性，以简洁为主要目标；证据胜于主张，在宣布成功前先核实。遇到功能开发先做设计与测试；遇到报错必须调用 systematic-debugging 做根因排查；技能调用必须通过内置 Skill 工具真实执行；多步骤流程使用 TodoWrite；跨任务知识通过 manage_core_memory 沉淀。

## Why this separation works

- Root `README.md` still supports bootstrap cleanup when the directory is a true fresh clone.
- Root `README.md` now auto-falls back to incremental installation instead of stopping when user files are present.
- `.trae/INSTALL.md` provides the non-destructive path for real projects.
- Nested bootstrap clones now have an explicit rule: source files may live under `superpowers-trae`, but the final usable `.trae` must be written to the real project root.
- Nested bootstrap clones also now require cleanup of the redundant bootstrap source directory after installation, not just deletion of the copied `INSTALL.md`.
- Users get a clear split between bootstrap initialization and existing-project installation.
