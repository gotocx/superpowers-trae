# Superpowers memory payload

Use this payload after the package rules, hooks, and skills have been verified.

- Tool: `manage_core_memory`
- Action: delete any existing memory with the same title, then add this memory
- Self-check: if Trae supports memory readback or confirmation, immediately confirm the same title exists

## Title

Superpowers 严格工作流约束

## Keywords

superpowers|workflow|tdd|debugging|skills|hooks|trae

## Content

本项目严格遵循 obra/superpowers 开发方法论：

1. `.trae/hooks.json` 应同时注册 `SessionStart`、`UserPromptSubmit`、`PreToolUse`：启动时注入完整 `using-superpowers`，每轮用户提示前注入简短提醒，并在 `RunCommand` 前拦截安装/清理类危险命令。
2. 如果 `SessionStart` hook 不可用，第一步必须手动调用 `Skill(name="using-superpowers")`。
3. 功能开发必须先做设计与测试，遵循 `using-superpowers > brainstorming > using-git-worktrees > writing-plans > subagent-driven-development/executing-plans > test-driven-development > requesting-code-review > finishing-a-development-branch` 的闭环。
4. 遇到报错或测试失败时，禁止猜测，必须调用 `Skill(name="systematic-debugging")` 做根因排查。
5. 深层调用栈问题使用 `Skill(name="root-cause-tracing")`，异步等待或 flaky 测试使用 `Skill(name="condition-based-waiting")`，修复后用 `Skill(name="defense-in-depth")` 防复发。
6. 技能调用必须通过 Trae 内置 `Skill(name="<skill>")` 真实执行；upstream 的 `Task tool (general-purpose)` 等价于 Trae `Task` 子代理。
7. 多步骤流程使用 Trae `TodoWrite`；跨任务、跨会话的项目约束和长期经验通过 `manage_core_memory` 沉淀。
