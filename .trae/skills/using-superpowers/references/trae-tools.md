# Trae Tool Mapping

Use this reference when upstream Superpowers instructions mention Claude Code, Codex, Gemini, or generic agent tools.

| Upstream reference | Trae equivalent |
|---|---|
| `Skill` tool | `Skill(name="<skill-name>")` |
| `superpowers:<skill-name>` | `Skill(name="<skill-name>")` |
| `Task tool (general-purpose)` | Trae `Task` subagent using the provided prompt |
| `TodoWrite` | Trae `TodoWrite` task list |
| `Read`, `Write`, `Edit` | Trae file tools |
| `Bash` | Trae terminal/shell command |
| `manage_core_memory` | Trae project memory tool |

When a skill references a prompt template, read that template and pass the completed prompt to Trae `Task`. Do not ask subagents to infer context from chat history.

When a skill references local memory scripts from older Superpowers versions, skip those scripts and use `manage_core_memory`.
