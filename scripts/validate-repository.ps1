#Requires -Version 7.0
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path $PSScriptRoot -Parent
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Repository($condition, [string] $message) {
    if (-not $condition) { $failures.Add($message) }
}

function Read-Json([string] $path) {
    try {
        $text = Get-Content -LiteralPath $path -Raw
        if (-not (Test-Json -Json $text -ErrorAction SilentlyContinue)) {
            throw 'Invalid JSON syntax.'
        }
        $value = ConvertFrom-Json -InputObject $text -AsHashtable
        if ($value -isnot [System.Collections.IDictionary]) { throw 'Expected a JSON object.' }
        return $value
    } catch {
        $failures.Add("${path}: $($_.Exception.Message)")
    }
}

function Get-Scalar([string] $text, [string] $key, [int] $indent = 0) {
    $pattern = '(?m)^' + (' ' * $indent) + [regex]::Escape($key) + ':[ \t]*([^\r\n]+)'
    $match = [regex]::Match($text, $pattern)
    return $match.Groups[1].Value.Trim().Trim('"').Trim("'")
}

function Get-Frontmatter([string] $text) {
    return [regex]::Match($text, '\A---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)').Groups[1].Value
}

function Get-Markdown([string] $path) {
    $fence = ''
    $lines = foreach ($line in Get-Content -LiteralPath $path) {
        if ($line -match '^[ ]{0,3}(`{3,}|~{3,})') {
            $marker = $Matches[1]
            if (-not $fence) { $fence = $marker }
            elseif ($marker[0] -ceq $fence[0] -and $marker.Length -ge $fence.Length -and
                $line.Trim() -ceq $marker) { $fence = '' }
            ''
        } elseif ($fence) { '' } else { $line }
    }
    return $lines -join "`n"
}

function Get-Anchors([string] $text) {
    $anchors = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($heading in [regex]::Matches($text, '(?m)^ {0,3}#{1,6}\s+(.+?)\s*#*\s*$')) {
        $slug = $heading.Groups[1].Value.ToLowerInvariant() -replace '<[^>]*>', ''
        $slug = $slug -replace '[^\p{L}\p{Nd}_\- ]', '' -replace ' ', '-'
        $anchor = $slug
        $suffix = 0
        while (-not $anchors.Add($anchor)) { $suffix++; $anchor = "$slug-$suffix" }
    }
    return ,$anchors
}

$files = @(git -C $root ls-files --cached --others --exclude-standard)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate repository files with git ls-files.' }
$fileSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
foreach ($file in $files) { [void] $fileSet.Add($file) }
$markdown = @{}
$anchors = @{}
foreach ($file in $files | Where-Object { $_ -like '*.md' }) {
    $path = Join-Path $root $file
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures.Add("${file}: tracked file is missing; stage an intended deletion.")
        continue
    }
    $markdown[$file] = Get-Markdown $path
    $anchors[$file] = Get-Anchors $markdown[$file]
}

$linkPattern = '!?\[[^\]\r\n]*\]\((?<target>[^)\r\n]+)\)|(?m:^[ ]{0,3}\[[^\]\r\n]+\]:[ \t]*(?<target><[^>]+>|\S+))'
foreach ($file in $markdown.Keys) {
    $text = $markdown[$file] -replace '`+[^`\r\n]*`+', ''
    foreach ($link in [regex]::Matches($text, $linkPattern)) {
        $target = ($link.Groups['target'].Value.Trim() -replace '\s+["''][^"'']*["'']$', '').Trim('<', '>')
        if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:|^//') { continue }
        $parts = $target -split '#', 2
        $local = [uri]::UnescapeDataString($parts[0])
        $path = if (-not $local) { Join-Path $root $file }
            elseif ($local.StartsWith('/')) { Join-Path $root $local.TrimStart('/') }
            else { Join-Path (Split-Path (Join-Path $root $file) -Parent) $local }
        $relative = [IO.Path]::GetRelativePath($root, [IO.Path]::GetFullPath($path)).Replace('\', '/')
        if ($relative -eq '..' -or $relative.StartsWith('../') -or
            -not (Test-Path -LiteralPath $path)) {
            $failures.Add("${file}: broken or out-of-repository link '$target'.")
            continue
        }
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Assert-Repository ($fileSet.Contains($relative)) "${file}: link '$target' has incorrect case or targets an ignored file."
        }
        if ($parts.Count -eq 2 -and $parts[1] -and $relative -like '*.md') {
            $fragment = [uri]::UnescapeDataString($parts[1])
            Assert-Repository ($anchors.ContainsKey($relative) -and $anchors[$relative].Contains($fragment)) "${file}: missing heading '$target'."
        }
    }
}

$catalogue = Read-Json (Join-Path $root '.github\plugin\marketplace.json')
$sources = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$pluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$number = '(?:0|[1-9]\d*)'
$prerelease = '(?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*)'
$semver = "^{0}\.{0}\.{0}(?:-{1}(?:\.{1})*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$" -f $number, $prerelease
$packageCount = 0
$skillCount = 0
if ($null -ne $catalogue) {
    Assert-Repository ($catalogue['name'] -is [string] -and $catalogue['name']) 'Catalogue: missing name.'
    Assert-Repository ($catalogue['owner'] -is [System.Collections.IDictionary] -and $catalogue['owner']['name']) 'Catalogue: missing owner name.'
    Assert-Repository ($catalogue['plugins'] -is [array] -and $catalogue['plugins'].Count -gt 0) 'Catalogue: expected a nonempty plugins array.'
    foreach ($entry in @($catalogue['plugins'])) {
        if ($entry -isnot [System.Collections.IDictionary]) {
            $failures.Add('Catalogue: each plugin must be an object.')
            continue
        }
        $name = $entry['name']
        $source = $entry['source']
        Assert-Repository ($name -is [string] -and $name -cmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') 'Catalogue: invalid plugin name.'
        Assert-Repository ($pluginNames.Add([string] $name)) "Catalogue: duplicate plugin name '$name'."
        Assert-Repository (-not $entry.Contains('version') -and
            -not ($entry['metadata'] -is [System.Collections.IDictionary] -and $entry['metadata'].Contains('version'))) "Catalogue: '$name' duplicates the manifest version."
        if ($source -isnot [string] -or $source -cnotmatch '^\./plugins/[a-z0-9]+(?:-[a-z0-9]+)*$') {
            $failures.Add("Catalogue: '$name' needs a relative ./plugins/<plugin> source.")
            continue
        }
        Assert-Repository ($sources.Add($source.Substring(2))) "Catalogue: duplicate source '$source'."
        $pluginPath = Join-Path $root $source
        $manifest = Read-Json (Join-Path $pluginPath 'plugin.json')
        if ($null -eq $manifest) { continue }
        $packageCount++
        Assert-Repository ($manifest['name'] -ceq $name -and (Split-Path $pluginPath -Leaf) -ceq $name) "${source}: directory, catalogue and manifest names differ."
        Assert-Repository ($manifest['$schema'] -ceq 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json') "${source}: unexpected portable manifest schema."
        Assert-Repository ($manifest['version'] -is [string] -and $manifest['version'] -cmatch $semver) "${source}: invalid plugin version."
        Assert-Repository ($manifest['description'] -is [string] -and $manifest['description']) "${source}: missing description."
        Assert-Repository ($manifest['author'] -is [System.Collections.IDictionary] -and $manifest['author']['name']) "${source}: missing author name."
        Assert-Repository (-not $manifest.Contains('skills')) "${source}: configurable skill paths are not supported."
        $architecturePath = Join-Path $pluginPath 'Common Architecture.md'
        $architecture = if (Test-Path -LiteralPath $architecturePath) { Get-Content -LiteralPath $architecturePath -Raw } else { '' }
        $architectureMetadata = Get-Frontmatter $architecture
        $role = Get-Scalar $architectureMetadata 'document_role'
        $version = Get-Scalar $architectureMetadata 'architecture_version'
        if ($architecture) {
            Assert-Repository ($role -and $version -match '^\d+\.\d+$') "${source}: invalid architecture metadata."
        }
        $skillsPath = Join-Path $pluginPath 'skills'
        if (-not (Test-Path -LiteralPath $skillsPath -PathType Container)) {
            $failures.Add("${source}: missing skills directory.")
            continue
        }
        $skillDirectories = @(Get-ChildItem -LiteralPath $skillsPath -Directory)
        Assert-Repository ($skillDirectories.Count -gt 0) "${source}: no skills discovered."
        $skillNames = @()
        foreach ($directory in $skillDirectories) {
            $skillPath = Join-Path $directory.FullName 'SKILL.md'
            if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
                $failures.Add("$($directory.Name): missing immediate SKILL.md.")
                continue
            }
            $skillCount++
            $skill = Get-Content -LiteralPath $skillPath -Raw
            $metadata = Get-Frontmatter $skill
            $skillName = Get-Scalar $metadata 'name'
            $skillNames += $skillName
            Assert-Repository ($skillName -ceq $directory.Name) "${skillPath}: name differs from directory."
            Assert-Repository ([bool] (Get-Scalar $metadata 'description')) "${skillName}: missing description."
            Assert-Repository ($metadata -match '(?m)^metadata:\s*$' -and (Get-Scalar $metadata 'version' 2) -match '^\d+\.\d+$') "${skillName}: invalid skill metadata/version."
            $runtime = Get-Scalar $metadata 'runtime-dependencies' 2
            if (Test-Path -LiteralPath (Join-Path $directory.FullName 'scripts') -PathType Container) {
                Assert-Repository ($runtime -match 'PowerShell 7\.2\+' -and $runtime -match '\bgh\b') "${skillName}: bundled helpers must declare their PowerShell and gh prerequisites."
            } else {
                Assert-Repository ($runtime -ceq 'none') "${skillName}: expected independent runtime-dependencies metadata."
            }
            if ($architecture) {
                Assert-Repository ((Get-Scalar $metadata 'architecture' 2) -ceq "$role v$version") "${skillName}: architecture reference differs from Common Architecture."
            }
            $assetsPath = Join-Path $directory.FullName 'assets'
            if (Test-Path -LiteralPath $assetsPath) {
                foreach ($asset in Get-ChildItem -LiteralPath $assetsPath -Filter '*.md' -File -Recurse) {
                    $text = Get-Content -LiteralPath $asset.FullName -Raw
                    $template = Get-Scalar $text 'template'
                    if (-not $template) { continue }
                    Assert-Repository ($template -cmatch '^[a-z0-9]+(?:-[a-z0-9]+)*@\d+\.\d+$') "$($asset.Name): invalid template identifier/version."
                    foreach ($field in 'created_by', 'last_governed_by') {
                        Assert-Repository ((Get-Scalar $text $field) -ceq "$skillName@<CURRENT_SKILL_VERSION>") "$($asset.Name): $field differs from owning skill."
                    }
                }
            }
        }
        if ($architecture) {
            $ownership = [regex]::Match($architecture, '(?ms)^## Skill ownership\r?\n(.*?)(?=^## |\z)').Groups[1].Value
            $owners = @([regex]::Matches($ownership, '(?m)^\| `([^`]+)` \|') | ForEach-Object { $_.Groups[1].Value })
            Assert-Repository ($skillNames.Count -gt 0 -and $owners.Count -gt 0 -and
                @(Compare-Object $skillNames $owners -CaseSensitive).Count -eq 0) "${source}: ownership table and discovered skills differ."
        }
    }
}
foreach ($manifestFile in $files | Where-Object { $_ -cmatch '^plugins/[^/]+/plugin\.json$' }) {
    Assert-Repository ($sources.Contains(($manifestFile -replace '/plugin\.json$', ''))) "${manifestFile}: plugin not registered in catalogue."
}

$indexPath = 'docs/adr/README.md'
$index = $markdown[$indexPath]
$rows = @([regex]::Matches($index, '(?m)^\| \[(\d{4})\]\(([^)]+)\) \| (.+?) \| (.+?) \|$'))
$adrFiles = @($files | Where-Object { $_ -cmatch '^docs/adr/\d{4}-[^/]+\.md$' })
Assert-Repository ($rows.Count -eq $adrFiles.Count) 'ADR index: row count differs from numbered records.'
foreach ($file in $adrFiles) {
    $record = Get-Content -LiteralPath (Join-Path $root $file) -Raw
    $id = (Split-Path $file -Leaf).Substring(0, 4)
    $matchingRows = @($rows | Where-Object { $_.Groups[1].Value -ceq $id })
    Assert-Repository ($matchingRows.Count -eq 1) "${file}: expected exactly one ADR index entry."
    if ($matchingRows.Count -ne 1) { continue }
    $row = $matchingRows[0]
    $status = [regex]::Match($record, '(?m)^- Status: ([^\r\n]+)').Groups[1].Value
    $title = [regex]::Match($record, "^# ADR-${id}: ([^\r\n]+)").Groups[1].Value
    Assert-Repository ($status -cmatch '^(Proposed|Accepted|Rejected|Superseded by ADR-\d{4})$') "${file}: invalid ADR status."
    Assert-Repository ($row.Groups[2].Value -ceq (Split-Path $file -Leaf) -and $row.Groups[3].Value -ceq $title -and $row.Groups[4].Value -ceq $status) "${file}: ADR index path, title or status differs."
}

if ($failures.Count) {
    foreach ($failure in $failures) { [Console]::Error.WriteLine("FAIL: $failure") }
    [Console]::Error.WriteLine("$($failures.Count) repository check(s) failed.")
    exit 1
}
Write-Output "PASS: $packageCount plugin(s), $skillCount skill(s), $($markdown.Count) Markdown file(s), $($adrFiles.Count) ADR(s); links and repository consistency checked."
