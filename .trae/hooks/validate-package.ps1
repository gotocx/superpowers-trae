param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path,
    [switch]$SkipSelfPruneSmoke
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

function Get-HookScriptRelativePath {
    param(
        [string]$Command
    )

    if ($Command -match '(?i)-EncodedCommand') {
        return $null
    }

    if ($Command -notmatch '(?i)^powershell(?:\.exe)?\s+-NoProfile\s+-ExecutionPolicy\s+Bypass\s+-File\s+(.+)$') {
        return $null
    }

    $path = $Matches[1].Trim().Trim('"').Trim("'")
    return (($path -replace "\\", "/") -replace '^\./', '')
}

function Test-HookScriptReference {
    param(
        [string]$Command,
        [string]$ExpectedRelativePath,
        [string]$Description
    )

    $actualRelativePath = Get-HookScriptRelativePath $Command
    if (-not $actualRelativePath) {
        Add-Failure "$Description command must directly run a readable .trae/hooks/*.ps1 script with -File"
        return
    }

    $expected = ($ExpectedRelativePath -replace "\\", "/")
    if ($actualRelativePath -ne $expected) {
        Add-Failure "$Description command references $actualRelativePath, expected $expected"
    }

    $fullPath = Join-Path $RepoRoot $ExpectedRelativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-Failure "$Description script does not exist at $ExpectedRelativePath"
    }
}

function Invoke-HookCommand {
    param(
        [string]$Command,
        [string]$InputText = ""
    )

    $relativePath = Get-HookScriptRelativePath $Command
    if (-not $relativePath) {
        throw "Hook command does not reference a script with -File"
    }

    $scriptPath = Join-Path $RepoRoot $relativePath
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell"
    $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $startInfo.WorkingDirectory = $RepoRoot
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    [void]$process.Start()
    if ($InputText) {
        $process.StandardInput.Write($InputText)
    }
    $process.StandardInput.Close()
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()

    return [pscustomobject]@{
        ExitCode = $process.ExitCode
        Output = ($stdout + $stderr)
        Stdout = $stdout
        Stderr = $stderr
    }
}

function Get-HookAdditionalContext {
    param(
        [object]$Result,
        [string]$EventName,
        [string]$Description
    )

    $raw = $Result.Stdout.Trim()
    if ([string]::IsNullOrWhiteSpace($raw)) {
        Add-Failure "$Description hook did not write JSON output"
        return ""
    }

    try {
        $json = $raw | ConvertFrom-Json
        if (-not $json.hookSpecificOutput) {
            Add-Failure "$Description hook output is missing hookSpecificOutput"
            return ""
        }
        if ($json.hookSpecificOutput.hookEventName -ne $EventName) {
            Add-Failure "$Description hook output has hookEventName $($json.hookSpecificOutput.hookEventName), expected $EventName"
        }
        if ([string]::IsNullOrWhiteSpace([string]$json.hookSpecificOutput.additionalContext)) {
            Add-Failure "$Description hook output is missing additionalContext"
            return ""
        }
        return [string]$json.hookSpecificOutput.additionalContext
    }
    catch {
        Add-Failure "$Description hook output is not valid Trae hook JSON: $($_.Exception.Message)"
        return ""
    }
}

$traeRoot = Join-Path $RepoRoot ".trae"
$hooksJsonPath = Join-Path $traeRoot "hooks.json"
$sessionHookPath = Join-Path $traeRoot "hooks/session-start.ps1"
$promptHookPath = Join-Path $traeRoot "hooks/user-prompt-submit.ps1"
$guardHookPath = Join-Path $traeRoot "hooks/pre-run-command-guard.ps1"
$selfPrunePath = Join-Path $traeRoot "hooks/self-prune-source.ps1"
$sessionCommand = $null
$promptCommand = $null
$guardCommand = $null

Test-RequiredPath ".trae/rules/superpowers.md" "Trae Superpowers rule"
Test-RequiredPath ".trae/hooks.json" "Trae hooks config"
Test-RequiredPath ".trae/hooks/session-start.ps1" "SessionStart hook"
Test-RequiredPath ".trae/hooks/user-prompt-submit.ps1" "UserPromptSubmit hook"
Test-RequiredPath ".trae/hooks/pre-run-command-guard.ps1" "optional PreToolUse RunCommand guard script"
Test-RequiredPath ".trae/hooks/validate-package.ps1" "package validator"
Test-RequiredPath ".trae/hooks/self-prune-source.ps1" "source self-prune helper"

$requiredAgents = @(
    "superpowers-implementer",
    "superpowers-task-reviewer",
    "superpowers-code-reviewer",
    "superpowers-plan-reviewer"
)

foreach ($agent in $requiredAgents) {
    $relativePath = ".trae/agents/$agent.md"
    Test-RequiredPath $relativePath "required agent $agent"
    $fullPath = Join-Path $RepoRoot $relativePath
    if (Test-Path -LiteralPath $fullPath) {
        $agentText = Get-Content -LiteralPath $fullPath -Raw -Encoding UTF8
        if ($agentText -notmatch "(?s)^---\s+.*name:\s*$agent\s+.*description:\s+.+?---") {
            Add-Failure "Agent $agent is missing YAML frontmatter name/description"
        }
    }
}

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

$rulePath = Join-Path $traeRoot "rules/superpowers.md"
if (Test-Path -LiteralPath $rulePath) {
    $ruleText = Get-Content -LiteralPath $rulePath -Raw -Encoding UTF8
    foreach ($requiredRuleText in @(
        'Rule Reinforcement',
        '.trae/hooks.json',
        'self-prune-source.ps1',
        '.trae/skills/using-superpowers/SKILL.md',
        'strongest subagent',
        'Do not claim `.trae/agents` is missing',
        'systematic-debugging',
        'verification-before-completion',
        'Trae `TodoWrite`'
    )) {
        if ($ruleText -notmatch [regex]::Escape($requiredRuleText)) {
            Add-Failure "rules/superpowers.md is missing required reinforcement text: $requiredRuleText"
        }
    }

    if ($ruleText -match "manage_core_memory") {
        Add-Failure "rules/superpowers.md still depends on manage_core_memory"
    }
    if ($ruleText -match "\.trae/memory") {
        Add-Failure "rules/superpowers.md still references .trae/memory"
    }
}

if (Test-Path -LiteralPath $hooksJsonPath) {
    try {
        $hooksConfig = Get-Content -LiteralPath $hooksJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

        foreach ($eventName in @("SessionStart", "UserPromptSubmit")) {
            if (-not $hooksConfig.hooks.$eventName) {
                Add-Failure "hooks.json does not define hooks.$eventName"
            }
        }

        if ($hooksConfig.hooks.PreToolUse) {
            Add-Failure "hooks.json must not register PreToolUse by default; Windows Trae hosts can strand PowerShell stdin readers"
        }

        $sessionCommands = @(Get-HookCommands $hooksConfig "SessionStart")
        if ($sessionCommands.Count -ne 1) {
            Add-Failure "hooks.SessionStart should define exactly one command hook"
        }
        else {
            $sessionCommand = $sessionCommands[0]
            Test-HookScriptReference $sessionCommand ".trae/hooks/session-start.ps1" "hooks.SessionStart"
        }

        $promptCommands = @(Get-HookCommands $hooksConfig "UserPromptSubmit")
        if ($promptCommands.Count -ne 1) {
            Add-Failure "hooks.UserPromptSubmit should define exactly one command hook"
        }
        else {
            $promptCommand = $promptCommands[0]
            Test-HookScriptReference $promptCommand ".trae/hooks/user-prompt-submit.ps1" "hooks.UserPromptSubmit"
        }

    }
    catch {
        Add-Failure "hooks.json is not valid JSON: $($_.Exception.Message)"
    }
}

if ($sessionCommand) {
    try {
        $result = Invoke-HookCommand $sessionCommand
        if ($result.ExitCode -ne 0) {
            Add-Failure "SessionStart hook exited with code $($result.ExitCode)"
        }
        $context = Get-HookAdditionalContext $result "SessionStart" "SessionStart"
        if ($context -notmatch "<EXTREMELY_IMPORTANT>") {
            Add-Failure "SessionStart hook additionalContext is missing EXTREMELY_IMPORTANT wrapper"
        }
        if ($context -notmatch "Using Superpowers in Trae") {
            Add-Failure "SessionStart hook additionalContext does not include using-superpowers skill content"
        }
        if ($context -notmatch '\.trae/skills/<name>/SKILL\.md') {
            Add-Failure "SessionStart hook additionalContext does not include Trae automatic skill fallback mapping"
        }
        if ($context.Length -gt 50000) {
            Add-Failure "SessionStart hook additionalContext is too large ($($context.Length) chars); keep runtime context compact"
        }
    }
    catch {
        Add-Failure "SessionStart hook smoke test failed: $($_.Exception.Message)"
    }
}

if ($promptCommand) {
    try {
        $result = Invoke-HookCommand $promptCommand
        if ($result.ExitCode -ne 0) {
            Add-Failure "UserPromptSubmit hook exited with code $($result.ExitCode)"
        }
        $context = Get-HookAdditionalContext $result "UserPromptSubmit" "UserPromptSubmit"
        if ($context -notmatch "<SUPERPOWERS_RUNTIME_REMINDER>") {
            Add-Failure "UserPromptSubmit hook additionalContext is missing SUPERPOWERS_RUNTIME_REMINDER wrapper"
        }
        foreach ($requiredPromptContext in @("executing-plans", "test-driven-development", "strongest available subagent", "Do not claim .trae/agents is missing", "verification-before-completion")) {
            if ($context -notmatch [regex]::Escape($requiredPromptContext)) {
                Add-Failure "UserPromptSubmit hook additionalContext does not remind about $requiredPromptContext"
            }
        }
        if ($context.Length -gt 2000) {
            Add-Failure "UserPromptSubmit hook additionalContext is too large ($($context.Length) chars); keep per-turn context compact"
        }
    }
    catch {
        Add-Failure "UserPromptSubmit hook smoke test failed: $($_.Exception.Message)"
    }
}

if ((-not $SkipSelfPruneSmoke) -and (Test-Path -LiteralPath $selfPrunePath)) {
    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "powershell"
        $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$selfPrunePath`" -SourceRoot `"$RepoRoot`" -TargetRoot `"$RepoRoot`" -TargetTraePath `"$traeRoot`" -DryRun"
        $startInfo.WorkingDirectory = $RepoRoot
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        if ($process.ExitCode -eq 0) {
            Add-Failure "self-prune helper allowed SourceRoot equal to TargetRoot"
        }
        if (($stdout + $stderr) -notmatch "Self-prune refused") {
            Add-Failure "self-prune helper boundary refusal output was not explicit"
        }

        $selfPruneText = Get-Content -LiteralPath $selfPrunePath -Raw -Encoding UTF8
        foreach ($forbiddenPattern in @("cmd /c", "rmdir /s", "SilentlyContinue")) {
            if ($selfPruneText -match [regex]::Escape($forbiddenPattern)) {
                Add-Failure "self-prune helper contains forbidden cleanup pattern: $forbiddenPattern"
            }
        }
        if ($selfPruneText -notmatch 'Remove-Item\s+-LiteralPath\s+\$sourceResolved') {
            Add-Failure "self-prune helper must delete only the resolved SourceRoot via Remove-Item -LiteralPath"
        }
    }
    catch {
        Add-Failure "self-prune helper smoke test failed: $($_.Exception.Message)"
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
Write-Output "Checked rules, $($requiredAgents.Count) named agents, 2 registered Trae hooks, optional RunCommand guard script, source self-prune helper, hook smoke output, $($requiredSkills.Count) skills, and $($requiredSkillScripts.Count) upstream support scripts."
