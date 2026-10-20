#Requires -Version 7.2
Set-StrictMode -Version Latest

function Get-ActionConfiguration {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$TargetPath,
        [Parameter(Mandatory)][ValidatePattern('^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$')][string]$Repository
    )
    if (-not [IO.Path]::IsPathFullyQualified($TargetPath)) {
        throw 'TargetPath must be an explicit absolute path to the target ledger checkout.'
    }
    $target = (Resolve-Path -LiteralPath $TargetPath -ErrorAction Stop).ProviderPath
    if (-not (Test-Path -LiteralPath $target -PathType Container)) {
        throw 'TargetPath must be a directory.'
    }
    $package = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..' '..'))
    $relative = [IO.Path]::GetRelativePath($package, $target)
    if ($relative -eq '.' -or ($relative -ne '..' -and
        -not $relative.StartsWith("..$([IO.Path]::DirectorySeparatorChar)") -and
        -not [IO.Path]::IsPathRooted($relative))) {
        throw 'TargetPath must not be the installed plugin directory or one of its children.'
    }
    if ($env:GH_HOST -and $env:GH_HOST -ne 'github.com') {
        throw 'These helpers target github.com; resolve GH_HOST before continuing.'
    }
    $path = Join-Path $target '.github' 'work-actions.json'
    $config = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -AsHashtable
    if ($config.repository -notmatch '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$') {
        throw 'Configure repository as owner/name in .github/work-actions.json.'
    }
    if ($config.repository -ine $Repository) {
        throw "Target repository mismatch: requested '$Repository', configuration names '$($config.repository)'."
    }
    $null = [TimeZoneInfo]::FindSystemTimeZoneById($config.timeZone)
    $keys = @('capture', 'now', 'next', 'soon', 'later', 'someday', 'waiting', 'projects')
    if (@(Compare-Object $keys @($config.views.key)).Count -ne 0 -or
        @($config.views.label | Select-Object -Unique).Count -ne $keys.Count -or
        @($config.views | Where-Object { $_.label -notmatch '^view:[a-z-]+$' }).Count -ne 0 -or
        $config.validationLabel -ne 'automation:needs-fix') {
        throw 'Configure the eight distinct attention views and the validation label.'
    }
    return $config
}

function Get-IssueLabelNames {
    param([Parameter(Mandatory)][hashtable]$Issue)
    return ,@($Issue['labels'] | ForEach-Object {
        if ($_ -is [string]) { $_ } else { $_['name'] }
    })
}

function Get-ManagedActionLabels {
    param([Parameter(Mandatory)][hashtable]$Configuration)
    return ,@($Configuration.views.label + $Configuration.validationLabel)
}

function Get-ActionDates {
    param([AllowEmptyString()][string]$Body = '')

    $sections = @{}
    $errors = [Collections.Generic.List[string]]::new()
    $active = $null
    $fenceCharacter = $null
    $fenceLength = 0
    foreach ($line in ($Body -split '\r?\n')) {
        if ($null -ne $fenceCharacter) {
            if ($null -ne $active) { $sections[$active].Add($line) }
            $closing = '^ {0,3}' + [regex]::Escape($fenceCharacter) + '{' + $fenceLength + ',}[ \t]*$'
            if ($line -match $closing) { $fenceCharacter = $null }
            continue
        }
        if ($line -match '^ {0,3}(`{3,}|~{3,})') {
            $fenceCharacter = $Matches[1].Substring(0, 1)
            $fenceLength = $Matches[1].Length
            if ($null -ne $active) { $sections[$active].Add($line) }
            continue
        }
        if ($line -match '^#{1,6}(?:[ \t]+|$)') {
            $active = $null
            if ($line -match '^### (Due date|Review on)[ \t]*$') {
                $active = $Matches[1]
                if ($sections.ContainsKey($active)) {
                    $errors.Add("The '$active' section appears more than once.")
                }
                $sections[$active] = [Collections.Generic.List[string]]::new()
            }
            continue
        }
        if ($null -ne $active) { $sections[$active].Add($line) }
    }

    $dates = @{ 'Due date' = $null; 'Review on' = $null }
    foreach ($name in @('Due date', 'Review on')) {
        if (-not $sections.ContainsKey($name)) { continue }
        $value = ($sections[$name] -join "`n").Trim()
        if ($value -eq '' -or $value -eq '_No response_') { continue }
        $date = [DateOnly]::MinValue
        if ($value -notmatch '^\d{4}-\d{2}-\d{2}$' -or
            -not [DateOnly]::TryParseExact(
                $value, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture,
                [Globalization.DateTimeStyles]::None, [ref]$date
            )) {
            $errors.Add("'$name' must be blank or a valid YYYY-MM-DD date.")
        } else {
            $dates[$name] = $date
        }
    }
    return [pscustomobject]@{ Dates = $dates; Errors = @($errors.ToArray()) }
}

function Get-ActionViewResult {
    param(
        [Parameter(Mandatory)][hashtable]$Issue,
        [Parameter(Mandatory)][hashtable]$Configuration,
        [DateTimeOffset]$Now = [DateTimeOffset]::UtcNow
    )

    $zone = [TimeZoneInfo]::FindSystemTimeZoneById($Configuration.timeZone)
    $today = [DateOnly]::FromDateTime([TimeZoneInfo]::ConvertTime($Now, $zone).DateTime)
    $derived = [Collections.Generic.List[string]]::new()
    $errors = [Collections.Generic.List[string]]::new()
    $attentionDate = $null
    $labels = Get-IssueLabelNames $Issue
    $view = @{}
    foreach ($item in $Configuration.views) { $view[$item.key] = $item.label }

    if ($Issue['state'] -ne 'closed' -and -not $Issue.ContainsKey('pull_request')) {
        $isAction = $labels -contains 'kind:action'
        $isProject = $labels -contains 'Project'
        if ($isAction -eq $isProject) {
            $errors.Add("Apply exactly one kind: 'kind:action' or 'Project'.")
        }
        if ($isAction) {
            $horizons = @($labels | Where-Object { $_ -in @('1-Now', '2-Next', '3-Soon', '4-Later', '5-Someday') })
            $states = @($labels | Where-Object { $_ -in @('state:ready', 'state:running', '6-Waiting', 'state:review', 'state:failed') })
            if ($horizons.Count -gt 1) { $errors.Add('Choose at most one horizon from 1-Now through 5-Someday.') }
            if ($states.Count -gt 1) { $errors.Add('Choose at most one execution state, including 6-Waiting.') }
            $metadata = Get-ActionDates -Body ([string]$Issue['body'])
            $errors.AddRange([string[]]$metadata.Errors)
            $dates = @($metadata.Dates.Values | Where-Object { $null -ne $_ } | Sort-Object DayNumber)
            if ($dates.Count -gt 0) { $attentionDate = $dates[0] }
        }

        if ($errors.Count -gt 0) {
            $derived.Add($Configuration.validationLabel)
        } elseif ($isProject) {
            $derived.Add($view.projects)
        } else {
            $offset = if ($null -ne $attentionDate) { $attentionDate.DayNumber - $today.DayNumber } else { $null }
            $nowLabel = $labels -contains '1-Now'
            $nextLabel = $labels -contains '2-Next'
            $soonLabel = $labels -contains '3-Soon'
            $laterLabel = $labels -contains '4-Later'
            $waiting = $labels -contains '6-Waiting'
            $inbox = $labels -contains 'Inbox'

            if ($inbox) { $derived.Add($view.capture) }
            if ($nowLabel -or $inbox -or ($null -ne $offset -and $offset -le 0)) { $derived.Add($view.now) }
            if (($nextLabel -or $offset -eq 1) -and -not $nowLabel) { $derived.Add($view.next) }
            if (($soonLabel -or ($null -ne $offset -and $offset -ge 2 -and $offset -le 6)) -and
                -not $nowLabel -and -not $nextLabel) { $derived.Add($view.soon) }
            if (($laterLabel -or ($null -ne $offset -and $offset -ge 7 -and $offset -le 29)) -and
                -not $nowLabel -and -not $nextLabel -and -not $soonLabel) { $derived.Add($view.later) }
            if (($labels -contains '5-Someday' -or $null -eq $attentionDate) -and
                -not ($nowLabel -or $nextLabel -or $soonLabel -or $laterLabel -or $waiting)) { $derived.Add($view.someday) }
            if ($waiting) { $derived.Add($view.waiting) }
        }
    }

    return [pscustomobject]@{
        Labels = @($derived.ToArray())
        Errors = @($errors.ToArray())
        Today = $today.ToString('yyyy-MM-dd')
        AttentionDate = if ($null -ne $attentionDate) { $attentionDate.ToString('yyyy-MM-dd') } else { $null }
    }
}

function Get-ActionLabelDelta {
    param(
        [AllowEmptyCollection()][string[]]$CurrentLabels = @(),
        [AllowEmptyCollection()][string[]]$DesiredLabels = @(),
        [Parameter(Mandatory)][string[]]$ManagedLabels
    )
    if (@($DesiredLabels | Where-Object { $_ -notin $ManagedLabels }).Count -gt 0) {
        throw 'The reconciler may only write configured derived labels.'
    }
    return [pscustomobject]@{
        Add = @($DesiredLabels | Where-Object { $_ -notin $CurrentLabels })
        Remove = @($CurrentLabels | Where-Object { $_ -in $ManagedLabels -and $_ -notin $DesiredLabels })
    }
}

function Get-ActionSourceFingerprint {
    param(
        [Parameter(Mandatory)][hashtable]$Issue,
        [Parameter(Mandatory)][string[]]$ManagedLabels
    )
    $source = [ordered]@{
        body = $Issue['body']
        state = $Issue['state']
        labels = @(Get-IssueLabelNames $Issue | ForEach-Object { $_ } |
            Where-Object { $_ -notin $ManagedLabels } | Sort-Object)
    }
    $bytes = [Text.Encoding]::UTF8.GetBytes(($source | ConvertTo-Json -Compress -Depth 10))
    return [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes))
}

function Invoke-WorkActionsGh {
    param(
        [Parameter(Mandatory)][string[]]$Arguments,
        [AllowNull()][object]$InputObject
    )
    $PSNativeCommandUseErrorActionPreference = $false
    if ($PSBoundParameters.ContainsKey('InputObject')) {
        $output = $InputObject | ConvertTo-Json -Depth 100 -Compress | & gh @Arguments 2>&1
    } else {
        $output = & gh @Arguments 2>&1
    }
    $text = ($output | ForEach-Object { $_.ToString() }) -join "`n"
    if ($LASTEXITCODE -ne 0) { throw "GitHub CLI failed (exit $LASTEXITCODE): $text" }
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }
    $result = ConvertFrom-Json -InputObject $text -AsHashtable -Depth 100 -NoEnumerate
    if ($result -is [hashtable] -and $result.ContainsKey('errors')) {
        throw "GitHub GraphQL returned errors: $($result.errors | ConvertTo-Json -Compress -Depth 20)"
    }
    return ,$result
}

Export-ModuleMember -Function Get-ActionConfiguration, Get-IssueLabelNames,
    Get-ManagedActionLabels, Get-ActionViewResult, Get-ActionLabelDelta,
    Get-ActionSourceFingerprint, Invoke-WorkActionsGh
