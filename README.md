AI 初始化指令（严格版）

0) 文档角色
- `README.md` 与 `./.trae/INSTALL.md` 都是说明文件,不是脚本。
- 绝对禁止把 `README.md` 或 `INSTALL.md` 当命令执行、手动运行、搜索结果运行项或待删除目标。
- 绝对禁止为了安装 Superpowers 再去克隆、拉取或同步任何其他仓库。
- 绝对禁止创建任何 `.tmp-*`、`tmp`、`temp`、`.cache` 等临时目录。

1) 根目录定义
- 引导仓库根目录 = 包含本 `README.md` 的目录。
- 目标项目根目录 = 最终让 Trae 直接读取 `./.trae` 的目录。
- 源 `.trae` = 引导仓库根目录下现有的 `./.trae`。
- 冗余引导副本 = 目标项目根目录下仅用于分发的 `./superpowers-trae` 目录,且同时包含 `./README.md`、`./NOTICE.md`、`./LICENSE`、`./deliverables/`、`./docs/` 与 `./.trae/`。
- 旧临时残留 = 旧失败流程留下的 `./.tmp-superpowers-*` 目录。

2) 模式判定
- 仅当“目标项目根目录 = 引导仓库根目录”且当前目录可被100%确认是本仓库的 fresh clone 时,才允许进入 bootstrap 模式。
- 其他所有情况,包括当前仓库只是更大项目中的子目录、目标项目已有源码或已有 `./.trae`、你无法100%确认根目录时,全部视为 existing/nested 模式。
- existing/nested 模式下,不要继续按本文件自由发挥,立即切换到 `./.trae/INSTALL.md` 执行。
- 不要自创第三种模式。

3) bootstrap 模式固定顺序
1. 把当前目录里的 `./.trae` 直接视为最终目标 `.trae`。
2. 不复制、不创建任何临时目录、不拉取任何远端仓库。
3. 先验证 `./.trae/rules/superpowers.md` 与 `./.trae/skills/` 存在且可读。
4. 验证通过后,使用 `manage_core_memory` 在 project 级别删除同标题旧记忆,再添加新记忆。
5. 仅在记忆注入成功后,删除 `./.trae/INSTALL.md`。
6. 再删除当前工作区内除 `./.trae` 外的所有内容,包括 `./.git`、`./deliverables/`、`./docs/`、`./README.md`、`./LICENSE`、`./NOTICE.md`。
7. 完成判定: 工作区只剩 `./.trae`,且 `./.trae/INSTALL.md` 已删除。

4) existing/nested 模式总规则
- 安装源只能是当前引导仓库内现成的源 `.trae`。
- 绝对禁止拉取、克隆或临时下载 `obra/superpowers-skills` 或任何其他远端仓库。
- 绝对禁止创建 `.tmp-*` 或任何其他临时目录。
- 绝对禁止在目标 `.trae` 验证通过后继续修改它; 唯一允许的后续改动,是最后删除一次目标 `.trae/INSTALL.md`。
- 绝对禁止因为清理失败而回滚、覆盖或破坏已经安装完成的目标 `.trae`。
- 绝对禁止删除任何无法明确识别为“冗余引导副本”或“旧临时残留”的目录。
- 如需更新技能版本,应先更新本引导仓库自身内容,再重新执行安装; 安装过程本身禁止在线更新技能。

5) 项目记忆模板
- 标题: `Superpowers 严格工作流约束`
- 关键词: `superpowers|workflow|tdd|debugging|skills`
- 内容:
本项目严格遵循 obra/superpowers 开发方法论：
1. 功能开发必须先做设计与测试,遵循 brainstorming > using-git-worktrees > writing-plans > test-driven-development > code-review > finish-branch 的闭环。
2. 遇到报错或测试失败时,禁止猜测,必须调用 systematic-debugging 做根因排查。
3. 技能调用必须通过内置 Skill 工具真实执行。
4. 多步骤流程使用 TodoWrite。
5. 跨任务知识通过 manage_core_memory 沉淀。

6) 文件锁规则
- 若在删除“冗余引导副本”或“旧临时残留”时遇到 Windows 文件锁,不得再次修改目标 `.trae`。
- 直接报告残留路径,提示用户关闭占用程序或重启后手动删除。
- 只要目标 `.trae` 已可用且记忆注入成功,就视为安装成功; 文件锁只影响清理收尾,不影响安装结果。
