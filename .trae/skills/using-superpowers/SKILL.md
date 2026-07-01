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

This is not negotiable. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

# Using Superpowers in Trae

## Runtime Bootstrap

Trae should load this skill automatically through `.trae/hooks.json` on `SessionStart`. The same hook file also reinforces the workflow on `UserPromptSubmit` and guards risky `RunCommand` calls on `PreToolUse`. If you are in a Trae session and this skill was not injected, invoke `Skill(name="using-superpowers")` before doing any task work.

The runtime has four cooperating layers:

| Layer | File | Purpose |
|---|---|---|
| Hook | `.trae/hooks.json` | inject this skill at session start, reinforce each prompt, and guard risky shell commands |
| Agent | `.trae/agents/*.md` | provide named subagents for common Superpowers dispatch roles |
| Rule | `.trae/rules/superpowers.md` | keep mandatory triggers visible to the model |
| Skill | `.trae/skills/*/SKILL.md` | provide the workflow instructions |
| Rule reinforcement | `.trae/rules/superpowers.md` | keep the cross-session Superpowers contract without requiring Trae memory |

If these layers disagree, prefer direct user instructions first, then repository rules, then the current skill content.

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
| `Task tool (general-purpose)` | Trae `Task` subagent with the provided prompt template; use a matching `.trae/agents` named subagent when available |
| `Read`, `Write`, `Edit` | Trae file tools |
| `Bash` | Trae terminal/shell tool |
| local conversation memory scripts | not used in this Trae package |

Do not use legacy `find-skills`, `skill-run`, or `remembering-conversations` scripts in Trae. Skill discovery and invocation must happen through the native Skill tool and the project rules.

## The Rule

Invoke relevant or requested skills before any response, clarification, file read, shell command, implementation, or status claim.

Before entering plan mode or implementation planning: if you have not already brainstormed the work, invoke `Skill(name="brainstorming")` first.

If you invoke a skill:

1. Announce briefly: "I'm using `<skill>` to `<purpose>`."
2. If the skill has a checklist or multi-step process, create Trae `TodoWrite` items for the steps.
3. Follow the skill exactly unless the user explicitly overrides it.

If a skill contains prompt templates such as `implementer-prompt.md` or `code-reviewer.md`, load the template and pass its completed content to Trae Task. Prefer the matching named subagent from `.trae/agents/` when available:

- `superpowers-implementer` for `subagent-driven-development/implementer-prompt.md`
- `superpowers-task-reviewer` for `subagent-driven-development/task-reviewer-prompt.md`
- `superpowers-code-reviewer` for `requesting-code-review/code-reviewer.md`
- `superpowers-plan-reviewer` for `writing-plans/plan-document-reviewer-prompt.md`

Do not rely on session history as a substitute for the template or referenced files.

## Skill Priority

Use process skills before implementation skills. Brainstorming and systematic-debugging are Superpowers' most common process skills, but the rule holds for all of them.

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
| Stuck and unsure which problem-solving approach fits | `when-stuck` |

### Local Problem-Solving Additions

These Trae package skills are shipped at the same install level as upstream skills:

| Situation | Skill |
|---|---|
| Force unrelated concepts together for breakthrough options | `collision-zone-thinking` |
| Flip assumptions to reveal hidden constraints | `inversion-exercise` |
| Recognize repeated patterns across domains | `meta-pattern-recognition` |
| Preserve two valid approaches without premature collapse | `preserving-productive-tensions` |
| Stress-test architecture or decisions at extreme scale | `scale-game` |
| Remove multiple components with one simplifying insight | `simplification-cascades` |
| Trace why an idea or technical choice evolved | `tracing-knowledge-lineages` |

Examples:

- "Let's build X" -> `Skill(name="brainstorming")` first, then implementation/domain skills.
- "Fix this bug" -> `Skill(name="systematic-debugging")` first, then domain skills.

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
| "I can check git/files quickly" | Files lack conversation context. Check skills first. |
| "Let me gather information first" | Skills tell you how to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Invoke the current one. |
| "This doesn't count as a task" | Action equals task. Check skills first. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check before doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept is not the same as using the skill. Invoke it. |
| "I'll code first and test later" | Use `test-driven-development` first. |
| "The test failure is obvious" | Use `systematic-debugging` first. |
| "I manually verified it" | Use `verification-before-completion` before success claims. |
| "Task/general-purpose is a Claude thing" | In Trae, use the native `Task` tool with the template. |

## Hook Health

The expected Trae hook set is:

- `SessionStart` -> full `using-superpowers` bootstrap
- `UserPromptSubmit` -> compact per-turn reminder
- `PreToolUse` matcher `RunCommand` -> command guard
