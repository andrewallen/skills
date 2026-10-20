#Requires -Version 7.2
# Offline checks for the work-actions package: manifest, discovery, frontmatter,
# asset structure and copied-folder helper isolation with a faked gh. Fixtures
# under scripts/fixtures/work-actions are synthetic.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path $PSScriptRoot -Parent
$fixtures = Join-Path $PSScriptRoot 'fixtures' 'work-actions'
$package = Join-Path $root 'plugins' 'work-actions'
$skill = Join-Path $package 'skills' 'action-ledger'
$script:assertions = 0

function Assert-True {
    param([bool]$Condition, [string]$Message)
    $script:assertions++
    if (-not $Condition) { throw $Message }
}

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    Assert-True ($Expected -ceq $Actual) "$Message. Expected '$Expected'; got '$Actual'."
}

function Assert-Throws {
    param([scriptblock]$Action, [string]$MessageFragment)
    $caught = $null
    try { $null = & $Action } catch { $caught = $_ }
    Assert-True ($null -ne $caught) "Expected an error containing '$MessageFragment'."
    Assert-True ($caught.Exception.Message.Contains($MessageFragment)) "Unexpected error: $($caught.Exception.Message)"
}

$catalogue = Get-Content -LiteralPath (Join-Path $root '.github' 'plugin' 'marketplace.json') -Raw | ConvertFrom-Json -AsHashtable
$entry = @($catalogue.plugins | Where-Object { $_.name -ceq 'work-actions' })
Assert-Equal 1 $entry.Count 'work-actions is registered exactly once'
Assert-Equal './plugins/work-actions' $entry[0].source 'Source is repository-relative, not catalogue-relative'
Assert-True (-not $entry[0].ContainsKey('version')) 'The catalogue must not duplicate package versions'
$manifest = Get-Content -LiteralPath (Join-Path $package 'plugin.json') -Raw | ConvertFrom-Json -AsHashtable
Assert-Equal 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json' $manifest['$schema'] 'Portable schema identity'
Assert-Equal 'work-actions' $manifest.name 'Stable plugin name'
Assert-True ($manifest.version -match '^\d+\.\d+\.\d+$') 'Plugin needs a semantic version'
Assert-True (-not [string]::IsNullOrWhiteSpace($manifest.description)) 'Manifest description is required'
Assert-True (-not [string]::IsNullOrWhiteSpace($manifest.author.name)) 'Manifest author is required'
Assert-True ($manifest.keywords -is [array] -and $manifest.keywords.Count -gt 0) 'Manifest keywords are an array'
foreach ($key in $manifest.Keys) {
    Assert-True ($key -in @('$schema', 'name', 'version', 'description', 'author', 'keywords')) "Unexpected manifest field: $key"
}
$skills = @(Get-ChildItem -LiteralPath (Join-Path $package 'skills') -Directory)
Assert-Equal 1 $skills.Count 'Exactly one immediate discovered skill'
$skillText = Get-Content -LiteralPath (Join-Path $skill 'SKILL.md') -Raw
$frontmatter = [regex]::Match($skillText, '\A---\r?\n([\s\S]+?)\r?\n---(?:\r?\n|$)')
Assert-True $frontmatter.Success 'Skill requires leading YAML frontmatter'
$metadata = $frontmatter.Groups[1].Value
Assert-True ($metadata -match '(?m)^name: action-ledger\r?$') 'Skill name matches its discovery directory'
Assert-True ($metadata -match '(?m)^description: [^\r\n]{1,1024}\r?$') 'Skill description is a bounded scalar'
Assert-True ($metadata -match '(?m)^metadata:\r?$') 'Skill metadata mapping is required'
Assert-True ($metadata -match '(?m)^  version: "\d+\.\d+"\r?$') 'Skill version is distinct major.minor metadata'
Assert-True ($metadata -match '(?m)^  runtime-dependencies: [^\r\n]*PowerShell 7\.2\+[^\r\n]*\bgh\b') 'Helper prerequisites are declared'
Assert-True (($skillText -split '\r?\n').Count -lt 500) 'Keep the skill entry point concise'
foreach ($helper in @('Initialize-WorkActions.ps1', 'Sync-ActionViews.ps1', 'Sync-ActionProject.ps1')) {
    $command = Get-Command (Join-Path $skill 'scripts' $helper)
    foreach ($parameter in @('TargetPath', 'Repository')) {
        Assert-True (@($command.Parameters[$parameter].Attributes | Where-Object {
            $_ -is [Management.Automation.ParameterAttribute] -and $_.Mandatory
        }).Count -gt 0) "$helper must require $parameter"
    }
}
foreach ($file in Get-ChildItem -LiteralPath $package -Recurse -File -Include '*.ps1', '*.psm1') {
    $tokens = $null
    $parseErrors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
    Assert-Equal 0 $parseErrors.Count "PowerShell syntax: $($file.FullName)"
}
foreach ($file in Get-ChildItem -LiteralPath $package -Recurse -File) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    Assert-True ($text -notmatch 'PVT_|PVTV_') "No private ledger identifiers in $($file.Name)"
}

# Headings the ledger's capture templates require; the ledger repository owns its forms.
$expectedHeadings = @{
    action = 'Outcome|Next action|Done when|Due date|Review on|Waiting for|Execution boundary|References'
    project = 'Outcome|Done when|Actions|References'
}
foreach ($form in $expectedHeadings.Keys) {
    $asset = Get-Content -LiteralPath (Join-Path $skill 'assets' "$form.md") -Raw
    $actual = @([regex]::Matches($asset, '(?m)^### ([^\r\n]+)') | ForEach-Object { $_.Groups[1].Value })
    Assert-Equal $expectedHeadings[$form] ($actual -join '|') "$form asset preserves the capture headings"
}
$handoff = Get-Content -LiteralPath (Join-Path $skill 'assets' 'execution-update.md') -Raw
foreach ($field in @('Execution update', 'State:', 'Executor:', 'Run/session:', 'Verified at:', 'Result/evidence:', 'Next action:', 'Decision/blocker:', 'Authority:')) {
    Assert-True $handoff.Contains($field) "Handoff field present: $field"
}

$scratch = (New-Item -ItemType Directory -Path (Join-Path ([IO.Path]::GetTempPath()) "work-actions-plugin-$([Guid]::NewGuid().ToString('N'))")).FullName
$originalHost = $env:GH_HOST
$originalSummary = $env:GITHUB_STEP_SUMMARY
$env:GH_HOST = $null
$env:GITHUB_STEP_SUMMARY = $null
try {
    Copy-Item -LiteralPath $package -Destination (Join-Path $scratch 'installed') -Recurse
    $installed = Join-Path $scratch 'installed'
    $scripts = Join-Path $installed 'skills' 'action-ledger' 'scripts'
    $target = (New-Item -ItemType Directory -Path (Join-Path $scratch 'target ledger')).FullName
    $configurationPath = (New-Item -ItemType Directory -Path (Join-Path $target '.github')).FullName
    Copy-Item -LiteralPath (Join-Path $fixtures 'work-actions.json') -Destination (Join-Path $configurationPath 'work-actions.json')
    Copy-Item -LiteralPath (Join-Path $fixtures 'labels.json') -Destination (Join-Path $configurationPath 'labels.json')
    $before = @(Get-ChildItem -LiteralPath $installed, $target -File -Recurse | Get-FileHash | ForEach-Object { "$($_.Path):$($_.Hash)" }) -join "`n"
    $global:PluginTestBackend = @{
        Calls = [Collections.Generic.List[hashtable]]::new()
        Writes = [Collections.Generic.List[hashtable]]::new()
        Fail = $false
        PublicProject = $false
        ProjectId = 'TEST_PROJECT'
        Issue = @{
            number = 17; body = "### Due date`n2026-10-20"; state = 'open'
            labels = @(@{ name = 'kind:action' }, @{ name = '2-Next' }, @{ name = 'custom' })
            assignees = @(@{ login = 'human-owner' })
            html_url = 'https://github.com/example/ledger/issues/17'
        }
    }
    function global:gh {
        [CmdletBinding(PositionalBinding = $false)]
        param(
            [Parameter(ValueFromPipeline)][string]$Payload,
            [Parameter(ValueFromRemainingArguments)][string[]]$Arguments
        )
        begin { $lines = [Collections.Generic.List[string]]::new() }
        process { if ($null -ne $Payload) { $lines.Add($Payload) } }
        end {
            $global:LASTEXITCODE = 0
            $backend = $global:PluginTestBackend
            $body = if ($lines.Count -gt 0) { $lines -join "`n" | ConvertFrom-Json -AsHashtable } else { $null }
            $call = @{ Arguments = $Arguments; Body = $body }
            $backend.Calls.Add($call)
            if ($backend.Fail) {
                $global:LASTEXITCODE = 1
                return 'HTTP 403: isolated test permission failure'
            }
            if ($Arguments[0] -eq 'project') {
                if ($Arguments[1] -notin @('link', 'edit', 'item-add')) { throw "Unexpected Project operation: $Arguments" }
                $backend.Writes.Add($call)
                return '{}'
            }
            if ($Arguments[0] -ne 'api') { throw "Unexpected GitHub command: $Arguments" }
            $path = $Arguments[1]
            $methodIndex = [array]::IndexOf($Arguments, '--method')
            $method = if ($methodIndex -ge 0) { $Arguments[$methodIndex + 1] } else { 'GET' }
            if ($path -eq 'graphql') {
                if ($body.query.StartsWith('query')) {
                    return @{
                        data = @{
                            node = @{
                                id = $backend.ProjectId; title = 'Test ledger'; public = $backend.PublicProject
                                fields = @{ nodes = @(@{ id = 'TITLE'; name = 'Title' }, @{ id = 'LABELS'; name = 'Labels' }, @{ id = 'ASSIGNEES'; name = 'Assignees' }) }
                                views = @{ nodes = @(@{ id = 'TEST_VIEW'; name = 'All actions' }) }
                            }
                        }
                    } | ConvertTo-Json -Depth 20 -Compress
                }
                $backend.Writes.Add($call)
                if ($body.query.Contains('createProjectV2View')) {
                    return '{"data":{"createProjectV2View":{"projectV2View":{"id":"CREATED_VIEW"}}}}'
                }
                if ($body.query.Contains('updateProjectV2View')) {
                    return '{"data":{"updateProjectV2View":{"projectV2View":{"id":"UPDATED_VIEW"}}}}'
                }
                throw "Unexpected GraphQL mutation: $($body.query)"
            }
            if (-not $path.StartsWith('repos/example/ledger/')) { throw "Request escaped explicit target: $path" }
            if ($method -ne 'GET') { $backend.Writes.Add($call) }
            if ($path -match '/labels\?') { return '[[]]' }
            if ($path -eq 'repos/example/ledger/labels' -and $method -eq 'POST') { return '{}' }
            if ($path -match '/issues\?') {
                $issues = ConvertTo-Json -InputObject @($backend.Issue) -Depth 20 -Compress
                return "[$issues]"
            }
            if ($path -eq 'repos/example/ledger/issues/17' -and $method -eq 'GET') {
                return $backend.Issue | ConvertTo-Json -Depth 20 -Compress
            }
            if ($path -eq 'repos/example/ledger/issues/17/labels' -and $method -eq 'POST') {
                foreach ($label in $body.labels) { $backend.Issue.labels += @{ name = $label } }
                return '[]'
            }
            throw "Unexpected isolated API call: $method $path"
        }
    }
    Import-Module (Join-Path $scripts 'WorkActions.psm1') -Force
    $resolved = Get-ActionConfiguration -TargetPath $target -Repository 'example/ledger'
    Assert-Equal 'example/ledger' $resolved.repository 'Copied package reads only the explicitly selected target configuration'
    Assert-Throws { Get-ActionConfiguration -TargetPath '.' -Repository 'example/ledger' } 'absolute path'
    Assert-Throws { Get-ActionConfiguration -TargetPath $installed -Repository 'example/ledger' } 'installed plugin directory'
    Assert-Throws { Get-ActionConfiguration -TargetPath $scripts -Repository 'example/ledger' } 'installed plugin directory'
    Assert-Throws { Get-ActionConfiguration -TargetPath $scratch -Repository 'example/ledger' } 'does not exist'
    $env:GH_HOST = 'github.example.test'
    Assert-Throws { Get-ActionConfiguration -TargetPath $target -Repository 'example/ledger' } 'GH_HOST'
    $env:GH_HOST = $null
    foreach ($helper in @('Initialize-WorkActions.ps1', 'Sync-ActionViews.ps1', 'Sync-ActionProject.ps1')) {
        Assert-Throws { & (Join-Path $scripts $helper) -TargetPath $target -Repository 'wrong/ledger' -Apply } 'Target repository mismatch'
    }
    Assert-Equal 0 $global:PluginTestBackend.Calls.Count 'Invalid targets fail before any GitHub request'

    Push-Location $scratch
    try {
        foreach ($helper in @('Initialize-WorkActions.ps1', 'Sync-ActionViews.ps1', 'Sync-ActionProject.ps1')) {
            & (Join-Path $scripts $helper) -TargetPath $target -Repository 'example/ledger'
        }
        Assert-Equal 0 $global:PluginTestBackend.Writes.Count 'All installed entry points preview without writes from an unrelated cwd'
        $now = [DateTimeOffset]'2026-10-20T12:00:00Z'
        & (Join-Path $scripts 'Sync-ActionViews.ps1') -TargetPath $target -Repository 'example/ledger' -IssueNumber 17 -Now $now -Apply
        $labels = Get-IssueLabelNames $global:PluginTestBackend.Issue
        Assert-Equal '2-Next,custom,kind:action,view:do-now,view:plan-next' (($labels | Sort-Object) -join ',') 'Isolated refresh preserves intentional overlap and source labels'
        Assert-Equal 'human-owner' $global:PluginTestBackend.Issue.assignees[0].login 'Isolated refresh preserves human ownership'
        Assert-Equal "### Due date`n2026-10-20" $global:PluginTestBackend.Issue.body 'Isolated refresh preserves source dates'
        $writes = $global:PluginTestBackend.Writes.Count
        & (Join-Path $scripts 'Sync-ActionViews.ps1') -TargetPath $target -Repository 'example/ledger' -IssueNumber 17 -Now $now -Apply
        Assert-Equal $writes $global:PluginTestBackend.Writes.Count 'Copied helper is idempotent'
        & (Join-Path $scripts 'Initialize-WorkActions.ps1') -TargetPath $target -Repository 'example/ledger' -Apply
        Assert-True ($global:PluginTestBackend.Writes.Count -gt $writes) 'Copied label setup consumes the target definitions'
        $writes = $global:PluginTestBackend.Writes.Count
        & (Join-Path $scripts 'Sync-ActionProject.ps1') -TargetPath $target -Repository 'example/ledger' -Apply
        Assert-True ($global:PluginTestBackend.Writes.Count -gt $writes) 'Copied Project helper performs configured maintenance'
        $itemAdd = @($global:PluginTestBackend.Writes | Where-Object { $_.Arguments[0] -eq 'project' -and $_.Arguments[1] -eq 'item-add' })
        Assert-Equal 1 $itemAdd.Count 'Project helper adds the same action record once'
        Assert-True ('7' -in $itemAdd[0].Arguments -and 'example' -in $itemAdd[0].Arguments -and
            'https://github.com/example/ledger/issues/17' -in $itemAdd[0].Arguments) 'Project membership uses the target Project and issue'
        $global:PluginTestBackend.PublicProject = $true
        $writes = $global:PluginTestBackend.Writes.Count
        Assert-Throws { & (Join-Path $scripts 'Sync-ActionProject.ps1') -TargetPath $target -Repository 'example/ledger' -Apply } 'Project is public'
        Assert-Equal $writes $global:PluginTestBackend.Writes.Count 'Public Project boundary stops writes'
        $global:PluginTestBackend.PublicProject = $false
        $global:PluginTestBackend.ProjectId = 'OTHER_PROJECT'
        Assert-Throws { & (Join-Path $scripts 'Sync-ActionProject.ps1') -TargetPath $target -Repository 'example/ledger' -Apply } 'Project is not accessible'
        Assert-Equal $writes $global:PluginTestBackend.Writes.Count 'Wrong Project stops writes'
        $global:PluginTestBackend.Fail = $true
        foreach ($helper in @('Initialize-WorkActions.ps1', 'Sync-ActionViews.ps1', 'Sync-ActionProject.ps1')) {
            Assert-Throws { & (Join-Path $scripts $helper) -TargetPath $target -Repository 'example/ledger' -Apply } 'HTTP 403'
        }
        Assert-Equal $writes $global:PluginTestBackend.Writes.Count 'Access errors never become success-shaped writes'
    } finally {
        Pop-Location
    }
    $after = @(Get-ChildItem -LiteralPath $installed, $target -File -Recurse | Get-FileHash | ForEach-Object { "$($_.Path):$($_.Hash)" }) -join "`n"
    Assert-Equal $before $after 'Helpers do not mutate installed package or target checkout files'
} finally {
    if (Test-Path Function:\global:gh) { Remove-Item Function:\global:gh }
    Remove-Variable -Name PluginTestBackend -Scope Global -ErrorAction SilentlyContinue
    $env:GH_HOST = $originalHost
    $env:GITHUB_STEP_SUMMARY = $originalSummary
    Remove-Module WorkActions -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $scratch -Recurse -Force
}

Write-Host "PASS: $script:assertions assertions; work-actions manifest, discovery, assets and isolated target-safe helpers."
