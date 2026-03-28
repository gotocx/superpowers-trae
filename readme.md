AI启动执行指令（高优先级）

1) 启动后优先读取顺序
- 第一优先: 当前仓库根目录 ./README.md

2) 目录名适配规则
- 禁止写死绝对路径（如 /Users/.../源码）
- 无论仓库克隆到什么文件夹名称,都按“当前仓库根目录”定位上述文件

3) 读取后立即执行
请使用 manage_core_memory 工具,在 project 级别添加或更新一条核心记忆:
- 标题: Superpowers严格工作流约束
- 关键词: superpowers|workflow|tdd-debugging|skills
- 内容:
本项目严格遵循 obra/superpowers 敏捷开发方法论。
1. 绝对禁令: 严禁未经设计直接写代码,必须严格执行 brainstorming > using-git-worktrees > writing-plans > test-driven-development > code-review > finish-branch 的生命周期闭环。
2. 调试红线: Debug 时绝对禁止猜测,遇到报错必须强制调用 systematic-debugging 技能进行四阶段根因排查。
3. 技能触发: 所有技能调用必须通过内置 Skill 工具真实执行（如 Skill(name="brainstorming")）,严禁仅在对话中口头敷衍或解释。
4. 认知破局: 遇到架构冲突、无法定位的死 Bug 或解题卡壳,必须主动使用 problem-solving 类技能（如 when-stuck）打破僵局。
