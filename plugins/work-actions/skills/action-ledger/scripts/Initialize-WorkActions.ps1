#Requires -Version 7.2
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$TargetPath,
    [Parameter(Mandatory)][string]$Repository,
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'WorkActions.psm1') -Force
$config = Get-ActionConfiguration -TargetPath $TargetPath -Repository $Repository
$definitions = Get-Content -LiteralPath (Join-Path $TargetPath '.github' 'labels.json') -Raw |
    ConvertFrom-Json -AsHashtable
$pages = Invoke-WorkActionsGh -Arguments @('api', "repos/$($config.repository)/labels?per_page=100", '--paginate', '--slurp')
$existing = @{}
foreach ($page in $pages) {
    foreach ($label in $page) { $existing[$label.name] = $label }
}

foreach ($label in $definitions) {
    $current = $existing[$label.name]
    if ($null -ne $current -and $current.name -ceq $label.name -and
        $current.color -eq $label.color -and $current.description -eq $label.description) { continue }

    $operation = if ($null -eq $current) { 'Create' } else { 'Update' }
    Write-Host "$operation label: $($label.name)"
    if (-not $Apply) { continue }
    if ($null -eq $current) {
        $null = Invoke-WorkActionsGh -Arguments @('api', "repos/$($config.repository)/labels", '--method', 'POST', '--input', '-') -InputObject $label
    } else {
        $name = [Uri]::EscapeDataString($current.name)
        $body = @{ new_name = $label.name; color = $label.color; description = $label.description }
        $null = Invoke-WorkActionsGh -Arguments @('api', "repos/$($config.repository)/labels/$name", '--method', 'PATCH', '--input', '-') -InputObject $body
    }
}
if (-not $Apply) { Write-Host 'Preview only. Re-run with -Apply to write these changes.' }
