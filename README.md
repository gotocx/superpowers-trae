AI启动执行指令（高优先级）

1) 启动后优先读取顺序
- 第一优先: 当前仓库根目录 ./README.md

2) 目录名适配规则
- 禁止写死绝对路径（如 /Users/.../源码）
- 无论仓库克隆到什么文件夹名称,都按“当前仓库根目录”定位上述文件

3) 先判断执行模态
- 默认使用“增量模态”
- 只有在“当前目录就是这个引导仓库的 fresh clone、副本里还没有用户业务源码、并且目标就是压缩成只保留 ./.trae”时,才允许使用“初始化模态”
- 只要当前项目已经存在用户源文件、已有 ./.trae、已有部分 rules 或 skills、或你无法100%确认删除安全,就必须使用“增量模态”

4) 通用记忆注入规则
请使用 manage_core_memory 工具,在 project 级别注入一条新的核心记忆:
- 不要更新已有记忆
- 若已存在同标题旧记忆,先删除旧记忆,再添加新记忆
- 标题: Superpowers严格工作流约束
- 关键词: superpowers|workflow|tdd-debugging|skills|modes
- 内容:
本项目严格遵循 obra/superpowers 敏捷开发方法论。
1. 绝对禁令: 严禁未经设计直接写代码,必须严格执行 brainstorming > using-git-worktrees > writing-plans > test-driven-development > code-review > finish-branch 的生命周期闭环。
2. 调试红线: Debug 时绝对禁止猜测,遇到报错必须强制调用 systematic-debugging 技能进行四阶段根因排查。
3. 技能触发: 所有技能调用必须通过内置 Skill 工具真实执行（如 Skill(name="brainstorming")）,严禁仅在对话中口头敷衍或解释。
4. 认知破局: 遇到架构冲突、无法定位的死 Bug 或解题卡壳,必须主动使用 problem-solving 类技能（如 when-stuck）打破僵局。
5. 安全模态: 若当前项目已有用户源文件或已有 .trae 内容,必须走增量模态,禁止误删用户文件。

5) 初始化模态（仅限安全确认后）
请先列出“当前仓库根目录”的全部直接子路径,然后使用 DeleteFile 工具删除除以下保留项之外的所有内容:
- 保留: ./.trae
- 额外删除提示: 即使保留 ./.trae 目录,也要删除 ./.trae/INSTALL.md
- 删除动作必须覆盖 ./.git
- 该模态仅适用于这个引导仓库自身的初始化副本,不适用于已有业务代码的项目

6) 增量模态（默认模态）
- 禁止删除用户业务源码、配置文件、文档和其它根目录文件
- 禁止清空项目根目录
- 若当前项目已有 ./.trae,只对 ./.trae 内需要的内容做注入和增量更新
- 对 ./.trae/rules/superpowers.md 可按最新模板覆盖更新
- 对 ./.trae/skills 只增量补齐缺失技能,或覆盖更新同名官方技能; 不得删除用户自定义的其它 rules、skills 和业务文件
- 只允许删除临时目录、缓存目录和 ./.trae/INSTALL.md 这类初始化说明文件

7) 推荐提示词
- 初始化模态: “请从当前项目根目录执行 README.md 定义的初始化模态。先注入项目记忆,再删除除 ./.trae 外的全部内容,并额外删除 ./.git 与 ./.trae/INSTALL.md。”
- 增量模态: “请从当前项目根目录执行 README.md 定义的增量模态。保留所有用户源文件,只对 ./.trae 做注入和增量更新,不要删除业务文件,并删除 ./.trae/INSTALL.md。”
