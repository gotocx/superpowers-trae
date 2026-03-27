# TRAE Templates PR Submission Plan

## Target

- Upstream: `https://github.com/trae-community/trae-templates`
- Fork: `https://github.com/gotocx/trae-templates`
- Branch: `feat/superpowers-trae-init-template`
- Template path: `templates/tools-devops/superpowers-trae-init`

## Required changes

1. 新增模板目录 `templates/tools-devops/superpowers-trae-init`
2. 将当前仓库根目录的 `.trae` 同步到模板目录内
3. 在模板目录下新增 `README.md`
4. 在模板目录下新增 `README.zh-CN.md`
5. 更新根 `README.md` 的 `Tools & DevOps` 表格
6. 更新根 `README.zh-CN.md` 的 `工具与配置` 表格

## Why this category

该模板本质上是面向 TRAE 的工作流初始化与配置分发，不属于具体前端、后端或移动技术栈，更适合放在 `tools-devops` 分类。

## Quality checks

- 模板目录必须至少包含 `README.md`
- 中英文文档都要可直接指导复制使用
- 结构应保持最小但完整
- 不包含密钥、令牌或私有配置
- 明确说明上游来源与许可证

## Suggested PR title

`feat: add superpowers-trae-init template`

## Suggested next execution

1. 将 fork 仓库克隆到独立目录
2. 切到 `feat/superpowers-trae-init-template`
3. 按本计划落地模板目录与 README 更新
4. 在 fork 上推送并发起 PR
