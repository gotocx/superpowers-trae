# Superpowers for Trae

**ATTENTION AI:** This project uses the Superpowers Agentic Framework adapted for Trae. The `.trae/skills` directory contains the runtime skills. The rules below are mandatory workflow constraints.

## 1. Instruction Priority

1. User instructions, repository instructions, and direct requests are highest priority.
2. Superpowers skills define how to perform engineering work.
3. Default model habits are lowest priority.

If a user instruction conflicts with a Superpowers skill, follow the user and state the conflict.

## 2. Iron Laws

- **No fix without root cause:** for bugs, test failures, or unexpected behavior, use `Skill(name="systematic-debugging")` before proposing fixes.
- **No production code without a red test:** before implementation, use `Skill(name="test-driven-development")`.
- **No blind mock assertions:** when tests involve mocks, use `Skill(name="testing-anti-patterns")`.
- **No success claim without evidence:** before saying work is done, fixed, passing, installed, or updated, use `Skill(name="verification-before-completion")` and verify real command output or observable state.

## 3. Trae Tool Mapping

Translate upstream Superpowers tool names to Trae native tools:

| Upstream wording | Trae action |
|---|---|
| `superpowers:<skill>` or Skill tool | `Skill(name="<skill>")` |
| `TodoWrite` | Trae `TodoWrite` |
| `Task tool (general-purpose)` | Trae `Task` subagent with the completed prompt template |
| `Read`, `Write`, `Edit` | Trae file tools |
| `Bash` | Trae shell/terminal |
| local conversation memory scripts | `manage_core_memory` |

Do not use old `find-skills`, `skill-run`, or `remembering-conversations` scripts in Trae. Skill invocation must use the native Skill tool.

## 4. Mandatory Skill Triggers

Invoke the matching skill before responding or acting.

### Session Start

| Situation | Required skill |
|---|---|
| Starting a new conversation or project task | `Skill(name="using-superpowers")` |

### Architecture and Planning

| Situation | Required skill |
|---|---|
| New feature, rewrite, refactor, UI, behavior change, or project idea | `Skill(name="brainstorming")` |
| A spec or requirements need an implementation plan | `Skill(name="writing-plans")` |
| Need isolated work before implementation | `Skill(name="using-git-worktrees")` |
| Stuck on complexity, assumptions, scale, or approach | `Skill(name="when-stuck")` |

### Implementation and Review

| Situation | Required skill |
|---|---|
| Executing an implementation plan with independent tasks | `Skill(name="subagent-driven-development")` |
| Executing a plan inline or when subagents are unavailable | `Skill(name="executing-plans")` |
| Before first line of production code | `Skill(name="test-driven-development")` |
| Writing or changing tests with mocks/test doubles | `Skill(name="testing-anti-patterns")` |
| Completing a major task or before merge/PR | `Skill(name="requesting-code-review")` |
| Receiving review feedback | `Skill(name="receiving-code-review")` |

### Debugging and Completion

| Situation | Required skill |
|---|---|
| Bug, failing test, crash, or unexpected behavior | `Skill(name="systematic-debugging")` |
| Symptom appears deep in a stack and origin is unclear | `Skill(name="root-cause-tracing")` |
| Async test uses `sleep`, `setTimeout`, polling guesses, or is flaky | `Skill(name="condition-based-waiting")` |
| Root cause is found and validation should prevent recurrence | `Skill(name="defense-in-depth")` |
| About to claim done/fixed/passing/installed/updated | `Skill(name="verification-before-completion")` |
| Implementation is complete and branch/worktree needs finishing | `Skill(name="finishing-a-development-branch")` |

### Skill Maintenance

| Situation | Required skill |
|---|---|
| Creating, editing, migrating, or testing skills | `Skill(name="writing-skills")` |
| Testing skill behavior with pressure scenarios | `Skill(name="testing-skills-with-subagents")` |

## 5. Flattened Skill Compatibility

Upstream Superpowers v5 keeps several techniques as reference files inside parent skills. This Trae package intentionally exposes the important ones as flat skills so trigger matching stays reliable:

- `condition-based-waiting`
- `defense-in-depth`
- `root-cause-tracing`
- `testing-anti-patterns`
- `testing-skills-with-subagents`

If a scenario matches one of these, call the flat skill directly.

## 6. Required Task Tracking

When a skill contains a checklist, phase list, graph, or multi-step process, the first action after invoking it is to create Trae `TodoWrite` items for those steps. Mark items complete as work actually completes.

## 7. Memory

Use `manage_core_memory` for persistent project decisions, architectural constraints, recurring lessons, and Superpowers workflow reminders. Do not run the old local conversation-indexing tools.

## 8. Anti-Rationalization Checks

If any of these thoughts appear, stop and invoke the relevant skill:

- "This is too small for a workflow."
- "I need to inspect files first."
- "I already know what this skill says."
- "I'll add tests after the code works."
- "The test failure is obvious."
- "Manual verification is enough."
- "The user asked for speed, so I can skip review."
