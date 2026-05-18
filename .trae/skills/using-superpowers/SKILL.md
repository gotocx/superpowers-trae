---
name: using-superpowers
description: Use when starting any conversation in Trae - establishes mandatory skill invocation, Trae tool mapping, and workflow priority before any response or action
---

<SUBAGENT-STOP>
If you were dispatched by Trae Task as a subagent for a specific task, skip this skill unless the task explicitly asks you to use it.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you MUST invoke the Trae Skill tool before responding or acting.

If a skill applies, you do not have a choice. Use it.
</EXTREMELY-IMPORTANT>

# Using Superpowers in Trae

## Instruction Priority

1. User's explicit instructions, project rules, and direct requests are highest priority.
2. Superpowers skills define the required workflow and override casual default behavior.
3. Default model habits are lowest priority.

If a user instruction conflicts with a skill, follow the user and state the conflict.

## Trae Tool Mapping

When upstream Superpowers text mentions another harness, translate it to Trae:

| Upstream wording | In Trae |
|---|---|
| `Skill` tool, `superpowers:<name>` | `Skill(name="<name>")` |
| `TodoWrite` | Trae `TodoWrite` task list |
| `Task tool (general-purpose)` | Trae `Task` subagent with the provided prompt template |
| `Read`, `Write`, `Edit` | Trae file tools |
| `Bash` | Trae terminal/shell tool |
| `manage_core_memory` or local conversation memory scripts | Trae `manage_core_memory` project memory |

Do not use legacy `find-skills`, `skill-run`, or `remembering-conversations` scripts in Trae. Skill discovery and invocation must happen through the native Skill tool and the project rules.

## The Rule

Invoke relevant or requested skills before any response, clarification, file read, shell command, implementation, or status claim.

If you invoke a skill:

1. Announce briefly: "I'm using `<skill>` to `<purpose>`."
2. If the skill has a checklist or multi-step process, create Trae `TodoWrite` items for the steps.
3. Follow the skill exactly unless the user explicitly overrides it.

If a skill contains prompt templates such as `implementer-prompt.md` or `code-reviewer.md`, load the template and pass its completed content to Trae Task. Do not rely on session history as a substitute for the template.

## Skill Priority

Use process skills before implementation skills.

| Situation | First skill |
|---|---|
| New feature, build, rewrite, behavior change | `brainstorming` |
| Written spec or requirements need an implementation plan | `writing-plans` |
| Executing a plan with independent tasks | `subagent-driven-development` |
| Executing a plan inline or without subagents | `executing-plans` |
| Starting implementation work | `test-driven-development` |
| Bug, test failure, or unexpected behavior | `systematic-debugging` |
| Deep symptom with unclear original cause | `root-cause-tracing` |
| Flaky async tests or sleeps/timeouts | `condition-based-waiting` |
| Before claiming done/fixed/passing | `verification-before-completion` |
| Before merge, PR, or major handoff | `requesting-code-review` |
| Completing branch/worktree workflow | `finishing-a-development-branch` |
| Writing or updating skills | `writing-skills` |

## Flattened Trae Skills

Upstream Superpowers v5 keeps some techniques as reference files inside parent skills. This Trae package also exposes the most important references as first-class skills so they can trigger directly:

- `condition-based-waiting`
- `defense-in-depth`
- `root-cause-tracing`
- `testing-anti-patterns`
- `testing-skills-with-subagents`

Use the flat skill name when the scenario matches, even if the parent skill also links to the same material.

## Red Flags

These thoughts mean stop and invoke the relevant skill:

| Thought | Reality |
|---|---|
| "This is just a simple question" | Questions are tasks. Check skills first. |
| "I need more context first" | Skill check comes before context gathering. |
| "Let me inspect files quickly" | Skills define how to inspect. |
| "I remember this skill" | Skills evolve. Invoke the current one. |
| "I'll code first and test later" | Use `test-driven-development` first. |
| "The test failure is obvious" | Use `systematic-debugging` first. |
| "I manually verified it" | Use `verification-before-completion` before success claims. |
| "Task/general-purpose is a Claude thing" | In Trae, use the native `Task` tool with the template. |

## Memory

For cross-session decisions, architecture constraints, and recurring project lessons, use Trae `manage_core_memory`. Do not install or run the old local conversation-indexing scripts.
