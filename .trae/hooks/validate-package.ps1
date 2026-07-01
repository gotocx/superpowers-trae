param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $script:failures.Add($Message) | Out-Null
}

function Test-RequiredPath {
    param(
        [string]$RelativePath,
        [string]$Description = $RelativePath
    )

    $fullPath = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-Failure "Missing $Description at $RelativePath"
    }
}

function Get-HookCommands {
    param(
        [object]$HooksConfig,
        [string]$EventName
    )

    $commands = @()
    foreach ($group in @($HooksConfig.hooks.$EventName)) {
        foreach ($hook in @($group.hooks)) {
            if ($hook.type -eq "command") {
                $commands += [string]$hook.command
            }
        }
    }
    return $commands
}

function Invoke-WithStdin {
    param(
        [string]$ScriptPath,
        [string]$InputText
    )

    $oldIn = [Console]::In
    try {
        [Console]::SetIn([System.IO.StringReader]::new($InputText))
        return (& $ScriptPath 2>&1 | Out-String)
    }
    finally {
        [Console]::SetIn($oldIn)
    }
}

$traeRoot = Join-Path $RepoRoot ".trae"
$hooksJsonPath = Join-Path $traeRoot "hooks.json"
$sessionHookPath = Join-Path $traeRoot "hooks/session-start.ps1"
$promptHookPath = Join-Path $traeRoot "hooks/user-prompt-submit.ps1"
$guardHookPath = Join-Path $traeRoot "hooks/pre-run-command-guard.ps1"

Test-RequiredPath ".trae/rules/superpowers.md" "Trae Superpowers rule"
Test-RequiredPath ".trae/UPSTREAM.md" "upstream sync status"
Test-RequiredPath ".trae/hooks.json" "Trae hooks config"
Test-RequiredPath ".trae/hooks/README.md" "hook documentation"
Test-RequiredPath ".trae/hooks/session-start.ps1" "SessionStart hook"
Test-RequiredPath ".trae/hooks/user-prompt-submit.ps1" "UserPromptSubmit hook"
Test-RequiredPath ".trae/hooks/pre-run-command-guard.ps1" "PreToolUse RunCommand guard hook"
Test-RequiredPath ".trae/hooks/validate-package.ps1" "package validator"
Test-RequiredPath ".trae/memory/superpowers.md" "memory payload"

$requiredSkills = @(
    "using-superpowers",
    "brainstorming",
    "collision-zone-thinking",
    "condition-based-waiting",
    "defense-in-depth",
    "dispatching-parallel-agents",
    "executing-plans",
    "finishing-a-development-branch",
    "inversion-exercise",
    "meta-pattern-recognition",
    "preserving-productive-tensions",
    "receiving-code-review",
    "requesting-code-review",
    "root-cause-tracing",
    "scale-game",
    "simplification-cascades",
    "subagent-driven-development",
    "systematic-debugging",
    "test-driven-development",
    "testing-anti-patterns",
    "testing-skills-with-subagents",
    "tracing-knowledge-lineages",
    "using-git-worktrees",
    "verification-before-completion",
    "when-stuck",
    "writing-plans",
    "writing-skills"
)

foreach ($skill in $requiredSkills) {
    Test-RequiredPath ".trae/skills/$skill/SKILL.md" "required skill $skill"
}

$requiredSkillScripts = @(
    ".trae/skills/brainstorming/scripts/helper.js",
    ".trae/skills/brainstorming/scripts/server.cjs",
    ".trae/skills/brainstorming/scripts/start-server.sh",
    ".trae/skills/brainstorming/scripts/stop-server.sh",
    ".trae/skills/subagent-driven-development/scripts/task-brief",
    ".trae/skills/subagent-driven-development/scripts/review-package",
    ".trae/skills/subagent-driven-development/scripts/sdd-workspace",
    ".trae/skills/subagent-driven-development/task-reviewer-prompt.md",
    ".trae/skills/systematic-debugging/find-polluter.sh",
    ".trae/skills/writing-skills/render-graphs.js"
)

foreach ($scriptPath in $requiredSkillScripts) {
    Test-RequiredPath $scriptPath "upstream skill support script"
}

if (Test-Path -LiteralPath $hooksJsonPath) {
    try {
        $hooksConfig = Get-Content -LiteralPath $hooksJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

        foreach ($eventName in @("SessionStart", "UserPromptSubmit", "PreToolUse")) {
            if (-not $hooksConfig.hooks.$eventName) {
                Add-Failure "hooks.json does not define hooks.$eventName"
            }
        }

        $sessionCommands = Get-HookCommands $hooksConfig "SessionStart"
        if (-not ($sessionCommands | Where-Object { $_ -match "\.trae[/\\]hooks[/\\]session-start\.ps1" })) {
            Add-Failure "hooks.SessionStart does not call .trae/hooks/session-start.ps1"
        }

        $promptCommands = Get-HookCommands $hooksConfig "UserPromptSubmit"
        if (-not ($promptCommands | Where-Object { $_ -match "\.trae[/\\]hooks[/\\]user-prompt-submit\.ps1" })) {
            Add-Failure "hooks.UserPromptSubmit does not call .trae/hooks/user-prompt-submit.ps1"
        }

        $preToolGroups = @($hooksConfig.hooks.PreToolUse)
        if (-not ($preToolGroups | Where-Object { $_.matcher -eq "RunCommand" })) {
            Add-Failure "hooks.PreToolUse does not define matcher RunCommand"
        }

        $preToolCommands = Get-HookCommands $hooksConfig "PreToolUse"
        if (-not ($preToolCommands | Where-Object { $_ -match "\.trae[/\\]hooks[/\\]pre-run-command-guard\.ps1" })) {
            Add-Failure "hooks.PreToolUse does not call .trae/hooks/pre-run-command-guard.ps1"
        }
    }
    catch {
        Add-Failure "hooks.json is not valid JSON: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $sessionHookPath) {
    try {
        $output = & $sessionHookPath 2>&1 | Out-String
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            Add-Failure "session-start.ps1 exited with code $LASTEXITCODE"
        }
        if ($output -notmatch "<EXTREMELY_IMPORTANT>") {
            Add-Failure "session-start.ps1 output is missing EXTREMELY_IMPORTANT wrapper"
        }
        if ($output -notmatch "Using Superpowers in Trae") {
            Add-Failure "session-start.ps1 output does not include using-superpowers skill content"
        }
        if ($output -notmatch 'Skill\(name="<skill>"\)') {
            Add-Failure "session-start.ps1 output does not include Trae Skill invocation mapping"
        }
        if ($output.Length -gt 50000) {
            Add-Failure "session-start.ps1 output is too large ($($output.Length) chars); keep runtime context compact"
        }
    }
    catch {
        Add-Failure "session-start.ps1 smoke test failed: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $promptHookPath) {
    try {
        $output = & $promptHookPath 2>&1 | Out-String
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            Add-Failure "user-prompt-submit.ps1 exited with code $LASTEXITCODE"
        }
        if ($output -notmatch "<SUPERPOWERS_RUNTIME_REMINDER>") {
            Add-Failure "user-prompt-submit.ps1 output is missing SUPERPOWERS_RUNTIME_REMINDER wrapper"
        }
        if ($output -notmatch "verification-before-completion") {
            Add-Failure "user-prompt-submit.ps1 output does not remind about completion verification"
        }
        if ($output.Length -gt 2000) {
            Add-Failure "user-prompt-submit.ps1 output is too large ($($output.Length) chars); keep per-turn context compact"
        }
    }
    catch {
        Add-Failure "user-prompt-submit.ps1 smoke test failed: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $guardHookPath) {
    try {
        $allowInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"git status --short"}}'
        $allowOutput = Invoke-WithStdin $guardHookPath $allowInput
        $allowJson = $allowOutput | ConvertFrom-Json
        if ($allowJson.hookSpecificOutput.permissionDecision -ne "allow") {
            Add-Failure "pre-run-command-guard.ps1 did not allow a benign RunCommand payload"
        }

        $denyInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"powershell -File ./.trae/INSTALL.md"}}'
        $denyOutput = Invoke-WithStdin $guardHookPath $denyInput
        $denyJson = $denyOutput | ConvertFrom-Json
        if ($denyJson.hookSpecificOutput.permissionDecision -ne "deny") {
            Add-Failure "pre-run-command-guard.ps1 did not deny executing Markdown as a script"
        }

        $askInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"git reset --hard"}}'
        $askOutput = Invoke-WithStdin $guardHookPath $askInput
        $askJson = $askOutput | ConvertFrom-Json
        if ($askJson.hookSpecificOutput.permissionDecision -ne "ask") {
            Add-Failure "pre-run-command-guard.ps1 did not ask before destructive git cleanup"
        }
    }
    catch {
        Add-Failure "pre-run-command-guard.ps1 smoke test failed: $($_.Exception.Message)"
    }
}

$memoryPath = Join-Path $traeRoot "memory/superpowers.md"
if (Test-Path -LiteralPath $memoryPath) {
    $memoryText = Get-Content -LiteralPath $memoryPath -Raw -Encoding UTF8
    if ($memoryText -notmatch "Superpowers memory payload") {
        Add-Failure "memory payload is missing the canonical memory title"
    }
    if ($memoryText -notmatch "manage_core_memory") {
        Add-Failure "memory payload does not describe manage_core_memory usage"
    }
    if ($memoryText.Length -gt 3000) {
        Add-Failure "memory payload is too large ($($memoryText.Length) chars); keep persistent context compact"
    }
}

if ($failures.Count -gt 0) {
    Write-Output "Superpowers for Trae validation failed:"
    foreach ($failure in $failures) {
        Write-Output "- $failure"
    }
    exit 1
}

Write-Output "Superpowers for Trae validation passed."
Write-Output "Checked rules, 3 Trae hooks, hook smoke output, memory payload, $($requiredSkills.Count) skills, and $($requiredSkillScripts.Count) upstream support scripts."
