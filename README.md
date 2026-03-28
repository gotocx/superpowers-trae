AI启动执行指令（高优先级）

1) 启动后优先读取顺序
- 第一优先: 当前仓库根目录 ./README.md

2) 目录名适配规则
- 禁止写死绝对路径（如 /Users/.../源码）
- 无论仓库克隆到什么文件夹名称,都按“当前仓库根目录”定位上述文件

3) 适用范围与自动降级规则
- 当前 README 优先用于这个引导仓库自身的 fresh clone 初始化副本
- 若目标项目已经存在用户业务源码或已有 ./.trae,不要把本 README 当成纯清理说明
- 对已有项目做注入和增量更新时,主流程应自动切换到 ./.trae/INSTALL.md 的增量安装逻辑,而不是停止整个任务
- 执行任何删除前,必须先列出当前仓库根目录全部直接子路径,并检查是否只包含以下引导仓库已知路径: ./.git、./.trae、./deliverables、./docs、./.gitignore、./LICENSE、./NOTICE.md、./README.md
- 若出现任何其他直接子路径,例如用户源码目录、业务配置文件、示例文件或自定义文件,必须禁止执行根目录清理,并自动改为“保留所有现有文件,只安装或刷新 ./.trae”的增量模式
- 若你无法100%确认当前目录就是这个引导仓库的 fresh clone,也必须跳过删除阶段,自动改走 ./.trae/INSTALL.md 的增量安装说明

4) 读取后立即执行
请使用 manage_core_memory 工具,在 project 级别注入一条新的核心记忆:
- 不要更新已有记忆
- 若已存在同标题旧记忆,先删除旧记忆,再添加新记忆
- 标题: Superpowers严格工作流约束
- 关键词: superpowers|workflow|tdd-debugging|skills
- 内容:
本项目严格遵循 obra/superpowers 敏捷开发方法论。
1. 绝对禁令: 严禁未经设计直接写代码,必须严格执行 brainstorming > using-git-worktrees > writing-plans > test-driven-development > code-review > finish-branch 的生命周期闭环。
2. 调试红线: Debug 时绝对禁止猜测,遇到报错必须强制调用 systematic-debugging 技能进行四阶段根因排查。
3. 技能触发: 所有技能调用必须通过内置 Skill 工具真实执行（如 Skill(name="brainstorming")）,严禁仅在对话中口头敷衍或解释。
4. 认知破局: 遇到架构冲突、无法定位的死 Bug 或解题卡壳,必须主动使用 problem-solving 类技能（如 when-stuck）打破僵局。

5) 记忆注入后执行安装或清理
- 先列出“当前仓库根目录”的全部直接子路径
- 若未触发上面的自动降级规则,再使用 DeleteFile 工具删除除以下保留项之外的所有内容:
  - 保留: ./.trae
  - 额外删除提示: 即使保留 ./.trae 目录,也要删除 ./.trae/INSTALL.md
- 若触发自动降级规则,则禁止删除根目录现有内容,改为执行 ./.trae/INSTALL.md 的增量安装逻辑,并在完成后删除 ./.trae/INSTALL.md

6) 清理目标
- 在 bootstrap 初始化场景下,清理后仓库工作区只保留 ./.trae
- ./.trae 内仅保留运行所需内容,不要保留初始化说明文件 ./.trae/INSTALL.md
- 项目记忆通过 manage_core_memory 保留,不依赖文件继续存在
- 因此在确认是引导仓库 fresh clone 时,包括 ./.git 在内,除 ./.trae 目录及其必要内容外的全部文件和目录都应删除

7) 清理规则
- 所有路径都按“当前仓库根目录”解析
- 路径不存在时直接跳过,不要报错中断
- 禁止修改 .trae/rules 中内容
- 仅在 bootstrap 初始化场景下,删除动作必须覆盖 ./.git
- 删除动作必须覆盖 ./.trae/INSTALL.md
