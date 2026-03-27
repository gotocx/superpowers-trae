# Superpowers for TRAE

基于 [obra/superpowers](https://github.com/obra/superpowers) 改造的 TRAE 迁移项目。

本仓库的目标不是复刻上游全部能力，而是提供一份可直接放入项目中的 `.trae` 初始化模板，让 TRAE 用户能够以更低成本启用一套严格的 Superpowers 工作流。

## 仓库定位

- 改造来源：`https://github.com/obra/superpowers`
- 当前定位：面向 TRAE 的迁移与适配版本
- 当前状态：已完成 `rule + skill` 初始化
- 适用方式：拉取仓库后，将 `.trae` 放入你的项目根目录

本仓库不是 `obra/superpowers` 的官方仓库，也不代表上游项目的官方立场或背书。

## 已包含内容

- `.trae/rules/superpowers.md`
- `.trae/skills/`
- 面向 TRAE 的工作流约束与触发规则
- 记忆激活说明

## 使用方式

1. 拉取本仓库
2. 将 `.trae` 目录复制到你的目标项目根目录
3. 启动 TRAE
4. 手动添加一条核心记忆

## 重要说明：记忆需要你自行激活

仓库无法替你写入运行环境记忆，因此你需要在自己的 TRAE 环境中手动执行一次记忆添加。

建议直接使用下面这段内容：

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

如果你的使用方式是长期复用同一套规则，也可以按平台能力改成全局记忆；但本仓库默认推荐 `project` 级别，避免把项目约束误注入到无关仓库。

## 合法说明

- 本仓库包含基于 `obra/superpowers` 的改造与迁移内容
- 上游项目采用 MIT License
- 本仓库保留上游许可证与归属说明
- 本仓库新增的整理、适配与模板化内容同样按 MIT License 提供

更多法律与归属说明见 [NOTICE.md](./NOTICE.md)。

## 目录结构

```text
.
├── .trae/
│   ├── rules/
│   └── skills/
├── LICENSE
├── NOTICE.md
└── README.md
```

## 致谢

感谢 [obra/superpowers](https://github.com/obra/superpowers) 提供原始方法论、技能设计与工作流灵感。
