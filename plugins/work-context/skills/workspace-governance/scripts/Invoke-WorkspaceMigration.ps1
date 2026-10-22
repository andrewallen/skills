#Requires -Version 7.2
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string] $TargetPath,
    [Parameter(Mandatory)][string] $PlanPath,
    [switch] $Apply,
    [string] $ApprovedPlanHash
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function FullPath([string] $Path) {
    if (-not [IO.Path]::IsPathFullyQualified($Path)) { throw "Absolute path required: $Path" }
    return [IO.Path]::TrimEndingDirectorySeparator([IO.Path]::GetFullPath($Path))
}

function IsWithin([string] $Path, [string] $Parent) {
    return $Path.Equals($Parent, [StringComparison]::OrdinalIgnoreCase) -or
        $Path.StartsWith($Parent + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)
}

function AssertLocal([string] $Path) {
    $current = $Path
    while ($current) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            # Reparse, offline, recall-on-open and recall-on-data-access.
            if (([long] $item.Attributes -band 0x00441400) -ne 0) {
                throw "Unsupported by this optional helper: $current. Use the migration guidance to select a supported filesystem or provider operation; do not bypass path protections or use GUI automation."
            }
        }
        $current = Split-Path -Path $current -Parent
    }
}

$root = FullPath $TargetPath
if ($root -eq [IO.Path]::GetPathRoot($root) -or $root.StartsWith('\\')) {
    throw 'A bounded local project directory is required, not a volume or network root.'
}
AssertLocal $root
if (-not (Test-Path -LiteralPath $root -PathType Container)) { throw 'Target directory does not exist.' }
$package = FullPath (Join-Path $PSScriptRoot '..\..\..')
if ((IsWithin $root $package) -or (IsWithin $package $root)) {
    throw 'The plugin package or its parent is not a migration target.'
}
if (Test-Path -LiteralPath (Join-Path $root '.git')) {
    throw 'Select an approved project-context directory, not a repository root.'
}

function RelativePath([string] $Path) {
    if (-not $Path -or [IO.Path]::IsPathRooted($Path) -or $Path -match '[:*?"<>|]') {
        throw "Invalid relative path: $Path"
    }
    $parts = $Path -split '[\\/]'
    if (@($parts | Where-Object { $_ -in @('', '.', '..', '.git', '.venv', 'node_modules', '.copilot') -or $_ -match '[. ]$' }).Count) {
        throw "Traversal or protected path: $Path"
    }
    $resolved = FullPath (Join-Path $root $Path)
    if (-not (IsWithin $resolved $root) -or $resolved -eq $root) { throw "Path escapes target: $Path" }
    AssertLocal $resolved
    $parent = Split-Path $resolved -Parent
    while ($parent -and (IsWithin $parent $root)) {
        if (Test-Path -LiteralPath (Join-Path $parent '.git')) { throw "Nested repository: $Path" }
        $parent = Split-Path $parent -Parent
    }
    return $resolved
}

$planFile = FullPath $PlanPath
AssertLocal $planFile
$planBytes = [IO.File]::ReadAllBytes($planFile)
$planHash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($planBytes))
$plan = [Text.Encoding]::UTF8.GetString($planBytes).TrimStart([char] 0xFEFF) | ConvertFrom-Json -AsHashtable
foreach ($key in 'schema', 'targetRoot', 'operations', 'unresolved', 'retiredRoots') {
    if (-not $plan.ContainsKey($key)) { throw "Missing plan field: $key" }
}
if ($plan.schema -cne 'workspace-migration@1.0' -or (FullPath $plan.targetRoot) -cne $root) {
    throw 'Plan schema or exact target does not match.'
}
foreach ($key in 'operations', 'unresolved', 'retiredRoots') {
    if ($plan[$key] -isnot [array]) { throw "Expected array: $key" }
}
if ($Apply -and $ApprovedPlanHash -ine $planHash) { throw 'Apply requires approval of the exact plan SHA-256.' }

$journalPath = RelativePath "Governance\Migration\$planHash.json"
$state = @{
    schema = 'workspace-migration-progress@1.0'
    planHash = $planHash
    targetRoot = $root
    entries = @{}
}
if (Test-Path -LiteralPath $journalPath) {
    $state = Get-Content -LiteralPath $journalPath -Raw | ConvertFrom-Json -AsHashtable
    if ($state.schema -cne 'workspace-migration-progress@1.0' -or
        $state.planHash -cne $planHash -or $state.targetRoot -cne $root -or
        $state.entries -isnot [System.Collections.IDictionary]) { throw 'Journal identity does not match.' }
}

function SaveProgress {
    AssertLocal $journalPath
    $directory = Split-Path $journalPath -Parent
    [void] [IO.Directory]::CreateDirectory($directory)
    $temporary = Join-Path $directory ([guid]::NewGuid().ToString() + '.tmp')
    try {
        [IO.File]::WriteAllText($temporary, ($state | ConvertTo-Json -Depth 10))
        [IO.File]::Move($temporary, $journalPath, $true)
    } finally {
        if (Test-Path -LiteralPath $temporary) { [IO.File]::Delete($temporary) }
    }
}

function AssertFingerprint([string] $Path, $Operation) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing file: $Path" }
    if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ine $Operation.sha256) {
        throw "Content drift: $Path"
    }
    $expected = [DateTimeOffset]::Parse($Operation.lastWriteTimeUtc).UtcDateTime
    if ((Get-Item -LiteralPath $Path).LastWriteTimeUtc.Ticks -ne $expected.Ticks) {
        throw "Modification-time drift: $Path"
    }
}

$sources = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$destinations = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$operations = @()
foreach ($operation in $plan.operations) {
    foreach ($key in 'source', 'destination', 'sha256', 'lastWriteTimeUtc') {
        if (-not $operation.ContainsKey($key) -or $operation[$key] -isnot [string]) { throw "Invalid operation field: $key" }
    }
    if ($operation.sha256 -notmatch '^[0-9a-fA-F]{64}$' -or $operation.lastWriteTimeUtc -notmatch 'Z$') {
        throw 'An observed SHA-256 and UTC timestamp are required.'
    }
    $source = RelativePath $operation.source
    $destination = RelativePath $operation.destination
    $first = ($operation.destination -split '[\\/]')[0]
    if ($first -notin @('00 Start Here', '10 Issued Outputs', '20 Working', '30 Sources', '40 Meetings', '50 Stakeholders', '99 Archive')) {
        throw 'Move destinations must use a core root.'
    }
    if ((Split-Path $source -Leaf) -in @('AGENTS.md', 'GOVERNANCE.md') -or
        (IsWithin $planFile $source) -or $source -eq $journalPath) { throw 'Protected control file.' }
    if (-not $sources.Add($source) -or -not $destinations.Add($destination)) { throw 'Duplicate source or destination.' }
    $operations += @{ source = $source; destination = $destination; expected = $operation }
}
foreach ($path in $sources) {
    if ($destinations.Contains($path)) { throw 'Move chains/cycles require a separately planned route.' }
}
foreach ($path in $plan.retiredRoots) { [void] (RelativePath $path) }
foreach ($gap in $plan.unresolved) { if ($gap -isnot [string]) { throw 'Unresolved entries must be strings.' } }

# Preflight the entire independent batch before the first write.
for ($i = 0; $i -lt $operations.Count; $i++) {
    $op = $operations[$i]
    $entry = $state.entries[[string] $i]
    if ($entry -and $entry -notin @('prepared', 'completed')) { throw 'Invalid progress state.' }
    if ($entry -and -not (Test-Path -LiteralPath $op.source)) {
        AssertFingerprint $op.destination $op.expected
    } else {
        if ($entry -eq 'completed') { throw 'A completed source has reappeared.' }
        AssertFingerprint $op.source $op.expected
        if (Test-Path -LiteralPath $op.destination) { throw "Destination exists: $($op.destination)" }
    }
}
Write-Output "Plan SHA-256: $planHash"
if (-not $Apply) {
    Write-Output "Preview only: $($operations.Count) file operations; no writes."
    return
}
for ($i = 0; $i -lt $operations.Count; $i++) {
    $op = $operations[$i]
    AssertLocal $op.source
    AssertLocal $op.destination
    if (-not (Test-Path -LiteralPath $op.source)) {
        if ($state.entries[[string] $i] -notin @('prepared', 'completed')) {
            throw 'Source disappeared without recorded preparation.'
        }
        AssertFingerprint $op.destination $op.expected
    } else {
        AssertFingerprint $op.source $op.expected
        if (Test-Path -LiteralPath $op.destination) { throw 'Destination appeared after preflight.' }
        $state.entries[[string] $i] = 'prepared'
        SaveProgress
        [void] [IO.Directory]::CreateDirectory((Split-Path $op.destination -Parent))
        [IO.File]::Move($op.source, $op.destination)
        AssertFingerprint $op.destination $op.expected
    }
    $state.entries[[string] $i] = 'completed'
    SaveProgress
}
$gaps = @($plan.unresolved)
foreach ($path in $plan.retiredRoots) {
    if (Test-Path -LiteralPath (RelativePath $path)) { $gaps += "Retired path remains: $path" }
}
foreach ($name in @('00 Start Here', '10 Issued Outputs', '20 Working', '30 Sources', '40 Meetings', '50 Stakeholders', '99 Archive')) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $name) -PathType Container)) { $gaps += "Missing core: $name" }
}
if ($gaps.Count) { throw "Local moves verified; migration remains partial: $($gaps -join '; ')" }
Write-Output 'Local batch verified. Coordinator must separately verify inventory, references and full conformity.'
