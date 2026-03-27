# Superpowers for TRAE 初始化模板

一份用于在 TRAE 项目中启用严格 Superpowers 工作流的最小初始化模板。

[English](./TEMPLATE_README.md)

## 模板包含内容

- `.trae/rules/superpowers.md`
- `.trae/skills/`
- 必需项目记忆的激活说明
- 指向 `obra/superpowers` 的合法归属说明

## 模板用途

这个模板适合希望快速初始化 `.trae` 目录的 TRAE 用户。复制后即可获得已经完成 `rule + skill` 初始化的工作流基础。

本模板改造自 [obra/superpowers](https://github.com/obra/superpowers)，并针对 TRAE 的使用方式做了裁剪、整理和重新打包。

## 快速开始

1. 将模板中的 `.trae` 目录复制到你的项目根目录。
2. 使用 TRAE 打开项目。
3. 手动添加推荐的项目级核心记忆。
4. 新开一个会话，让 TRAE 载入这套 rule 与 skill。

## 必需记忆激活

模板无法替用户自动写入运行时记忆，请手动添加以下 `project` 级核心记忆：

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

## 归属说明

- 上游项目：`obra/superpowers`
- 上游许可证：MIT
- 本模板是面向 TRAE 的适配版本，不代表上游官方发布或背书
