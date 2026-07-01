# UserPromptSubmit hook for Superpowers for Trae.
# Keep this short: it is injected on every user prompt.

$ErrorActionPreference = "Stop"

function Write-AdditionalContext {
    param([string]$Context)

    @{
        continue = $true
        suppressOutput = $true
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = $Context
        }
    } | ConvertTo-Json -Depth 5 -Compress
}

$context = @"
<SUPERPOWERS_RUNTIME_REMINDER>
Before responding or acting, check whether Trae auto-loaded a relevant Superpowers skill. If not, open or read the matching .trae/skills/<skill>/SKILL.md before file reads, shell commands, implementation, debugging, planning, or completion claims.

Implementation or behavior changes require test-driven-development: create/modify the test first, run it and observe the expected failure, then write production code.
Written numbered implementation plans require executing-plans, then test-driven-development before production code.
For delegation, choose the strongest available subagent from Trae built-ins plus .trae/agents; strongest means best coverage of the user's current development need and required verification/review obligations.
Do not claim .trae/agents is missing unless you listed it from the current target root in this turn.
Bugs and failed tests require systematic-debugging.
Completion claims require verification-before-completion with real command output or observable state.
</SUPERPOWERS_RUNTIME_REMINDER>
"@

Write-AdditionalContext $context
