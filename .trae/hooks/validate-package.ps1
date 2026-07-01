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

function Get-EncodedCommandPayload {
    param(
        [string]$Command
    )

    if ($Command -notmatch '(?i)(?:^|\s)-EncodedCommand\s+([A-Za-z0-9+/=]+)(?:\s|$)') {
        return $null
    }

    return $Matches[1]
}

function Get-DecodedHookScript {
    param(
        [string]$Command
    )

    $encoded = Get-EncodedCommandPayload $Command
    if (-not $encoded) {
        return $null
    }

    return [Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encoded))
}

function Normalize-Text {
    param([string]$Text)
    return (($Text -replace "`r`n", "`n") -replace "`r", "`n").TrimEnd()
}

function Test-HookTemplateMatch {
    param(
        [string]$Command,
        [string]$TemplatePath,
        [string]$Description
    )

    $decoded = Get-DecodedHookScript $Command
    if (-not $decoded) {
        Add-Failure "$Description command is not self-contained with -EncodedCommand"
        return
    }

    $source = Get-Content -LiteralPath $TemplatePath -Raw -Encoding UTF8
    if ((Normalize-Text $decoded) -ne (Normalize-Text $source)) {
        Add-Failure "$Description encoded command does not match $TemplatePath"
    }
}

function Invoke-HookCommand {
    param(
        [string]$Command,
        [string]$InputText = ""
    )

    $encoded = Get-EncodedCommandPayload $Command
    if (-not $encoded) {
        throw "Hook command is missing -EncodedCommand"
    }

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell"
    $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encoded"
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

$traeRoot = Join-Path $RepoRoot ".trae"
$hooksJsonPath = Join-Path $traeRoot "hooks.json"
$sessionHookPath = Join-Path $traeRoot "hooks/session-start.ps1"
$promptHookPath = Join-Path $traeRoot "hooks/user-prompt-submit.ps1"
$guardHookPath = Join-Path $traeRoot "hooks/pre-run-command-guard.ps1"
$sessionCommand = $null
$promptCommand = $null
$guardCommand = $null

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

        $sessionCommands = @(Get-HookCommands $hooksConfig "SessionStart")
        if ($sessionCommands.Count -ne 1) {
            Add-Failure "hooks.SessionStart should define exactly one command hook"
        }
        else {
            $sessionCommand = $sessionCommands[0]
            if ($sessionCommand -match "\.trae[/\\]hooks[/\\]") {
                Add-Failure "hooks.SessionStart must be self-contained and must not reference .trae/hooks runtime scripts"
            }
            Test-HookTemplateMatch $sessionCommand $sessionHookPath "hooks.SessionStart"
        }

        $promptCommands = @(Get-HookCommands $hooksConfig "UserPromptSubmit")
        if ($promptCommands.Count -ne 1) {
            Add-Failure "hooks.UserPromptSubmit should define exactly one command hook"
        }
        else {
            $promptCommand = $promptCommands[0]
            if ($promptCommand -match "\.trae[/\\]hooks[/\\]") {
                Add-Failure "hooks.UserPromptSubmit must be self-contained and must not reference .trae/hooks runtime scripts"
            }
            Test-HookTemplateMatch $promptCommand $promptHookPath "hooks.UserPromptSubmit"
        }

        $preToolGroups = @($hooksConfig.hooks.PreToolUse)
        if (-not ($preToolGroups | Where-Object { $_.matcher -eq "RunCommand" })) {
            Add-Failure "hooks.PreToolUse does not define matcher RunCommand"
        }

        $preToolCommands = @(Get-HookCommands $hooksConfig "PreToolUse")
        if ($preToolCommands.Count -ne 1) {
            Add-Failure "hooks.PreToolUse should define exactly one command hook"
        }
        else {
            $guardCommand = $preToolCommands[0]
            if ($guardCommand -match "\.trae[/\\]hooks[/\\]") {
                Add-Failure "hooks.PreToolUse must be self-contained and must not reference .trae/hooks runtime scripts"
            }
            Test-HookTemplateMatch $guardCommand $guardHookPath "hooks.PreToolUse"
        }
    }
    catch {
        Add-Failure "hooks.json is not valid JSON: $($_.Exception.Message)"
    }
}

if ($sessionCommand) {
    try {
        $result = Invoke-HookCommand $sessionCommand
        $output = $result.Output
        if ($result.ExitCode -ne 0) {
            Add-Failure "SessionStart encoded hook exited with code $($result.ExitCode)"
        }
        if ($output -notmatch "<EXTREMELY_IMPORTANT>") {
            Add-Failure "SessionStart encoded hook output is missing EXTREMELY_IMPORTANT wrapper"
        }
        if ($output -notmatch "Using Superpowers in Trae") {
            Add-Failure "SessionStart encoded hook output does not include using-superpowers skill content"
        }
        if ($output -notmatch 'Skill\(name="<skill>"\)') {
            Add-Failure "SessionStart encoded hook output does not include Trae Skill invocation mapping"
        }
        if ($output.Length -gt 50000) {
            Add-Failure "SessionStart encoded hook output is too large ($($output.Length) chars); keep runtime context compact"
        }
    }
    catch {
        Add-Failure "SessionStart encoded hook smoke test failed: $($_.Exception.Message)"
    }
}

if ($promptCommand) {
    try {
        $result = Invoke-HookCommand $promptCommand
        $output = $result.Output
        if ($result.ExitCode -ne 0) {
            Add-Failure "UserPromptSubmit encoded hook exited with code $($result.ExitCode)"
        }
        if ($output -notmatch "<SUPERPOWERS_RUNTIME_REMINDER>") {
            Add-Failure "UserPromptSubmit encoded hook output is missing SUPERPOWERS_RUNTIME_REMINDER wrapper"
        }
        if ($output -notmatch "verification-before-completion") {
            Add-Failure "UserPromptSubmit encoded hook output does not remind about completion verification"
        }
        if ($output.Length -gt 2000) {
            Add-Failure "UserPromptSubmit encoded hook output is too large ($($output.Length) chars); keep per-turn context compact"
        }
    }
    catch {
        Add-Failure "UserPromptSubmit encoded hook smoke test failed: $($_.Exception.Message)"
    }
}

if ($guardCommand) {
    try {
        $allowInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"git status --short"}}'
        $allowOutput = (Invoke-HookCommand $guardCommand $allowInput).Stdout
        $allowJson = $allowOutput | ConvertFrom-Json
        if ($allowJson.hookSpecificOutput.permissionDecision -ne "allow") {
            Add-Failure "PreToolUse encoded hook did not allow a benign RunCommand payload"
        }

        $denyInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"powershell -File ./.trae/INSTALL.md"}}'
        $denyOutput = (Invoke-HookCommand $guardCommand $denyInput).Stdout
        $denyJson = $denyOutput | ConvertFrom-Json
        if ($denyJson.hookSpecificOutput.permissionDecision -ne "deny") {
            Add-Failure "PreToolUse encoded hook did not deny executing Markdown as a script"
        }

        $askInput = '{"hook_event_name":"PreToolUse","tool_name":"RunCommand","tool_input":{"command":"git reset --hard"}}'
        $askOutput = (Invoke-HookCommand $guardCommand $askInput).Stdout
        $askJson = $askOutput | ConvertFrom-Json
        if ($askJson.hookSpecificOutput.permissionDecision -ne "ask") {
            Add-Failure "PreToolUse encoded hook did not ask before destructive git cleanup"
        }
    }
    catch {
        Add-Failure "PreToolUse encoded hook smoke test failed: $($_.Exception.Message)"
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
Write-Output "Checked rules, 3 self-contained Trae hooks, hook smoke output, memory payload, $($requiredSkills.Count) skills, and $($requiredSkillScripts.Count) upstream support scripts."
