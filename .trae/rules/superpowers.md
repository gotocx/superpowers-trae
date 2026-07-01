# Superpowers for Trae

**ATTENTION AI:** This project uses the Superpowers Agentic Framework adapted for Trae. The `.trae/skills` directory contains the runtime skills. The rules below are mandatory workflow constraints.

The `.trae/hooks.json` hooks inject `using-superpowers` at session start, reinforce the contract on each user prompt, and guard risky shell commands before execution. If the SessionStart hook is disabled, unavailable, or visibly did not run, your first action before any task work is to invoke `Skill(name="using-superpowers")`.

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
| `Task tool (general-purpose)` | Trae `Task` subagent with the completed prompt template; use `.trae/agents` named agents when one matches |
| `Read`, `Write`, `Edit` | Trae file tools |
| `Bash` | Trae shell/terminal |

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

### Problem-Solving Additions

| Situation | Required skill |
|---|---|
| Conventional approaches feel inadequate and unrelated analogies may unlock options | `Skill(name="collision-zone-thinking")` |
| Hidden assumptions need to be flipped or challenged | `Skill(name="inversion-exercise")` |
| The same pattern appears across multiple domains | `Skill(name="meta-pattern-recognition")` |
| Two valid approaches optimize for different priorities | `Skill(name="preserving-productive-tensions")` |
| Scale, limits, or edge cases need stress testing | `Skill(name="scale-game")` |
| Complexity is growing through repeated special cases | `Skill(name="simplification-cascades")` |
| A technical choice needs historical or lineage context | `Skill(name="tracing-knowledge-lineages")` |

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

## 7. Rule Reinforcement

This rule file is the persistent Superpowers reinforcement layer for Trae. Do not require a separate memory payload or a memory tool to make Superpowers work.

- `.trae/hooks.json` must register `SessionStart`, `UserPromptSubmit`, and `PreToolUse` hooks.
- `.trae/agents/` contains named subagent definitions for common Superpowers dispatch roles.
- If `SessionStart` does not visibly inject `using-superpowers`, invoke `Skill(name="using-superpowers")` before any task work.
- For bugs, failed tests, crashes, and unexpected behavior, invoke `Skill(name="systematic-debugging")` before proposing or applying a fix.
- For deep call-stack symptoms or unclear origin, invoke `Skill(name="root-cause-tracing")`.
- For flaky async waits, sleeps, timeouts, or polling guesses, invoke `Skill(name="condition-based-waiting")`.
- Before production code, invoke `Skill(name="test-driven-development")`.
- Before claiming done, fixed, passing, installed, or updated, invoke `Skill(name="verification-before-completion")` and cite real evidence.
- Upstream `Task tool (general-purpose)` means Trae `Task`; upstream `TodoWrite` means Trae `TodoWrite`.
- Use named Trae subagents from `.trae/agents/` when they fit, but still pass complete task prompts and file paths.
- Multi-step skill workflows must be tracked with Trae `TodoWrite`.

## 8. Runtime Contract

- **Hook:** `.trae/hooks.json` registers `SessionStart`, `UserPromptSubmit`, and `PreToolUse` hooks that call readable scripts in `.trae/hooks/`.
- **Agents:** `.trae/agents/*.md` defines named subagents Trae can auto-load.
- **SessionStart:** injects the full `using-superpowers` skill.
- **UserPromptSubmit:** injects a compact per-turn reminder.
- **PreToolUse:** checks `RunCommand` for runtime deletion hazards.
- **Self-prune helper:** `.trae/hooks/self-prune-source.ps1` may remove only the verified bootstrap source clone after the target runtime validator passes.
- **Rule:** `.trae/rules/superpowers.md` defines non-negotiable trigger constraints.
- **Skill:** `.trae/skills/*/SKILL.md` contains the actual workflow instructions.
- **Reinforcement:** persistent workflow reminders live in this rule file.

During Superpowers installation or upgrade, never delete `.trae/hooks.json`, `.trae/hooks/`, `.trae/agents/`, `.trae/rules/`, or `.trae/skills/`. These are runtime files, not removable residue. If a nested bootstrap clone must be removed, use `.trae/hooks/self-prune-source.ps1`; do not reclone after the target runtime has already validated.

## 9. Anti-Rationalization Checks

If any of these thoughts appear, stop and invoke the relevant skill:

- "This is too small for a workflow."
- "I need to inspect files first."
- "I already know what this skill says."
- "I'll add tests after the code works."
- "The test failure is obvious."
- "Manual verification is enough."
- "The user asked for speed, so I can skip review."
