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
$script:variants = 0

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

function New-ActionIssue {
    param(
        [string[]]$Labels = @('kind:action'),
        [string]$Due = '',
        [string]$Review = '',
        [string]$Body,
        [string]$State = 'open'
    )
    if (-not $PSBoundParameters.ContainsKey('Body')) {
        $dueText = if ($Due) { $Due } else { '_No response_' }
        $reviewText = if ($Review) { $Review } else { '_No response_' }
        $Body = "### Outcome`nA synthetic outcome`n`n### Due date`n$dueText`n`n### Review on`n$reviewText`n"
    }
    return @{ number = 17; state = $State; body = $Body; labels = @($Labels | ForEach-Object { @{ name = $_ } }) }
}

# Culture-independent ordering so expected label sets do not depend on the host locale.
function Format-LabelSet {
    param([AllowEmptyCollection()][string[]]$Labels = @())
    $copy = [string[]]@($Labels)
    [Array]::Sort($copy, [StringComparer]::Ordinal)
    return $copy -join ','
}

function Get-GraphQlWrites {
    param([object[]]$Writes, [string]$Mutation)
    return @($Writes | Where-Object {
        $null -ne $_.Body -and $_.Body.ContainsKey('query') -and $_.Body.query.Contains($Mutation)
    })
}

function Select-IssueWrite {
    param([object[]]$Writes = @(), [ValidateSet('labels-added', 'labels-removed', 'comments')][string]$Kind)
    $pattern = switch ($Kind) {
        'labels-added' { '^repos/example/ledger/issues/17/labels$' }
        'labels-removed' { '^repos/example/ledger/issues/17/labels/' }
        'comments' { '^repos/example/ledger/issues/17/comments$' }
    }
    return @($Writes | Where-Object { $_.Arguments[0] -eq 'api' -and $_.Arguments[1] -match $pattern })
}

# Replaces the one faked issue with a complete record, so each scenario starts from known state.
function Set-BackendIssue {
    param([string[]]$Labels = @('kind:action'), [string]$Due = '', [string]$Review = '', [string]$Body, [string]$State = 'open')
    $arguments = @{ Labels = $Labels; Due = $Due; Review = $Review; State = $State }
    if ($PSBoundParameters.ContainsKey('Body')) { $arguments['Body'] = $Body }
    $issue = New-ActionIssue @arguments
    $issue['assignees'] = @(@{ login = 'human-owner' })
    $issue['html_url'] = 'https://github.com/example/ledger/issues/17'
    $global:PluginTestBackend.Issue = $issue
}

# A copy of the synthetic ledger whose only difference is the extraViews value, written as given.
function New-LedgerVariant {
    param([Parameter(Mandatory)][AllowNull()][AllowEmptyCollection()][object]$ExtraViews)
    $script:variants++
    $directory = (New-Item -ItemType Directory -Path (Join-Path $scratch "variant-$script:variants" '.github')).FullName
    $variant = Get-Content -LiteralPath (Join-Path $fixtures 'work-actions.json') -Raw | ConvertFrom-Json -AsHashtable
    $variant['extraViews'] = $ExtraViews
    ConvertTo-Json -InputObject $variant -Depth 10 | Set-Content -LiteralPath (Join-Path $directory 'work-actions.json') -Encoding utf8
    return Split-Path $directory -Parent
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
Assert-Equal 'MIT' $manifest.license 'Manifest declares the repository licence'
Assert-True (-not [string]::IsNullOrWhiteSpace($manifest.description)) 'Manifest description is required'
Assert-True (-not [string]::IsNullOrWhiteSpace($manifest.author.name)) 'Manifest author is required'
Assert-True ($manifest.keywords -is [array] -and $manifest.keywords.Count -gt 0) 'Manifest keywords are an array'
foreach ($key in $manifest.Keys) {
    Assert-True ($key -in @('$schema', 'name', 'version', 'description', 'license', 'author', 'keywords')) "Unexpected manifest field: $key"
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
        Views = @(@{ id = 'TEST_VIEW'; name = 'All actions' })
        ExistingLabels = @()
        ExtraIssues = @()
        Comments = [Collections.Generic.List[hashtable]]::new()
        IssueReads = 0
        OnIssueRead = $null
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
                                views = @{ nodes = @($backend.Views) }
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
            if ($path -match '/labels\?') {
                return '[' + (ConvertTo-Json -InputObject @($backend.ExistingLabels) -Depth 20 -Compress) + ']'
            }
            if ($path -eq 'repos/example/ledger/labels' -and $method -eq 'POST') { return '{}' }
            if ($path -match '^repos/example/ledger/labels/[^/]+$' -and $method -eq 'PATCH') { return '{}' }
            if ($path -match '/issues\?') {
                $issues = ConvertTo-Json -InputObject (@($backend.Issue) + @($backend.ExtraIssues)) -Depth 20 -Compress
                return "[$issues]"
            }
            if ($path -eq 'repos/example/ledger/issues/17' -and $method -eq 'GET') {
                $backend.IssueReads++
                if ($null -ne $backend.OnIssueRead) { & $backend.OnIssueRead $backend.IssueReads }
                return $backend.Issue | ConvertTo-Json -Depth 20 -Compress
            }
            if ($path -eq 'repos/example/ledger/issues/17/labels' -and $method -eq 'POST') {
                foreach ($label in $body.labels) { $backend.Issue.labels += @{ name = $label } }
                return '[]'
            }
            if ($path -match '^repos/example/ledger/issues/17/labels/([^/]+)$' -and $method -eq 'DELETE') {
                $removed = [Uri]::UnescapeDataString($Matches[1])
                $backend.Issue.labels = @($backend.Issue.labels | Where-Object { $_.name -cne $removed })
                return '[]'
            }
            if ($path -match '^repos/example/ledger/issues/17/comments\?' -and $method -eq 'GET') {
                return '[' + (ConvertTo-Json -InputObject @($backend.Comments) -Depth 20 -Compress) + ']'
            }
            if ($path -eq 'repos/example/ledger/issues/17/comments' -and $method -eq 'POST') {
                $backend.Comments.Add(@{ body = $body.body; created_at = ('2026-10-20T12:{0:00}:00Z' -f $backend.Comments.Count) })
                return '{}'
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

    # Attention-view rules are pure. Today is 2026-10-20 in the ledger's Europe/London zone.
    $rulesNow = [DateTimeOffset]'2026-10-20T12:00:00Z'
    $fence = '```'
    $viewCases = @(
        @{ Name = 'an overdue action'; Issue = @{ Due = '2026-10-19' }; Expect = 'view:do-now' }
        @{ Name = 'an action due today'; Issue = @{ Due = '2026-10-20' }; Expect = 'view:do-now' }
        @{ Name = 'an action due tomorrow'; Issue = @{ Due = '2026-10-21' }; Expect = 'view:plan-next' }
        @{ Name = 'an action due in 2 days'; Issue = @{ Due = '2026-10-22' }; Expect = 'view:review-soon' }
        @{ Name = 'an action due in 6 days'; Issue = @{ Due = '2026-10-26' }; Expect = 'view:review-soon' }
        @{ Name = 'an action due in 7 days'; Issue = @{ Due = '2026-10-27' }; Expect = 'view:review-later' }
        @{ Name = 'an action due in 29 days'; Issue = @{ Due = '2026-11-18' }; Expect = 'view:review-later' }
        @{ Name = 'an action due in 30 days without a horizon label (Later ends at day 29)'; Issue = @{ Due = '2026-11-19' }; Expect = '' }
        @{ Name = 'an undated action'; Issue = @{}; Expect = 'view:someday' }
        @{ Name = 'an action with blank date sections'; Issue = @{ Body = "### Due date`n`n### Review on`n" }; Expect = 'view:someday' }
        @{ Name = 'an action with only a review date tomorrow'; Issue = @{ Review = '2026-10-21' }; Expect = 'view:plan-next' }
        @{ Name = 'the earlier of the due and review dates'; Issue = @{ Due = '2026-11-01'; Review = '2026-10-01' }; Expect = 'view:do-now' }
        @{ Name = 'a 1-Now label'; Issue = @{ Labels = @('kind:action', '1-Now') }; Expect = 'view:do-now' }
        @{ Name = 'a 2-Next label'; Issue = @{ Labels = @('kind:action', '2-Next') }; Expect = 'view:plan-next' }
        @{ Name = 'a 3-Soon label'; Issue = @{ Labels = @('kind:action', '3-Soon') }; Expect = 'view:review-soon' }
        @{ Name = 'a 4-Later label'; Issue = @{ Labels = @('kind:action', '4-Later') }; Expect = 'view:review-later' }
        @{ Name = 'a 5-Someday label'; Issue = @{ Labels = @('kind:action', '5-Someday') }; Expect = 'view:someday' }
        @{ Name = '1-Now with a date tomorrow (1-Now suppresses Next)'; Issue = @{ Labels = @('kind:action', '1-Now'); Due = '2026-10-21' }; Expect = 'view:do-now' }
        @{ Name = '2-Next due today (intentional overlap)'; Issue = @{ Labels = @('kind:action', '2-Next'); Due = '2026-10-20' }; Expect = 'view:do-now,view:plan-next' }
        @{ Name = '3-Soon due today (exclusions use labels, not views)'; Issue = @{ Labels = @('kind:action', '3-Soon'); Due = '2026-10-20' }; Expect = 'view:do-now,view:review-soon' }
        @{ Name = '5-Someday due tomorrow'; Issue = @{ Labels = @('kind:action', '5-Someday'); Due = '2026-10-21' }; Expect = 'view:plan-next,view:someday' }
        @{ Name = 'an overdue waiting action'; Issue = @{ Labels = @('kind:action', '6-Waiting'); Due = '2026-10-19' }; Expect = 'view:do-now,view:waiting' }
        @{ Name = 'an undated waiting action'; Issue = @{ Labels = @('kind:action', '6-Waiting') }; Expect = 'view:waiting' }
        @{ Name = 'an undated inbox action'; Issue = @{ Labels = @('kind:action', 'Inbox') }; Expect = 'view:capture,view:do-now,view:someday' }
        @{ Name = 'a Project'; Issue = @{ Labels = @('Project') }; Expect = 'view:projects' }
        @{ Name = 'a Project whose action dates are not parsed'; Issue = @{ Labels = @('Project'); Due = 'next Tuesday' }; Expect = 'view:projects' }
        @{ Name = 'a closed action'; Issue = @{ Labels = @('kind:action', 'view:do-now'); State = 'closed' }; Expect = '' }
        @{ Name = 'a due heading inside a code fence'; Issue = @{ Body = "### Outcome`n$fence`n### Due date`n2026-10-19`n$fence`n" }; Expect = 'view:someday' }
        @{ Name = 'a due heading inside a blockquote'; Issue = @{ Body = "> ### Due date`n> 2026-10-19`n" }; Expect = 'view:someday' }
    )
    foreach ($case in $viewCases) {
        $issueArguments = $case.Issue
        $result = Get-ActionViewResult -Issue (New-ActionIssue @issueArguments) -Configuration $resolved -Now $rulesNow
        Assert-Equal $case.Expect (Format-LabelSet $result.Labels) "Views for $($case.Name)"
        Assert-Equal 0 $result.Errors.Count "No metadata errors for $($case.Name)"
    }
    $pullRequest = New-ActionIssue
    $pullRequest['pull_request'] = @{ url = 'https://example.test/pull/17' }
    $pullResult = Get-ActionViewResult -Issue $pullRequest -Configuration $resolved -Now $rulesNow
    Assert-Equal 0 ($pullResult.Labels.Count + $pullResult.Errors.Count) 'Pull requests never receive views or validation errors'
    $earlier = Get-ActionViewResult -Issue (New-ActionIssue -Due '2026-11-01' -Review '2026-10-01') -Configuration $resolved -Now $rulesNow
    Assert-Equal '2026-10-01' $earlier.AttentionDate 'The attention date is the earlier of the due and review dates'
    $undated = Get-ActionViewResult -Issue (New-ActionIssue) -Configuration $resolved -Now $rulesNow
    Assert-True ($null -eq $undated.AttentionDate) 'An undated action has no attention date'

    $errorCases = @(
        @{ Name = 'both kinds'; Issue = @{ Labels = @('kind:action', 'Project') }; Expect = "Apply exactly one kind: 'kind:action' or 'Project'." }
        @{ Name = 'neither kind'; Issue = @{ Labels = @('Inbox') }; Expect = "Apply exactly one kind: 'kind:action' or 'Project'." }
        @{ Name = 'two horizons'; Issue = @{ Labels = @('kind:action', '1-Now', '3-Soon') }; Expect = 'Choose at most one horizon from 1-Now through 5-Someday.' }
        @{ Name = 'two execution states'; Issue = @{ Labels = @('kind:action', 'state:ready', '6-Waiting') }; Expect = 'Choose at most one execution state, including 6-Waiting.' }
        @{ Name = 'a free-text due date'; Issue = @{ Due = 'next Tuesday' }; Expect = "'Due date' must be blank or a valid YYYY-MM-DD date." }
        @{ Name = 'a non-calendar due date'; Issue = @{ Due = '2026-02-30' }; Expect = "'Due date' must be blank or a valid YYYY-MM-DD date." }
        @{ Name = 'a free-text review date'; Issue = @{ Review = '20/10/2026' }; Expect = "'Review on' must be blank or a valid YYYY-MM-DD date." }
        @{ Name = 'a duplicated due section'; Issue = @{ Body = "### Due date`n2026-10-21`n`n### Due date`n2026-10-22`n" }; Expect = "The 'Due date' section appears more than once." }
        @{ Name = 'a fenced due value'; Issue = @{ Body = "### Due date`n$fence`n2026-10-21`n$fence`n" }; Expect = "'Due date' must be blank or a valid YYYY-MM-DD date." }
    )
    foreach ($case in $errorCases) {
        $issueArguments = $case.Issue
        $result = Get-ActionViewResult -Issue (New-ActionIssue @issueArguments) -Configuration $resolved -Now $rulesNow
        Assert-Equal 'automation:needs-fix' (Format-LabelSet $result.Labels) "Invalid metadata ($($case.Name)) gets only the validation label"
        Assert-Equal $case.Expect ($result.Errors -join ' | ') "Invalid metadata ($($case.Name)) says why"
    }

    foreach ($zoneCase in @(
        @{ At = '2026-07-01T23:30:00Z'; Today = '2026-07-02' }
        @{ At = '2026-01-01T23:30:00Z'; Today = '2026-01-01' }
        @{ At = '2026-10-24T23:30:00Z'; Today = '2026-10-25' }
        @{ At = '2026-10-25T23:30:00Z'; Today = '2026-10-25' }
    )) {
        $zoneResult = Get-ActionViewResult -Issue (New-ActionIssue) -Configuration $resolved -Now ([DateTimeOffset]$zoneCase.At)
        Assert-Equal $zoneCase.Today $zoneResult.Today "Today follows Europe/London, including BST, at $($zoneCase.At)"
    }
    $auckland = $resolved.Clone()
    $auckland['timeZone'] = 'Pacific/Auckland'
    $dueTomorrow = New-ActionIssue -Due '2026-10-21'
    Assert-Equal 'view:plan-next' (Format-LabelSet (Get-ActionViewResult -Issue $dueTomorrow -Configuration $resolved -Now $rulesNow).Labels) 'In London the 21st is still tomorrow'
    Assert-Equal 'view:do-now' (Format-LabelSet (Get-ActionViewResult -Issue $dueTomorrow -Configuration $auckland -Now $rulesNow).Labels) 'The same instant is already the 21st in Auckland, so dates follow the configured zone'

    $managed = Get-ManagedActionLabels $resolved
    Assert-Equal 9 $managed.Count 'The eight view labels and the validation label are reconciler-managed'
    Assert-True ('state:review' -notin $managed) 'Extra Project view labels are never reconciler-managed'
    $delta = Get-ActionLabelDelta -CurrentLabels @('kind:action', 'view:do-now', 'custom') -DesiredLabels @('view:plan-next') -ManagedLabels $managed
    Assert-Equal 'view:plan-next' ($delta.Add -join ',') 'The delta adds only the desired derived label'
    Assert-Equal 'view:do-now' ($delta.Remove -join ',') 'The delta removes only stale derived labels and never source labels'
    $converged = Get-ActionLabelDelta -CurrentLabels @('kind:action', 'view:plan-next') -DesiredLabels @('view:plan-next') -ManagedLabels $managed
    Assert-Equal 0 ($converged.Add.Count + $converged.Remove.Count) 'A converged issue has an empty delta'
    $repaired = Get-ActionLabelDelta -CurrentLabels @('kind:action', 'automation:needs-fix') -DesiredLabels @('view:plan-next') -ManagedLabels $managed
    Assert-Equal 'automation:needs-fix' ($repaired.Remove -join ',') 'A repaired issue loses the validation flag'
    Assert-Throws { Get-ActionLabelDelta -CurrentLabels @() -DesiredLabels @('kind:action') -ManagedLabels $managed } 'only write configured derived labels'
    Assert-Equal 'a,b' ((Get-IssueLabelNames @{ labels = @('a', @{ name = 'b' }) }) -join ',') 'Labels may be plain strings or objects with a name'

    $sourceIssue = New-ActionIssue -Labels @('kind:action', 'custom') -Due '2026-10-21'
    $fingerprint = Get-ActionSourceFingerprint -Issue $sourceIssue -ManagedLabels $managed
    Assert-Equal 64 $fingerprint.Length 'The source fingerprint is a SHA-256 hex digest'
    $derivedChange = New-ActionIssue -Labels @('custom', 'view:do-now', 'kind:action', 'automation:needs-fix') -Due '2026-10-21'
    Assert-Equal $fingerprint (Get-ActionSourceFingerprint -Issue $derivedChange -ManagedLabels $managed) 'Derived labels and label order do not change the fingerprint'
    foreach ($sourceChange in @(
        @{ Name = 'body'; Issue = (New-ActionIssue -Labels @('kind:action', 'custom') -Due '2026-10-22') }
        @{ Name = 'state'; Issue = (New-ActionIssue -Labels @('kind:action', 'custom') -Due '2026-10-21' -State 'closed') }
        @{ Name = 'source label'; Issue = (New-ActionIssue -Labels @('kind:action', 'custom', '2-Next') -Due '2026-10-21') }
    )) {
        Assert-True ($fingerprint -cne (Get-ActionSourceFingerprint -Issue $sourceChange.Issue -ManagedLabels $managed)) "A $($sourceChange.Name) change alters the fingerprint"
    }

    # extraViews feeds the Project view filters, so it is validated before any request.
    $callsBefore = $global:PluginTestBackend.Calls.Count
    foreach ($valid in @(
        @{ Name = 'an empty list'; Value = @(); Expected = 0 }
        @{ Name = 'an explicit null'; Value = $null; Expected = 0 }
        @{ Name = 'an entry without a label'; Value = @(@{ name = 'Everything else' }); Expected = 1 }
    )) {
        $ledger = New-LedgerVariant -ExtraViews $valid.Value
        $accepted = Get-ActionConfiguration -TargetPath $ledger -Repository 'example/ledger'
        Assert-Equal $valid.Expected @($accepted['extraViews']).Count "extraViews accepts $($valid.Name)"
    }
    $malformed = @(
        @{ Name = 'a string'; Value = 'Agents running'; Expect = 'extraViews must be an array' }
        @{ Name = 'a single object instead of an array'; Value = @{ name = 'Agents running' }; Expect = 'extraViews must be an array' }
        @{ Name = 'a null entry'; Value = @($null); Expect = 'extraViews entry 1 must be an object' }
        @{ Name = 'a string entry'; Value = @('Agents running'); Expect = 'extraViews entry 1 must be an object' }
        @{ Name = 'an entry without a name'; Value = @(@{ label = 'state:running' }); Expect = 'extraViews entry 1 needs a non-empty name' }
        @{ Name = 'an id field'; Value = @(@{ name = 'Agents running'; id = 'TEST_VIEW' }); Expect = "contains unsupported field 'id'" }
        @{ Name = 'an unknown field'; Value = @(@{ name = 'Agents running'; filter = 'state:running' }); Expect = "contains unsupported field 'filter'" }
        @{ Name = 'a blank name'; Value = @(@{ name = '  '; label = 'state:running' }); Expect = 'extraViews entry 1 needs a non-empty name' }
        @{ Name = 'a numeric name'; Value = @(@{ name = 5 }); Expect = 'extraViews entry 1 needs a non-empty name' }
        @{ Name = 'an empty label'; Value = @(@{ name = 'Agents running'; label = '' }); Expect = "extraViews entry 1 ('Agents running') has an invalid label" }
        @{ Name = 'a null label'; Value = @(@{ name = 'Agents running'; label = $null }); Expect = "extraViews entry 1 ('Agents running') has an invalid label" }
        @{ Name = 'a numeric label'; Value = @(@{ name = 'Agents running'; label = 7 }); Expect = "extraViews entry 1 ('Agents running') has an invalid label" }
        @{ Name = 'a label with a quote'; Value = @(@{ name = 'Agents running'; label = 'state:"running"' }); Expect = "extraViews entry 1 ('Agents running') has an invalid label" }
        @{ Name = 'a label with a line break'; Value = @(@{ name = 'Agents running'; label = "state:running`nis:closed" }); Expect = "extraViews entry 1 ('Agents running') has an invalid label" }
        @{ Name = 'a repeated name'; Value = @(@{ name = 'Agents running' }, @{ name = 'agents RUNNING' }); Expect = "extraViews entry 2 ('agents RUNNING') repeats a view name" }
        @{ Name = 'a built-in view name'; Value = @(@{ name = 'Projects' }); Expect = "extraViews entry 1 ('Projects') repeats a view name" }
        @{ Name = 'the All actions name'; Value = @(@{ name = 'all ACTIONS' }); Expect = "extraViews entry 1 ('all ACTIONS') repeats a view name" }
    )
    foreach ($case in $malformed) {
        $ledger = New-LedgerVariant -ExtraViews $case.Value
        Assert-Throws { Get-ActionConfiguration -TargetPath $ledger -Repository 'example/ledger' } $case.Expect
    }
    $duplicateLedger = New-LedgerVariant -ExtraViews @(@{ name = 'Agents running' }, @{ name = 'agents running' })
    foreach ($helper in @('Initialize-WorkActions.ps1', 'Sync-ActionViews.ps1', 'Sync-ActionProject.ps1')) {
        Assert-Throws { & (Join-Path $scripts $helper) -TargetPath $duplicateLedger -Repository 'example/ledger' -Apply } 'repeats a view name'
    }
    Assert-Equal $callsBefore $global:PluginTestBackend.Calls.Count 'A malformed extraViews entry fails every entry point before any GitHub request'

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

        # extraViews is optional: a ledger configuration without it must behave like an empty list.
        $bare = (New-Item -ItemType Directory -Path (Join-Path $scratch 'target without extra views')).FullName
        $bareConfigurationPath = Join-Path (New-Item -ItemType Directory -Path (Join-Path $bare '.github')).FullName 'work-actions.json'
        $bareSource = Get-Content -LiteralPath (Join-Path $fixtures 'work-actions.json') -Raw | ConvertFrom-Json -AsHashtable
        $bareSource.Remove('extraViews')
        $bareSource | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $bareConfigurationPath -Encoding utf8
        Assert-True ((Get-Content -LiteralPath $bareConfigurationPath -Raw) -notmatch 'extraViews') 'The variant ledger configuration omits the optional extraViews key'
        $bareResolved = Get-ActionConfiguration -TargetPath $bare -Repository 'example/ledger'
        Assert-True ($bareResolved.ContainsKey('extraViews') -and @($bareResolved['extraViews']).Count -eq 0) 'An omitted extraViews key resolves to no extra views'
        $barePreview = @(& (Join-Path $scripts 'Sync-ActionProject.ps1') -TargetPath $bare -Repository 'example/ledger' 6>&1 | ForEach-Object { [string]$_ })
        Assert-Equal 9 @($barePreview | Where-Object { $_.StartsWith("View '") }).Count 'Omitted extraViews previews only the nine built-in views'
        $writes = $global:PluginTestBackend.Writes.Count
        & (Join-Path $scripts 'Sync-ActionProject.ps1') -TargetPath $bare -Repository 'example/ledger' -Apply
        $bareWrites = @($global:PluginTestBackend.Writes | Select-Object -Skip $writes)
        Assert-Equal 1 @($bareWrites | Where-Object { $_.Arguments[0] -eq 'project' -and $_.Arguments[1] -eq 'link' }).Count 'Omitted extraViews still links the Project after the views are written'
        Assert-Equal 1 @($bareWrites | Where-Object { $_.Arguments[0] -eq 'project' -and $_.Arguments[1] -eq 'item-add' }).Count 'Omitted extraViews still adds the action record to the Project'

        # Label reconciler against the faked API. Each scenario replaces the one faked issue.
        $backend = $global:PluginTestBackend
        $viewsScript = Join-Path $scripts 'Sync-ActionViews.ps1'
        $one = @{ TargetPath = $target; Repository = 'example/ledger'; IssueNumber = 17; Now = $now }
        $bulk = @{ TargetPath = $target; Repository = 'example/ledger'; Now = $now }

        Set-BackendIssue -Labels @('kind:action', 'custom', 'view:do-now') -Due '2026-10-21'
        $mark = $backend.Writes.Count
        & $viewsScript @one -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 'custom,kind:action,view:plan-next' (Format-LabelSet (Get-IssueLabelNames $backend.Issue)) 'The reconciler swaps a stale derived label and keeps source labels'
        Assert-Equal 'repos/example/ledger/issues/17/labels/view%3Ado-now' (@(Select-IssueWrite $applied 'labels-removed' | ForEach-Object { $_.Arguments[1] }) -join ',') 'Removed labels are URL-encoded in the request path'
        Assert-Equal 'view:plan-next' (@(Select-IssueWrite $applied 'labels-added' | ForEach-Object { $_.Body.labels }) -join ',') 'Only the missing derived label is added'
        Assert-Equal 0 @(Select-IssueWrite $applied 'comments').Count 'Valid metadata never produces a validation comment'

        Set-BackendIssue -Labels @('Inbox')
        $mark = $backend.Writes.Count
        & $viewsScript @one -WarningVariable warned -WarningAction SilentlyContinue
        Assert-Equal $mark $backend.Writes.Count 'Previewing invalid metadata writes nothing'
        Assert-Equal 1 @($warned).Count 'Previewing invalid metadata still warns'
        Assert-True ([string]$warned[0] -like 'Issue #17: Apply exactly one kind*') 'The preview warning explains the metadata problem'

        Set-BackendIssue -Labels @('kind:action', 'Project')
        & $viewsScript @one -Apply -WarningAction SilentlyContinue
        Assert-Equal 'Project,automation:needs-fix,kind:action' (Format-LabelSet (Get-IssueLabelNames $backend.Issue)) 'Invalid metadata gets only the validation flag'
        Assert-Equal 1 $backend.Comments.Count 'The first invalid refresh explains the flag in one comment'
        $report = [string]$backend.Comments[0].body
        Assert-True ($report.StartsWith('<!-- work-actions:validation -->')) 'The report carries the marker used to avoid repeats'
        Assert-True ($report.Contains("- Apply exactly one kind: 'kind:action' or 'Project'.")) 'The report lists the problem'
        Assert-True ($report.Contains("Follow this ledger repository's approved operating instructions")) 'The validation report refers to target-owned operating instructions'
        Assert-True (-not $report.Contains('docs/working-method.md')) 'The report does not assume a target-specific file exists'
        $mark = $backend.Writes.Count
        & $viewsScript @one -Apply -WarningAction SilentlyContinue
        Assert-Equal $mark $backend.Writes.Count 'Repeating identical invalid metadata writes nothing'
        Assert-Equal 1 $backend.Comments.Count 'An identical report is not posted twice'

        Set-BackendIssue -Labels @('kind:action', 'automation:needs-fix') -Due 'next Tuesday'
        $mark = $backend.Writes.Count
        & $viewsScript @one -Apply -WarningAction SilentlyContinue
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 2 $backend.Comments.Count 'A different problem is reported again'
        Assert-Equal 1 @(Select-IssueWrite $applied 'comments').Count 'A changed report adds a comment'
        Assert-Equal 1 $applied.Count 'A changed report writes nothing else'
        Assert-True (([string]$backend.Comments[1].body).Contains("- 'Due date' must be blank or a valid YYYY-MM-DD date.")) 'The new report names the new problem'
        Set-BackendIssue -Labels @('kind:action', 'automation:needs-fix') -Due '2026-10-21'
        $mark = $backend.Writes.Count
        & $viewsScript @one -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 'kind:action,view:plan-next' (Format-LabelSet (Get-IssueLabelNames $backend.Issue)) 'Fixed metadata loses the validation flag and gains its view'
        Assert-Equal 'repos/example/ledger/issues/17/labels/automation%3Aneeds-fix' (@(Select-IssueWrite $applied 'labels-removed' | ForEach-Object { $_.Arguments[1] }) -join ',') 'The validation flag is removed by the next refresh'
        Assert-Equal 2 $backend.Comments.Count 'Earlier notices remain as history and no comment is added'

        Set-BackendIssue -Labels @('kind:action') -Due 'next Tuesday'
        & $viewsScript @one -Apply -WarningAction SilentlyContinue
        Assert-Equal 3 $backend.Comments.Count 'A problem that returns after a fix is reported again, because suppression lasts only while the flag is present'

        Set-BackendIssue -Labels @('kind:action', 'view:do-now', 'view:someday') -State 'closed'
        $summary = @(& $viewsScript @bulk -Apply 6>&1 | ForEach-Object { [string]$_ })
        Assert-Equal 'kind:action' (Format-LabelSet (Get-IssueLabelNames $backend.Issue)) 'Closing an issue removes it from every derived view'
        Assert-Equal 'Applied. Inspected 1 issues; reconciled 1; invalid metadata on 0.' $summary[-1] 'The bulk refresh reports what it reconciled'

        Set-BackendIssue -Labels @('kind:action') -Due '2026-10-21'
        $backend.ExtraIssues = @(
            @{ number = 18; state = 'open'; body = ''; labels = @(@{ name = 'view:do-now' }); pull_request = @{ url = 'https://example.test/pull/18' } }
            @{ number = 19; state = 'closed'; body = ''; labels = @(@{ name = 'kind:action' }) }
        )
        $callMark = $backend.Calls.Count
        $summary = @(& $viewsScript @bulk -Apply 6>&1 | ForEach-Object { [string]$_ })
        $strayCalls = @($backend.Calls | Select-Object -Skip $callMark | Where-Object { $_.Arguments[0] -eq 'api' -and $_.Arguments[1] -match 'issues/(18|19)' })
        Assert-Equal 0 $strayCalls.Count 'The bulk refresh never reads or writes pull requests or closed issues without derived labels'
        Assert-Equal 'Applied. Inspected 1 issues; reconciled 1; invalid metadata on 0.' $summary[-1] 'Only the open action is inspected'
        $backend.ExtraIssues = @()

        Set-BackendIssue -Labels @('kind:action') -Due '2026-10-21'
        $readsBefore = $backend.IssueReads
        $backend.OnIssueRead = {
            param($count)
            if ($count -eq $readsBefore + 2) { $global:PluginTestBackend.Issue.body += "`nEdited elsewhere." }
        }.GetNewClosure()
        $mark = $backend.Writes.Count
        Assert-Throws { & $viewsScript @one -Apply } 'changed before reconciliation'
        Assert-Equal $mark $backend.Writes.Count 'A source edit before reconciliation stops the run before any write'
        Assert-Equal 'kind:action' (Format-LabelSet (Get-IssueLabelNames $backend.Issue)) 'No derived label is written after a conflict found before writing'

        Set-BackendIssue -Labels @('kind:action') -Due '2026-10-21'
        $readsBefore = $backend.IssueReads
        $backend.OnIssueRead = {
            param($count)
            if ($count -eq $readsBefore + 3) { $global:PluginTestBackend.Issue.body += "`nEdited elsewhere." }
        }.GetNewClosure()
        $mark = $backend.Writes.Count
        Assert-Throws { & $viewsScript @one -Apply } 'changed during reconciliation'
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 1 $applied.Count 'A conflict found after writing follows only one derived label write'
        Assert-Equal 1 @(Select-IssueWrite $applied 'labels-added').Count 'The only write before that conflict is the derived label'
        $backend.OnIssueRead = $null

        # Label setup against the faked API.
        $labelsScript = Join-Path $scripts 'Initialize-WorkActions.ps1'
        $definitions = Get-Content -LiteralPath (Join-Path $target '.github' 'labels.json') -Raw | ConvertFrom-Json -AsHashtable
        $mark = $backend.Writes.Count
        $preview = @(& $labelsScript -TargetPath $target -Repository 'example/ledger' 6>&1 | ForEach-Object { [string]$_ })
        Assert-Equal $definitions.Count @($preview | Where-Object { $_.StartsWith('Create label: ') }).Count 'The label preview lists every missing label'
        Assert-Equal $mark $backend.Writes.Count 'The label preview writes nothing'
        & $labelsScript -TargetPath $target -Repository 'example/ledger' -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal $definitions.Count @($applied | Where-Object { $_.Arguments -contains 'POST' }).Count 'Applying creates every missing label'
        $backend.ExistingLabels = @($definitions | ForEach-Object { @{ name = $_.name; color = $_.color; description = $_.description } })
        $mark = $backend.Writes.Count
        & $labelsScript -TargetPath $target -Repository 'example/ledger' -Apply
        Assert-Equal $mark $backend.Writes.Count 'Labels that already match their definition are left alone'
        $backend.ExistingLabels = @($backend.ExistingLabels | ForEach-Object {
            $drifted = $_.Clone()
            if ($drifted.name -ceq 'Inbox') { $drifted.color = '000000' }
            if ($drifted.name -ceq '1-Now') { $drifted.name = '1-now' }
            $drifted
        })
        $mark = $backend.Writes.Count
        & $labelsScript -TargetPath $target -Repository 'example/ledger' -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 2 $applied.Count 'Only drifted labels are written'
        Assert-Equal 0 @($applied | Where-Object { $_.Arguments -contains 'POST' }).Count 'Existing labels are updated, never created again'
        $inbox = @($applied | Where-Object { $_.Arguments[1] -ceq 'repos/example/ledger/labels/Inbox' })
        Assert-Equal 'bf3989' $inbox[0].Body.color 'A drifted colour is restored from the definition'
        $horizon = @($applied | Where-Object { $_.Arguments[1] -ceq 'repos/example/ledger/labels/1-now' })
        Assert-Equal '1-Now' $horizon[0].Body.new_name 'A label that differs only by case is renamed to the definition'
        $backend.ExistingLabels = @()

        # Project view maintenance against the faked API.
        $projectScript = Join-Path $scripts 'Sync-ActionProject.ps1'
        $preview = @(& $projectScript -TargetPath $target -Repository 'example/ledger' 6>&1 | ForEach-Object { [string]$_ })
        $viewLines = @($preview | Where-Object { $_.StartsWith("View '") })
        Assert-Equal 13 $viewLines.Count 'The default ledger previews All actions, eight attention views and four oversight views'
        Assert-True ($viewLines -ccontains "View 'All actions': is:issue repo:example/ledger") 'The All actions view filters only by repository'
        Assert-True ($viewLines -ccontains "View 'Do - Now': is:issue repo:example/ledger is:open label:`"view:do-now`"") 'Attention views show open issues carrying their derived label'
        Assert-True ($viewLines -ccontains "View 'Needs your decision': is:issue repo:example/ledger is:open label:`"state:review`"") 'Oversight views show open issues carrying their source label'
        $mark = $backend.Writes.Count
        & $projectScript -TargetPath $target -Repository 'example/ledger' -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        $created = @(Get-GraphQlWrites -Writes $applied -Mutation 'createProjectV2View')
        $updated = @(Get-GraphQlWrites -Writes $applied -Mutation 'updateProjectV2View')
        Assert-Equal 12 $created.Count 'Every view except the existing All actions view is created'
        Assert-Equal 13 $updated.Count 'Every configured view is updated with its filter'
        Assert-Equal 0 @($created | Where-Object { $_.Body.variables.input.projectId -cne 'TEST_PROJECT' }).Count 'Views are created in the configured Project'
        $allActions = @($updated | Where-Object { $_.Body.variables.input.name -ceq 'All actions' })
        Assert-Equal 1 $allActions.Count 'The All actions view is updated once'
        Assert-Equal 'TEST_VIEW' $allActions[0].Body.variables.input.viewId 'The All actions view is updated by its configured id'
        Assert-Equal 12 @($updated | Where-Object { $_.Body.variables.input.viewId -ceq 'CREATED_VIEW' }).Count 'The other views are updated by the id returned when they were created'
        Assert-Equal 13 @($updated | Where-Object {
            ($_.Body.variables.input.configuration.visibleFieldIds -join ',') -ceq 'TITLE,LABELS,ASSIGNEES' -and $_.Body.variables.input.layout -ceq 'TABLE_LAYOUT'
        }).Count 'Every view is a table showing Title, Labels and Assignees only'

        $backend.Views = @(@{ id = 'TEST_VIEW'; name = 'All actions' }, @{ id = 'EXISTING_PROJECTS'; name = 'projects' })
        $mark = $backend.Writes.Count
        & $projectScript -TargetPath $target -Repository 'example/ledger' -Apply
        $applied = @($backend.Writes | Select-Object -Skip $mark)
        Assert-Equal 11 @(Get-GraphQlWrites -Writes $applied -Mutation 'createProjectV2View').Count 'An existing view is reused rather than created again'
        $projects = @(Get-GraphQlWrites -Writes $applied -Mutation 'updateProjectV2View' | Where-Object { $_.Body.variables.input.name -ceq 'Projects' })
        Assert-Equal 'EXISTING_PROJECTS' $projects[0].Body.variables.input.viewId 'Existing views match by name, ignoring case, and take the configured name'

        $backend.Views = @(@{ id = 'TEST_VIEW'; name = 'All actions' }, @{ id = 'ONE'; name = 'Projects' }, @{ id = 'TWO'; name = 'projects' })
        $mark = $backend.Writes.Count
        Assert-Throws { & $projectScript -TargetPath $target -Repository 'example/ledger' } "More than one Project view is named 'Projects'"
        Assert-Equal $mark $backend.Writes.Count 'Ambiguous view names stop the preview without writes'

        $backend.Views = @()
        foreach ($mode in @(@{}, @{ Apply = $true })) {
            Assert-Throws { & $projectScript -TargetPath $target -Repository 'example/ledger' @mode } 'configured All actions view is missing'
        }
        Assert-Equal $mark $backend.Writes.Count 'A missing All actions view stops before any write'
        $backend.Views = @(@{ id = 'TEST_VIEW'; name = 'All actions' })

        $labelless = New-LedgerVariant -ExtraViews @(@{ name = 'Everything else' })
        $preview = @(& $projectScript -TargetPath $labelless -Repository 'example/ledger' 6>&1 | ForEach-Object { [string]$_ })
        Assert-True ($preview -ccontains "View 'Everything else': is:issue repo:example/ledger") 'An extra view without a label filters by repository only'

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
