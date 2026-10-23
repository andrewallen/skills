#Requires -Version 7.2
# Isolated execution checks for the optional local migration helper. All targets
# are synthetic temporary directories outside the copied plugin package.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path $PSScriptRoot -Parent
$sourcePackage = Join-Path $root 'plugins' 'work-context'
$scratch = Join-Path ([IO.Path]::GetTempPath()) "workspace-migration-$([Guid]::NewGuid().ToString('N'))"
$null = New-Item -ItemType Directory -Path $scratch
$script:assertions = 0

function Assert-True {
    param([bool]$Condition, [string]$Message)
    $script:assertions++
    if (-not $Condition) { throw $Message }
}

function Assert-Throws {
    param([scriptblock]$Action, [string]$MessageFragment)
    $caught = $null
    try { $null = & $Action } catch { $caught = $_ }
    Assert-True ($null -ne $caught) "Expected an error containing '$MessageFragment'."
    Assert-True ($caught.Exception.Message.Contains($MessageFragment)) "Unexpected error: $($caught.Exception.Message)"
}

function New-MigrationFixture {
    param([Parameter(Mandatory)][string]$Name)
    $case = Join-Path $scratch $Name
    $target = Join-Path $case 'workspace'
    foreach ($rootName in @(
        '00 Start Here', '10 Issued Outputs', '20 Working', '30 Sources',
        '40 Meetings', '50 Stakeholders', '99 Archive'
    )) {
        $null = New-Item -ItemType Directory -Path (Join-Path $target $rootName) -Force
    }
    $drafts = Join-Path $target 'Drafts'
    $null = New-Item -ItemType Directory -Path $drafts -Force
    $source = Join-Path $drafts 'Options.md'
    [IO.File]::WriteAllText($source, "Synthetic source for $Name`n")
    $item = Get-Item -LiteralPath $source
    $operation = @{
        source = 'Drafts\Options.md'
        destination = '20 Working\Options.md'
        sha256 = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
        lastWriteTimeUtc = $item.LastWriteTimeUtc.ToString('o')
    }
    $plan = @{
        schema = 'workspace-migration@1.0'
        targetRoot = [IO.Path]::GetFullPath($target)
        operations = @($operation)
        unresolved = @()
        retiredRoots = @()
    }
    $planPath = Join-Path $case 'approved-plan.json'
    [IO.File]::WriteAllText($planPath, ($plan | ConvertTo-Json -Depth 10), [Text.UTF8Encoding]::new($false))
    return [pscustomobject]@{
        Case = $case
        Target = $target
        Source = $source
        Destination = Join-Path $target '20 Working' 'Options.md'
        Plan = $planPath
        Hash = (Get-FileHash -LiteralPath $planPath -Algorithm SHA256).Hash
        ContentHash = $operation.sha256
    }
}

try {
    $installed = Join-Path $scratch 'installed' 'plugins' 'work-context'
    $null = New-Item -ItemType Directory -Path (Split-Path $installed -Parent) -Force
    Copy-Item -LiteralPath $sourcePackage -Destination $installed -Recurse
    $helper = Join-Path $installed 'skills' 'workspace-governance' 'scripts' 'Invoke-WorkspaceMigration.ps1'

    $happy = New-MigrationFixture 'preview-apply-resume'
    $preview = @(& $helper -TargetPath $happy.Target -PlanPath $happy.Plan)
    Assert-True (($preview -join "`n") -match 'Preview only: 1 file operations; no writes\.') 'Preview describes the planned move'
    Assert-True ((Test-Path -LiteralPath $happy.Source) -and -not (Test-Path -LiteralPath $happy.Destination)) 'Preview leaves source and destination unchanged'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $happy.Target 'Governance'))) 'Preview creates no journal or governance directory'

    $null = & $helper -TargetPath $happy.Target -PlanPath $happy.Plan -Apply -ApprovedPlanHash $happy.Hash
    Assert-True ((-not (Test-Path -LiteralPath $happy.Source)) -and (Test-Path -LiteralPath $happy.Destination)) 'Apply moves the exact source to its approved destination'
    Assert-True ((Get-FileHash -LiteralPath $happy.Destination -Algorithm SHA256).Hash -ceq $happy.ContentHash) 'Apply preserves the source content'
    $journalFiles = @(Get-ChildItem -LiteralPath (Join-Path $happy.Target 'Governance' 'Migration') -Filter '*.json' -File)
    Assert-True ($journalFiles.Count -eq 1) 'Apply writes one plan-bound progress journal'
    $journalPath = $journalFiles[0].FullName
    $null = & $helper -TargetPath $happy.Target -PlanPath $happy.Plan -Apply -ApprovedPlanHash $happy.Hash
    Assert-True ((Get-Content -LiteralPath $journalPath -Raw | ConvertFrom-Json -AsHashtable).entries['0'] -ceq 'completed') 'A repeated apply resumes idempotently from the completed journal'

    $badHash = New-MigrationFixture 'wrong-plan-digest'
    Assert-Throws {
        & $helper -TargetPath $badHash.Target -PlanPath $badHash.Plan -Apply -ApprovedPlanHash ('0' * 64)
    } 'approval of the exact plan SHA-256'
    Assert-True (Test-Path -LiteralPath $badHash.Source) 'A plan-digest mismatch makes no move'

    $existing = New-MigrationFixture 'existing-destination'
    $null = New-Item -ItemType Directory -Path (Split-Path $existing.Destination -Parent) -Force
    [IO.File]::WriteAllText($existing.Destination, 'Pre-existing destination')
    Assert-Throws {
        & $helper -TargetPath $existing.Target -PlanPath $existing.Plan -Apply -ApprovedPlanHash $existing.Hash
    } 'Destination exists'
    Assert-True (Test-Path -LiteralPath $existing.Source) 'An existing destination is not overwritten'

    $changed = New-MigrationFixture 'changed-source'
    [IO.File]::AppendAllText($changed.Source, 'Changed after approval')
    Assert-Throws {
        & $helper -TargetPath $changed.Target -PlanPath $changed.Plan -Apply -ApprovedPlanHash $changed.Hash
    } 'Content drift'
    Assert-True (Test-Path -LiteralPath $changed.Source) 'A changed source is not moved'

    $timestamp = New-MigrationFixture 'timestamp-drift'
    $originalTime = (Get-Item -LiteralPath $timestamp.Source).LastWriteTimeUtc
    (Get-Item -LiteralPath $timestamp.Source).LastWriteTimeUtc = $originalTime.AddSeconds(1)
    Assert-Throws {
        & $helper -TargetPath $timestamp.Target -PlanPath $timestamp.Plan -Apply -ApprovedPlanHash $timestamp.Hash
    } 'Modification-time drift'
    Assert-True (Test-Path -LiteralPath $timestamp.Source) 'A timestamp mismatch is a safe refusal'

    $linked = New-MigrationFixture 'reparse-point'
    $outside = Join-Path $linked.Case 'outside'
    $null = New-Item -ItemType Directory -Path $outside
    [IO.File]::WriteAllText((Join-Path $outside 'Options.md'), 'Outside target')
    $junction = Join-Path $linked.Target 'Drafts' 'linked'
    $null = New-Item -ItemType Junction -Path $junction -Target $outside
    $linkedPlan = ConvertFrom-Json -InputObject (Get-Content -LiteralPath $linked.Plan -Raw) -AsHashtable
    $linkedPlan.operations[0].source = 'Drafts\linked\Options.md'
    [IO.File]::WriteAllText($linked.Plan, ($linkedPlan | ConvertTo-Json -Depth 10), [Text.UTF8Encoding]::new($false))
    $linked.Hash = (Get-FileHash -LiteralPath $linked.Plan -Algorithm SHA256).Hash
    Assert-Throws {
        & $helper -TargetPath $linked.Target -PlanPath $linked.Plan -Apply -ApprovedPlanHash $linked.Hash
    } 'Unsupported by this optional helper'
    Assert-True (Test-Path -LiteralPath (Join-Path $outside 'Options.md')) 'The helper does not move through a reparse point'

    Write-Host "PASS: $script:assertions assertions; isolated workspace migration helper."
} finally {
    Remove-Item -LiteralPath $scratch -Recurse -Force
}
