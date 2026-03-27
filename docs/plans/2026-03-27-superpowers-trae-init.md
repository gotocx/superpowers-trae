# Superpowers TRAE Initialization Plan

> **For Claude:** Use `${SUPERPOWERS_SKILLS_ROOT}/skills/collaboration/executing-plans/SKILL.md` to implement this plan task-by-task.

**Goal:** 发布一个公开的 `superpowers-trae` 仓库，上传当前 `.trae` 初始化内容，并准备一个可提交到 `trae-community/trae-templates` 的模板 PR。

**Architecture:** 本次工作分成两条交付线。第一条是用户自己的公开仓库，包含 `.trae`、README、LICENSE、NOTICE 和初始化说明；第二条是面向 `trae-community/trae-templates` 的模板目录，采用该仓库现有 `templates/tools-devops/<template-name>` 结构，并同步更新中英文根 README 的目录表。

**Tech Stack:** TRAE `.trae` 配置目录、Markdown 文档、GitHub MCP、MIT License

---

### Task 1: 生成仓库说明文件

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `NOTICE.md`
- Create: `.gitignore`

**Step 1: 写 README**

- 说明仓库改造自 `obra/superpowers`
- 明确这是 TRAE 迁移项目，不是上游官方仓库
- 写明当前已完成 `rule + skill` 初始化
- 写清用户只需拉取仓库并手动激活一条 `project` 级核心记忆
- 原样附上核心记忆模板

**Step 2: 写 LICENSE**

- 采用 MIT License
- 保留上游版权声明 `Copyright (c) 2025 Jesse Vincent`

**Step 3: 写 NOTICE**

- 说明仓库基于 `obra/superpowers` 改造
- 说明本仓库面向 TRAE 适配
- 声明与上游项目无官方从属或背书关系

**Step 4: 写 .gitignore**

- 忽略 `.DS_Store`
- 忽略 `Thumbs.db`
- 忽略常见日志与临时文件

**Step 5: 人工校验**

- 检查 README 中的仓库定位、记忆模板、法律说明是否完整

### Task 2: 创建公开仓库并上传初始化内容

**Files:**
- Modify: `.trae/**`
- Modify: `README.md`
- Modify: `LICENSE`
- Modify: `NOTICE.md`
- Modify: `.gitignore`

**Step 1: 创建公开 GitHub 仓库**

- 仓库名：`superpowers-trae`
- 描述：`TRAE migration of obra/superpowers with rules, skills, and memory setup guidance`
- 可见性：公开

**Step 2: 上传初始化文件**

- 上传根目录说明文件
- 递归上传当前 `.trae` 全量内容

**Step 3: 校验远端结果**

- 读取仓库根目录确认文件存在
- 读取 `README.md` 确认内容正确
- 读取 `.trae` 关键路径确认上传成功

### Task 3: 生成 TRAE Templates 模板内容

**Files:**
- Create: `deliverables/trae-templates/templates/tools-devops/superpowers-trae-init/README.md`
- Create: `deliverables/trae-templates/templates/tools-devops/superpowers-trae-init/README.zh-CN.md`
- Create: `deliverables/trae-templates/templates/tools-devops/superpowers-trae-init/.gitignore`
- Create: `deliverables/trae-templates/templates/tools-devops/superpowers-trae-init/.trae/**`

**Step 1: 选定模板类别**

- 使用 `templates/tools-devops/`
- 模板名暂定 `superpowers-trae-init`

**Step 2: 写模板说明**

- 说明用途：一键复制到项目中，初始化 TRAE 的 Superpowers 工作流
- 说明包含内容：`rule + skill + 记忆激活说明`
- 说明使用方法：复制 `.trae`，阅读说明，手动添加核心记忆

**Step 3: 组织模板文件**

- 模板目录内保留 `.trae`
- 增加模板自己的中英文 README

**Step 4: 校验模板最小可用性**

- 检查目录结构是否符合 `trae-community/trae-templates` 现有模式
- 检查 README 是否足够支撑直接复制使用

### Task 4: 生成 PR 所需的仓库变更草案

**Files:**
- Create: `deliverables/trae-templates/README.md.patch`
- Create: `deliverables/trae-templates/README.zh-CN.md.patch`
- Create: `deliverables/trae-templates/PR_BODY.md`

**Step 1: 规划 README 英文目录项**

- 在 `Tools & DevOps` 表格新增模板
- 文案简洁说明该模板用于初始化 TRAE Superpowers 工作流

**Step 2: 规划 README 中文目录项**

- 在 `工具与配置` 表格新增模板
- 文案与英文保持一致

**Step 3: 写 PR 描述**

- 说明模板做什么
- 说明为什么对 TRAE 用户有用
- 说明法律归属与上游引用处理方式

**Step 4: 校验与贡献要求对齐**

- 确认模板目录含 `README.md`
- 确认同步更新中英文根 README
- 确认结构最小但完整

### Task 5: 产出提交路径建议

**Files:**
- Create: `deliverables/trae-templates/SUBMISSION_PLAN.md`

**Step 1: 规划 Fork 与分支**

- Fork `trae-community/trae-templates`
- 建议分支名：`feat/superpowers-trae-init-template`

**Step 2: 规划提交内容**

- 新增模板目录
- 更新根 `README.md`
- 更新根 `README.zh-CN.md`

**Step 3: 规划 PR 标题**

- `feat: add superpowers-trae-init template`

**Step 4: 规划验证**

- 再次检查模板目录、README、中文 README、PR 描述
