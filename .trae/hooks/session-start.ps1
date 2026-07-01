# SessionStart hook for Superpowers for Trae.
# Emits Trae hook JSON with additionalContext for model context injection.

$ErrorActionPreference = "Stop"

function Write-AdditionalContext {
    param([string]$Context)

    @{
        continue = $true
        suppressOutput = $true
        hookSpecificOutput = @{
            hookEventName = "SessionStart"
            additionalContext = $Context
        }
    } | ConvertTo-Json -Depth 5 -Compress
}

$scriptPath = $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($scriptPath)) {
    $current = (Get-Location).Path
    $traeRoot = $null
    while ($current) {
        $candidate = Join-Path $current ".trae"
        $candidateSkill = Join-Path $candidate "skills/using-superpowers/SKILL.md"
        if (Test-Path -LiteralPath $candidateSkill) {
            $traeRoot = $candidate
            break
        }

        $parent = Split-Path -Parent $current
        if ($parent -eq $current) {
            break
        }
        $current = $parent
    }

    if (-not $traeRoot) {
        $traeRoot = Join-Path (Get-Location).Path ".trae"
    }
}
else {
    $scriptDir = Split-Path -Parent $scriptPath
    $traeRoot = Split-Path -Parent $scriptDir
}
$skillPath = Join-Path $traeRoot "skills/using-superpowers/SKILL.md"

foreach ($envFile in @($env:TRAE_ENV_FILE, $env:CLAUDE_ENV_FILE)) {
    if ($envFile) {
        try {
            Add-Content -LiteralPath $envFile -Value "SUPERPOWERS_TRAE=1" -Encoding UTF8
            Add-Content -LiteralPath $envFile -Value "SUPERPOWERS_TRAE_ROOT=$traeRoot" -Encoding UTF8
        }
        catch {
            # Context injection still works if the environment file is unavailable.
        }
    }
}

if (-not (Test-Path -LiteralPath $skillPath)) {
    $context = @"
<EXTREMELY_IMPORTANT>
Superpowers for Trae is installed, but the runtime bootstrap could not find:
$skillPath

Before acting, inspect .trae/skills and repair the installation. Do not claim Superpowers is active until the using-superpowers skill is present.
</EXTREMELY_IMPORTANT>
"@
    Write-AdditionalContext $context
    exit 0
}

$usingSuperpowers = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8

$context = @"
<EXTREMELY_IMPORTANT>
You have Superpowers for Trae.

This project provides runtime skills in .trae/skills and mandatory workflow rules in .trae/rules. Trae may auto-load matching skills as context. Before responding or acting, follow the full content of the using-superpowers skill below. If a required skill was not auto-loaded, open or read .trae/skills/<skill>/SKILL.md before acting.

$usingSuperpowers
</EXTREMELY_IMPORTANT>
"@

Write-AdditionalContext $context
