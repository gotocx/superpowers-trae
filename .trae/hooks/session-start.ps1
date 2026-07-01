# SessionStart hook for Superpowers for Trae.
# TRAE treats stdout from SessionStart as additional model context.

$ErrorActionPreference = "Stop"

$scriptPath = $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($scriptPath)) {
    $traeRoot = Join-Path (Get-Location).Path ".trae"
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
    Write-Output @"
<EXTREMELY_IMPORTANT>
Superpowers for Trae is installed, but the runtime bootstrap could not find:
$skillPath

Before acting, inspect .trae/skills and repair the installation. Do not claim Superpowers is active until the using-superpowers skill is present.
</EXTREMELY_IMPORTANT>
"@
    exit 0
}

$usingSuperpowers = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8

Write-Output @"
<EXTREMELY_IMPORTANT>
You have Superpowers for Trae.

This project provides runtime skills in .trae/skills and mandatory workflow rules in .trae/rules. Before responding or acting, follow the full content of the using-superpowers skill below. For every matching workflow, invoke Trae native Skill(name="<skill>") before acting.

$usingSuperpowers
</EXTREMELY_IMPORTANT>
"@
