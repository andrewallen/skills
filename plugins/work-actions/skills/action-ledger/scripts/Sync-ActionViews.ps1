#Requires -Version 7.2
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$TargetPath,
    [Parameter(Mandatory)][string]$Repository,
    [switch]$Apply,
    [ValidateRange(0, 2147483647)][int]$IssueNumber = 0,
    [DateTimeOffset]$Now = [DateTimeOffset]::UtcNow
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'WorkActions.psm1') -Force
$config = Get-ActionConfiguration -TargetPath $TargetPath -Repository $Repository
$managed = Get-ManagedActionLabels $config
$base = "repos/$($config.repository)/issues"
$numbers = [Collections.Generic.List[int]]::new()
if ($IssueNumber -gt 0) {
    $numbers.Add($IssueNumber)
} else {
    $pages = Invoke-WorkActionsGh -Arguments @('api', "${base}?state=all&per_page=100", '--paginate', '--slurp')
    foreach ($page in $pages) {
        foreach ($issue in $page) {
            if ($issue.ContainsKey('pull_request')) { continue }
            $labels = Get-IssueLabelNames $issue
            if ($issue.state -eq 'open' -or @($labels | Where-Object { $_ -in $managed }).Count -gt 0) {
                $numbers.Add($issue.number)
            }
        }
    }
}

$changed = 0
$invalid = [Collections.Generic.List[int]]::new()
foreach ($number in $numbers) {
    $path = "$base/$number"
    $issue = Invoke-WorkActionsGh -Arguments @('api', $path)
    if ($issue.ContainsKey('pull_request')) { continue }
    $result = Get-ActionViewResult -Issue $issue -Configuration $config -Now $Now
    $labels = Get-IssueLabelNames $issue
    $delta = Get-ActionLabelDelta -CurrentLabels $labels -DesiredLabels $result.Labels -ManagedLabels $managed
    if ($result.Errors.Count -gt 0) {
        $invalid.Add($number)
        Write-Warning "Issue #${number}: $($result.Errors -join ' ')"
    }
    Write-Host "#${number}: add [$($delta.Add -join ', ')]; remove [$($delta.Remove -join ', ')]"
    if (-not $Apply -or ($delta.Add.Count -eq 0 -and $delta.Remove.Count -eq 0 -and $result.Errors.Count -eq 0)) { continue }

    $fingerprint = Get-ActionSourceFingerprint -Issue $issue -ManagedLabels $managed
    $fresh = Invoke-WorkActionsGh -Arguments @('api', $path)
    if ((Get-ActionSourceFingerprint -Issue $fresh -ManagedLabels $managed) -ne $fingerprint) {
        throw "Issue #$number changed before reconciliation. No changes were applied to this issue; rerun."
    }

    foreach ($label in $delta.Remove) {
        $encoded = [Uri]::EscapeDataString($label)
        $null = Invoke-WorkActionsGh -Arguments @('api', "$path/labels/$encoded", '--method', 'DELETE')
    }
    if ($delta.Add.Count -gt 0) {
        $null = Invoke-WorkActionsGh -Arguments @('api', "$path/labels", '--method', 'POST', '--input', '-') -InputObject @{ labels = @($delta.Add) }
    }

    if ($result.Errors.Count -gt 0) {
        $marker = '<!-- work-actions:validation -->'
        $report = @(
            $marker
            '### Action metadata needs attention'
            ''
            ($result.Errors | ForEach-Object { "- $_" })
            ''
            "Follow this ledger repository's approved operating instructions to correct the source fields or labels."
            'The next refresh will remove the validation flag. No horizon, date, or execution state has been changed.'
        ) -join "`n"
        $lastReport = $null
        if ($labels -contains $config.validationLabel) {
            $commentPages = Invoke-WorkActionsGh -Arguments @('api', "$path/comments?per_page=100", '--paginate', '--slurp')
            $reports = @(
                foreach ($page in $commentPages) {
                    foreach ($comment in $page) {
                        if ([string]$comment['body'] -like "$marker*") { $comment }
                    }
                }
            )
            if ($reports.Count -gt 0) { $lastReport = ($reports | Sort-Object created_at | Select-Object -Last 1).body }
        }
        if ($lastReport -cne $report) {
            $null = Invoke-WorkActionsGh -Arguments @('api', "$path/comments", '--method', 'POST', '--input', '-') -InputObject @{ body = $report }
        }
    }

    $after = Invoke-WorkActionsGh -Arguments @('api', $path)
    if ((Get-ActionSourceFingerprint -Issue $after -ManagedLabels $managed) -ne $fingerprint) {
        throw "Issue #$number changed during reconciliation. Only derived metadata was written; rerun to refresh the views."
    }
    $changed++
}

$mode = if ($Apply) { 'Applied' } else { 'Preview only; use -Apply to write' }
$summary = "$mode. Inspected $($numbers.Count) issues; reconciled $changed; invalid metadata on $($invalid.Count)."
Write-Host $summary
if ($env:GITHUB_STEP_SUMMARY) {
    $lines = @('## Action view refresh', '', $summary)
    if ($invalid.Count -gt 0) { $lines += "Needs attention: $(($invalid | ForEach-Object { "#$_" }) -join ', ')." }
    Add-Content -LiteralPath $env:GITHUB_STEP_SUMMARY -Value ($lines -join "`n") -Encoding utf8
}
