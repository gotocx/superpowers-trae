# Installing Superpowers for Trae into an Existing Project

## Scope

This file is for **existing projects** that already contain user source code, configs, docs, or an existing `.trae` folder.

If you are operating on a fresh clone of this bootstrap repository itself and want the final workspace to contain only `.trae`, follow the root `README.md` instead.

## Safety Rules

- Never delete user source files, configs, docs, or unrelated project files.
- Never clear the project root.
- Only inject or incrementally refresh `.trae` contents.
- Delete `.trae/INSTALL.md` after setup is complete.
- If there is any uncertainty, choose this incremental path instead of the destructive bootstrap cleanup.

## Recommended Prompt

Copy and paste this into Trae from the target project root:

> Please install or refresh Superpowers for this existing project from the current project root. Preserve all user source files, configs, docs, custom rules, and custom skills. Only inject and incrementally update `.trae`, refresh `.trae/rules/superpowers.md`, add missing official skills, refresh same-name official skills, and delete `.trae/INSTALL.md` after setup.

## What the AI should complete

1. Treat the current workspace root as the target project root.
2. Create `.trae` only if it does not already exist.
3. Install or refresh `.trae/rules/superpowers.md`.
4. Fetch the latest `https://github.com/obra/superpowers-skills.git` into a temporary folder.
5. Incrementally copy missing official skills into `.trae/skills/`.
6. Refresh same-name official skills when needed.
7. Preserve user source files, configs, docs, custom rules, and custom skills.
8. Rename `using-skills` to `using-superpowers` if needed.
9. Delete temporary folders and delete `.trae/INSTALL.md` when setup is complete.
10. Register the project core memory by deleting any existing same-title memory first, then adding a new one.

## Project Memory To Register

Please add one project-level memory with:

- Title: Superpowers 严格工作流约束
- Keywords: superpowers|workflow|tdd|debugging|skills
- Category: Knowledge
- Via: request
- Content: 本项目严格遵循 obra/superpowers 开发方法论：知识沉淀与测试驱动开发优先；系统化过程胜于临时猜测；简化复杂性，以简洁为主要目标；证据胜于主张，在宣布成功前先核实。遇到功能开发先做设计与测试；遇到报错必须调用 systematic-debugging 做根因排查；技能调用必须通过内置 Skill 工具真实执行；多步骤流程使用 TodoWrite；跨任务知识通过 manage_core_memory 沉淀。

## Why this separation works

- Root `README.md` keeps the bootstrap repository's own cleanup flow unchanged.
- Root `README.md` now includes a hard stop if unexpected files exist, reducing accidental deletion.
- `.trae/INSTALL.md` provides the non-destructive incremental path for real projects.
- Users get a clear split between bootstrap initialization and existing-project installation.
