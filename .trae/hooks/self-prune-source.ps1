param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,

    [Parameter(Mandatory = $true)]
    [string]$TargetRoot,

    [Parameter(Mandatory = $true)]
    [string]$TargetTraePath,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Normalize-PathString {
    param([string]$Path)

    return ([System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/'))
}

function Test-SamePath {
    param(
        [string]$Left,
        [string]$Right
    )

    return [string]::Equals(
        (Normalize-PathString $Left),
        (Normalize-PathString $Right),
        [System.StringComparison]::OrdinalIgnoreCase
    )
}

function Test-IsInsidePath {
    param(
        [string]$Child,
        [string]$Parent
    )

    $childPath = Normalize-PathString $Child
    $parentPath = Normalize-PathString $Parent
    if (Test-SamePath $childPath $parentPath) {
        return $false
    }

    return $childPath.StartsWith(
        ($parentPath + [System.IO.Path]::DirectorySeparatorChar),
        [System.StringComparison]::OrdinalIgnoreCase
    )
}

function Resolve-ExistingPath {
    param(
        [string]$Path,
        [string]$Name
    )

    try {
        return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
    }
    catch {
        throw "$Name does not exist: $Path"
    }
}

function Assert-Condition {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Assert-BootstrapSourceShape {
    param([string]$Path)

    $allowedChildren = @(
        ".git",
        ".trae",
        "README.md",
        "INSTALL.md",
        "UPSTREAM.md",
        "LICENSE",
        "NOTICE.md",
        ".gitignore"
    )

    foreach ($child in Get-ChildItem -LiteralPath $Path -Force) {
        if ($allowedChildren -notcontains $child.Name) {
            throw "SourceRoot is not a minimal Superpowers bootstrap clone. Unexpected child: $($child.Name)"
        }
    }

    foreach ($requiredFile in @("README.md", "INSTALL.md", "UPSTREAM.md", "LICENSE", "NOTICE.md")) {
        $requiredPath = Join-Path $Path $requiredFile
        Assert-Condition (Test-Path -LiteralPath $requiredPath -PathType Leaf) "SourceRoot is missing bootstrap file: $requiredFile"
    }

    $sourceTrae = Join-Path $Path ".trae"
    if (Test-Path -LiteralPath $sourceTrae) {
        foreach ($requiredRuntime in @("hooks.json", "hooks", "agents", "rules", "skills")) {
            $requiredRuntimePath = Join-Path $sourceTrae $requiredRuntime
            Assert-Condition (Test-Path -LiteralPath $requiredRuntimePath) "SourceRoot .trae is missing runtime entry: $requiredRuntime"
        }
    }
}

function Invoke-TargetValidation {
    param(
        [string]$ResolvedTargetRoot,
        [string]$ResolvedTargetTraePath
    )

    $validator = Join-Path $ResolvedTargetTraePath "hooks/validate-package.ps1"
    Assert-Condition (Test-Path -LiteralPath $validator -PathType Leaf) "Target runtime is missing validator: $validator"

    Push-Location $ResolvedTargetRoot
    try {
        & $validator -RepoRoot $ResolvedTargetRoot -SkipSelfPruneSmoke
    }
    finally {
        Pop-Location
    }
}

try {
    $targetRootResolved = Resolve-ExistingPath $TargetRoot "TargetRoot"
    $targetTraeResolved = Resolve-ExistingPath $TargetTraePath "TargetTraePath"
    $expectedTargetTrae = Join-Path $targetRootResolved ".trae"

    Assert-Condition (Test-SamePath $targetTraeResolved $expectedTargetTrae) "TargetTraePath must be exactly TargetRoot/.trae."

    Invoke-TargetValidation $targetRootResolved $targetTraeResolved

    if (-not (Test-Path -LiteralPath $SourceRoot)) {
        Write-Output "SourceRoot is already absent after target runtime validation: $SourceRoot"
        exit 0
    }

    $sourceResolved = Resolve-ExistingPath $SourceRoot "SourceRoot"

    Assert-Condition (-not (Test-SamePath $sourceResolved $targetRootResolved)) "SourceRoot must not be TargetRoot."
    Assert-Condition (-not (Test-SamePath $sourceResolved $targetTraeResolved)) "SourceRoot must not be TargetTraePath."
    Assert-Condition (Test-IsInsidePath $sourceResolved $targetRootResolved) "SourceRoot must be a child of TargetRoot."
    Assert-Condition (-not (Test-IsInsidePath $sourceResolved $targetTraeResolved)) "SourceRoot must not be inside TargetTraePath."
    Assert-Condition (-not (Test-IsInsidePath $targetTraeResolved $sourceResolved)) "TargetTraePath must not be inside SourceRoot."

    Assert-BootstrapSourceShape $sourceResolved

    if ($DryRun) {
        Write-Output "Self-prune boundary checks passed. Dry run only; would remove SourceRoot: $sourceResolved"
        exit 0
    }

    try {
        Remove-Item -LiteralPath $sourceResolved -Recurse -Force -ErrorAction Stop
    }
    catch {
        Write-Output "SourceRoot removal failed: $sourceResolved"
        Write-Output $_.Exception.Message
        Write-Output "Target .trae is already validated. Close the locking process or restart Trae, then delete only this leftover SourceRoot manually."
        exit 2
    }

    if (Test-Path -LiteralPath $sourceResolved) {
        Write-Output "SourceRoot removal did not complete: $sourceResolved"
        Write-Output "Target .trae is already validated. Delete only this leftover SourceRoot manually."
        exit 2
    }

    Write-Output "Removed bootstrap SourceRoot after validated install: $sourceResolved"
    exit 0
}
catch {
    Write-Error "Self-prune refused: $($_.Exception.Message)"
    exit 1
}
