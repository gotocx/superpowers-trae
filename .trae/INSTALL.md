# Installing Superpowers for Trae

## Safety First

This repository supports **two modes**:

- **Incremental mode (default)**: for real projects that already contain source code, configs, docs, or an existing `.trae` folder.
- **Initialization mode**: only for a fresh clone of this bootstrap repository when the explicit goal is to shrink the workspace down to only `.trae`.

If you cannot prove deletion is safe, you must choose **Incremental mode**.

## Incremental Mode (Default)

Use this mode when the target project already has user files.

### Recommended prompt

> Please run the incremental mode defined by `README.md` from the current project root. Preserve all user source files and configs, only inject and incrementally update `.trae`, and delete `.trae/INSTALL.md` after setup.

### What the AI should do

1. Treat the current workspace root as the target project root.
2. Create `.trae` only if it does not already exist.
3. Install or refresh `.trae/rules/superpowers.md`.
4. Fetch the latest `https://github.com/obra/superpowers-skills.git` into a temporary folder.
5. Incrementally copy missing skills into `.trae/skills/` and refresh same-name official skills.
6. Preserve user-created source files, configs, docs, custom rules, and custom skills that are unrelated to the official refresh.
7. Rename `using-skills` to `using-superpowers` if needed.
8. Delete temporary folders and delete `.trae/INSTALL.md` when setup is complete.
9. Register the project core memory by deleting any existing same-title memory first, then adding a new one.

## Initialization Mode (Only for Bootstrap Copies)

Use this mode only when the current workspace is a fresh clone of this repository and there is no user business code to preserve.

### Recommended prompt

> Please run the initialization mode defined by `README.md` from the current project root. First inject the project memory, then delete everything except `./.trae`, and also delete `./.git` and `./.trae/INSTALL.md`.

### What the AI should do

1. Prepare `.trae/rules/superpowers.md` and `.trae/skills/` first.
2. Register the project core memory by deleting any existing same-title memory first, then adding a new one.
3. List direct children of the current project root.
4. Delete everything except `./.trae`.
5. Also delete `./.git` and `./.trae/INSTALL.md`.

## Project Memory To Register

Please add one project-level memory with:

- Title: Superpowers 严格工作流约束
- Keywords: superpowers|workflow|tdd|debugging|skills|modes
- Category: Knowledge
- Via: request
- Content: 本项目严格遵循 obra/superpowers 开发方法论：知识沉淀与测试驱动开发优先；系统化过程胜于临时猜测；简化复杂性，以简洁为主要目标；证据胜于主张，在宣布成功前先核实。遇到功能开发先做设计与测试；遇到报错必须调用 systematic-debugging 做根因排查；技能调用必须通过内置 Skill 工具真实执行；多步骤流程使用 TodoWrite；跨任务知识通过 manage_core_memory 沉淀。若项目已有用户源码或已有 .trae 内容，必须走增量模态，不得误删用户文件。

## Why This Adaptation Works

- **Dual-mode safety**: avoids destructive cleanup in real projects.
- **Incremental updates**: keeps user files while refreshing official Superpowers content.
- **Trae-native memory**: keeps the workflow anchored through `manage_core_memory`.
- **Prompt-driven execution**: gives end users a stable phrase to trigger the correct mode.
