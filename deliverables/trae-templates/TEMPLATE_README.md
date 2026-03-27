# Superpowers for TRAE Init Template

A minimal initialization template for enabling a strict Superpowers workflow in TRAE projects.

[中文说明](./TEMPLATE_README.zh-CN.md)

## What this template includes

- `.trae/rules/superpowers.md`
- `.trae/skills/`
- usage guidance for activating the required project memory
- legal attribution back to `obra/superpowers`

## What this template is for

This template is intended for TRAE users who want to bootstrap a project with a ready-to-copy `.trae` directory that already includes rule and skill initialization.

It is adapted from [obra/superpowers](https://github.com/obra/superpowers), then trimmed and repackaged for TRAE-oriented setup.

## Quick Start

1. Copy the `.trae` directory from this template into your project root.
2. Open the project in TRAE.
3. Manually add the recommended project-level core memory.
4. Start a fresh session and let TRAE load the rule and skill set.

## Required memory activation

The template cannot automatically write runtime memory for the user. Please add the following as a `project`-level core memory:

```text
请使用 manage_core_memory 工具，在 project 级别添加一条核心记忆。
标题：Superpowers 严格工作流约束
关键词：superpowers|workflow|tdd|debugging|skills
内容：
本项目严格遵循 obra/superpowers 敏捷开发方法论。

1. 绝对禁令：严禁未经设计直接写代码，必须严格执行 brainstorming -> using-git-worktrees -> writing-plans -> test-driven-development -> code-review -> finish-branch 的生命周期闭环。
2. 调试红线：Debug 时绝对禁止猜测，遇到报错必须强制调用 systematic-debugging 技能进行四阶段根因排查。
3. 技能触发：所有的技能调用必须通过内置的 Skill 工具（如 Skill(name="brainstorming")）真实执行，严禁仅在对话中口头敷衍或解释。
4. 认知破局：遇到架构冲突、无法定位的死 Bug 或解题卡壳，必须主动使用 problem-solving 类技能（如 when-stuck）来打破僵局。
```

## Attribution

- Upstream project: `obra/superpowers`
- Upstream license: MIT
- This template is an adaptation for TRAE and is not an official upstream distribution.
