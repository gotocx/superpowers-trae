# PreToolUse guard for Trae RunCommand.
# Reads Trae hook JSON from stdin and denies common Superpowers install mistakes.

$ErrorActionPreference = "Stop"

function Write-Decision {
    param(
        [string]$Decision,
        [string]$Reason
    )

    $payload = @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = $Decision
            permissionDecisionReason = $Reason
        }
    }

    $payload | ConvertTo-Json -Depth 5 -Compress
}

$stdinText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($stdinText)) {
    Write-Decision "allow" "No RunCommand payload received."
    exit 0
}

try {
    $payload = $stdinText | ConvertFrom-Json
}
catch {
    Write-Decision "allow" "RunCommand payload was not JSON; no Superpowers guard decision."
    exit 0
}

$command = ""
if ($payload.tool_input -and $payload.tool_input.command) {
    $command = [string]$payload.tool_input.command
}
elseif ($payload.tool_input -and $payload.tool_input.commands) {
    $command = ($payload.tool_input.commands -join " ")
}

if ([string]::IsNullOrWhiteSpace($command)) {
    Write-Decision "allow" "No shell command found in RunCommand payload."
    exit 0
}

$checks = @(
    @{
        Pattern = '(?i)(^|[\s;&|])(?:bash|sh|zsh|pwsh|powershell(?:\.exe)?|cmd(?:\.exe)?\s*/c|python(?:3)?|node)\b[^\r\n;&|]*["'']?(?:\.?[/\\])?(?:\.trae[/\\])?(?:README|NOTICE|LICENSE|INSTALL)\.md["'']?'
        Decision = 'deny'
        Reason = 'Markdown documents are instructions, not executable scripts. Read them or copy their instructions explicitly instead.'
    },
    @{
        Pattern = '(?i)(^|[\s;&|])(?:rm\s+-[^\r\n;&|]*r[^\r\n;&|]*|rmdir\s+(?:/s|/q|/s\s+/q|/q\s+/s)|Remove-Item\b[^\r\n;&|]*-Recurse[^\r\n;&|]*|del\s+(?:/s|/q|/s\s+/q|/q\s+/s))\s+["'']?\.?[/\\]?\.trae(?:["''\s;&|]|$)'
        Decision = 'deny'
        Reason = 'Refusing to recursively delete the active .trae runtime. Disable this hook only if the user explicitly asks to remove Superpowers.'
    },
    @{
        Pattern = '(?i)(^|[\s;&|])(?:rm|del|erase|Remove-Item|rmdir)\b[^\r\n;&|]*["'']?\.?[/\\]?\.trae[/\\]hooks(?:\.json|[/\\]?|\*)["'']?(?:[\s;&|]|$)'
        Decision = 'deny'
        Reason = 'hooks.json and .trae/hooks/ are runtime hook files and must survive installation.'
    },
    @{
        Pattern = '(?i)(^|[\s;&|])git\s+(?:reset\s+--hard|clean\s+-[^\r\n;&|]*x)'
        Decision = 'ask'
        Reason = 'Destructive git cleanup can delete Superpowers progress/runtime files. Get explicit user approval and run a narrower command.'
    }
)

foreach ($check in $checks) {
    if ($command -match $check.Pattern) {
        Write-Decision $check.Decision $check.Reason
        exit 0
    }
}

Write-Decision "allow" "RunCommand passed Superpowers guard checks."
