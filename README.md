AI 安装指令（变量 + 阶段门槛版）

0) 文档角色
- `README.md` 与 `./.trae/INSTALL.md` 都是说明文件,不是脚本。
- 绝对禁止把 Markdown 文件当命令执行、手动运行项、搜索结果运行项或删除目标。
- 绝对禁止为了安装 Superpowers 再去克隆、拉取、同步或临时下载任何其他仓库。
- 绝对禁止为了匹配目录名而重命名、复制或二次克隆本引导仓库。
- 绝对禁止创建任何 `.tmp-*`、`tmp`、`temp`、`.cache` 等临时目录。

1) 最小引导仓库结构
- 本引导仓库默认分支应只包含: `./.trae`、`./README.md`、`./LICENSE`、`./NOTICE.md`、`./.gitignore`。
- fresh clone 场景下,还会额外存在 `./.git`。
- `./.trae` 是安装载荷,内部包含 rules、skills、Trae hooks、hook 验证脚本、同步审计文件和标准记忆载荷。安装清理完成后,目标项目 `.trae` 必须只保留运行时载荷: `hooks.json`、`hooks/`、`rules/`、`skills/`、`memory/`。
- 若某个直接子目录（目录名不限）同时包含 `./README.md`、`./LICENSE`、`./NOTICE.md`、`./.gitignore`、`./.trae/`,则它可以被识别为“引导仓库副本候选”。

2) 必须先定义的变量
- 在复制、删除、覆盖、注入记忆之前,必须先显式列出并确认以下变量:
  - `source_root`
  - `target_root`
  - `target_trae_path`
  - `memory_title`
- 固定值:
  - `memory_title = "Superpowers 严格工作流约束"`
- 若这四个变量中任意一个未明确,禁止进入下一阶段。

3) 根目录推导硬规则
- 第一步必须先列出“当前工作区根目录”的全部直接子路径,再推导变量。
- nested 场景必须先统计全部“引导仓库副本候选”。候选目录名不限,例如 `superpowers-trae`、`superpowers-trae-private` 或其它 clone 目录名都可以。
- 若候选数量为 0 或大于 1,根目录推导失败。不得通过重命名、复制、二次克隆或随意选择其中一个候选来继续安装。
- 仅允许以下三种已证明场景:

场景 A: bootstrap 模式
- 条件:
  - 当前工作区根目录就是引导仓库根目录
  - 当前目录可被100%确认是本仓库的 fresh clone
  - 直接子路径仅包含 `./.git`、`./.trae`、`./README.md`、`./LICENSE`、`./NOTICE.md`、`./.gitignore`
- 变量:
  - `source_root = .`
  - `target_root = .`
  - `target_trae_path = ./.trae`

场景 B: nested 模式,从目标项目根目录执行
- 条件:
  - 当前工作区根目录中存在且只存在 1 个“引导仓库副本候选”
  - 该候选目录符合上面的最小引导仓库结构
  - 不要求候选目录名必须是 `superpowers-trae`
- 变量:
  - `source_root = ./<唯一引导仓库副本候选目录>`
  - `target_root = .`
  - `target_trae_path = ./.trae`

场景 C: nested 模式,但当前人正站在引导仓库子目录里执行
- 条件:
  - 当前工作区根目录本身可被100%确认是引导仓库根目录
  - 当前目录符合最小引导仓库结构
  - 当前目录的父目录才是实际目标项目根目录
- 变量:
  - `source_root = .`
  - `target_root = ..`
  - `target_trae_path = ../.trae`

- 若无法100%证明属于 A/B/C 任一场景,则根目录推导失败:
  - 禁止复制
  - 禁止删除
  - 禁止注入记忆
  - 只允许报告“根目录识别失败”

4) 路径自检门槛
- 进入复制阶段前,必须先完成以下自检:
  - `target_trae_path` 必须是 `target_root` 下的 `./.trae`
  - 在 nested 场景下,`target_trae_path` 绝对不能落在 `source_root/.trae`
  - 在 nested 场景下,最终结果必须位于引导仓库目录之外,不得位于任何候选目录内部
- 若路径自检失败,禁止进入复制阶段。

5) 阶段 1: 复制或刷新目标 `.trae`
- 安装源只能是 `source_root/.trae`
- 禁止重命名、复制、再克隆 `source_root`;目录名不影响安装资格
- 绝对禁止在线更新技能
- 绝对禁止创建临时目录
- 仅允许:
  - 创建缺失的 `target_trae_path`
  - 刷新 `target_trae_path/rules/superpowers.md`
  - 刷新 `target_trae_path/UPSTREAM.md`
  - 刷新 `target_trae_path/hooks.json`
  - 刷新 `target_trae_path/hooks/`
  - 刷新 `target_trae_path/memory/superpowers.md`
  - 补齐或刷新官方 skills
  - 保留用户自定义规则和不重名技能
- 在此阶段:
  - 禁止删除 `target_trae_path/INSTALL.md`
  - 禁止删除 `source_root`
  - 禁止删除任何“引导仓库副本候选”

6) 阶段 1 自检门槛
- 复制或刷新后,必须立即验证:
  - `target_trae_path/rules/superpowers.md` 存在
  - `target_trae_path/UPSTREAM.md` 存在
  - `target_trae_path/hooks.json` 存在
  - `target_trae_path/hooks/session-start.ps1` 存在
  - `target_trae_path/hooks/user-prompt-submit.ps1` 存在
  - `target_trae_path/hooks/pre-run-command-guard.ps1` 存在
  - `target_trae_path/hooks/validate-package.ps1` 存在
  - `target_trae_path/hooks/README.md` 存在
  - `target_trae_path/memory/superpowers.md` 存在
  - `target_trae_path/skills/` 存在
  - `target_trae_path/skills/` 至少包含:
    - `using-superpowers`
    - `brainstorming`
    - `collision-zone-thinking`
    - `condition-based-waiting`
    - `defense-in-depth`
    - `dispatching-parallel-agents`
    - `executing-plans`
    - `finishing-a-development-branch`
    - `inversion-exercise`
    - `meta-pattern-recognition`
    - `preserving-productive-tensions`
    - `receiving-code-review`
    - `requesting-code-review`
    - `root-cause-tracing`
    - `scale-game`
    - `simplification-cascades`
    - `using-git-worktrees`
    - `writing-plans`
    - `subagent-driven-development`
    - `systematic-debugging`
    - `test-driven-development`
    - `verification-before-completion`
    - `testing-anti-patterns`
    - `testing-skills-with-subagents`
    - `tracing-knowledge-lineages`
    - `when-stuck`
    - `writing-skills`
  - 如果当前环境有 PowerShell,从目标项目根目录运行:
    `powershell -NoProfile -ExecutionPolicy Bypass -File ./.trae/hooks/validate-package.ps1`
- 若上述任一项失败,禁止进入记忆对齐或清理阶段。

7) 阶段 2: 记忆对齐 + 自检
- 只有阶段 1 自检通过后,才允许调用 `manage_core_memory`
- hooks、rules、skills 是基础运行契约;记忆是跨会话强化层。能调用 `manage_core_memory` 时必须配置,但记忆工具不可用或失败时,不得回滚已经通过验证的 `.trae` 基础安装。
- 记忆对齐必须拆成三个可验证动作:
  1. 删除同标题旧记忆
  2. 读取 `target_trae_path/memory/superpowers.md`,按其中 title、keywords、content 添加新记忆
  3. 立即做一次成功自检
- 记忆自检通过的判定:
  - 工具返回成功,且标题与 `memory_title` 完全一致
  - 若工具支持读取或确认,必须再做一次同标题确认
- 若记忆自检失败:
  - 禁止宣称记忆已配置
  - 不得回滚或删除已验证通过的 `.trae` 基础运行载荷
  - 只允许报告“基础 hooks/rules/skills 安装可用,但记忆对齐待完成”
- 若 `manage_core_memory` 不可用:
  - 不阻断基础安装
  - 报告“基础安装完成;记忆对齐因工具不可用而待完成”

8) 阶段 3: 清理阶段,仅在基础运行门槛通过后进入
- 进入清理阶段前,必须同时满足:
  - 路径自检通过
  - 阶段 1 自检通过
- 记忆对齐结果不阻断清理,但会影响最终表述: 记忆未通过时只能说“基础安装完成;记忆对齐待完成”。
- 清理后目标 `.trae` 顶层只能保留:
  - `hooks.json`
  - `hooks/`
  - `rules/`
  - `skills/`
  - `memory/`
- 清理后目标 `.trae/hooks/` 只能保留:
  - `session-start.ps1`
  - `user-prompt-submit.ps1`
  - `pre-run-command-guard.ps1`
- 以下安装期文件必须从目标 `.trae` 删除:
  - `INSTALL.md`
  - `UPSTREAM.md`
  - `hooks/README.md`
  - `hooks/validate-package.ps1`

bootstrap 模式清理:
- 删除上面列出的安装期文件
- 再删除当前工作区内除 `./.trae` 外的所有内容,包括 `./.git`、`./README.md`、`./LICENSE`、`./NOTICE.md`、`./.gitignore`

nested 模式清理:
- 删除上面列出的安装期文件
- 仅允许尝试删除本次根目录推导选中的 `source_root`
- 删除前必须确认 `source_root` 是唯一引导仓库副本候选,解析后的绝对路径位于 `target_root` 下,且不是 `target_root`、不是 `target_trae_path`
- 不得删除其它兄弟目录,不得为了清理旧失败流程而扩大删除范围;若存在多个候选,应在根目录推导阶段失败
- 对 `source_root` 最多执行一次递归删除;若失败,立即进入文件锁规则
- 旧失败流程残留的 `./.tmp-superpowers-*` 不属于本流程创建物,默认只报告路径,不自动删除

9) 文件锁规则
- 若在清理阶段删除 `source_root` 时遇到 Windows 文件锁:
  - 不得继续尝试其它删除策略
  - 不得使用 `cmd /c rmdir`
  - 不得用 `SilentlyContinue` 隐藏清理错误
  - 不得批量修改文件属性后再次递归删除
  - 不得再次修改 `target_trae_path`
  - 不得回滚已经安装好的 `.trae`
  - 直接报告残留路径
  - 提示用户关闭占用程序或重启后手动删除

10) 完成判定
- 只有在以下条件同时成立时,才允许宣称“安装完成”:
  - `target_trae_path` 位于正确的 `target_root`
  - `target_trae_path/rules/superpowers.md` 存在
  - `target_trae_path/UPSTREAM.md` 存在
  - `target_trae_path/hooks.json` 存在且定义 `SessionStart`、`UserPromptSubmit`、`PreToolUse` hooks
  - `target_trae_path/hooks/session-start.ps1` 存在
  - `target_trae_path/hooks/user-prompt-submit.ps1` 存在
  - `target_trae_path/hooks/pre-run-command-guard.ps1` 存在
  - `target_trae_path/skills/` 存在且包含核心技能
  - 包验证脚本在清理前通过,或 PowerShell 不可用时已手工完成同等检查
  - 最终 `.trae` 顶层只保留 `hooks.json`、`hooks/`、`rules/`、`skills/`、`memory/`
  - 最终 `.trae/hooks/` 只保留 `session-start.ps1`、`user-prompt-submit.ps1`、`pre-run-command-guard.ps1`
  - `INSTALL.md`、`UPSTREAM.md`、`hooks/README.md`、`hooks/validate-package.ps1` 不存在于最终目标 `.trae`
- 只有记忆自检通过时,才允许宣称“完整安装完成且记忆已配置”。记忆未通过或工具不可用时,只能宣称“基础安装完成;记忆对齐待完成”。
- nested 场景下,如果最终看到的是 `source_root/.trae` 或任何引导仓库候选目录内的 `.trae`,而不是 `target_root/.trae`,则必须判定为“安装到错误目录”,不能宣称完成。
