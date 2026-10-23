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
$query = @'
query($project: ID!) {
  node(id: $project) {
    ... on ProjectV2 {
      id title public
      fields(first: 100) {
        nodes {
          ... on ProjectV2Field { id name }
          ... on ProjectV2SingleSelectField { id name }
        }
      }
      views(first: 100) { nodes { id name } }
    }
  }
}
'@
$response = Invoke-WorkActionsGh -Arguments @('api', 'graphql', '--input', '-') -InputObject @{
    query = $query; variables = @{ project = $config.project.id }
}
$project = $response.data.node
if ($null -eq $project -or $project['id'] -ne $config.project.id) { throw 'The configured Project is not accessible.' }
if ($project.public) { throw 'The configured Project is public. Stop and resolve its approved data boundary before adding work.' }
$fields = @()
foreach ($name in @('Title', 'Labels', 'Assignees')) {
    $matches = @($project.fields.nodes | Where-Object { $_.name -eq $name })
    if ($matches.Count -ne 1) { throw "Expected exactly one Project field named '$name'." }
    $fields += $matches[0].id
}

$views = @(@{ name = 'All actions'; id = $config.project.allActionsViewId }) + $config.views + $config.extraViews
foreach ($view in $views) {
    $filter = "is:issue repo:$($config.repository)"
    if ($view.ContainsKey('label')) { $filter += " is:open label:`"$($view.label)`"" }
    $matches = @($project.views.nodes | Where-Object {
        if ($view.ContainsKey('id')) { $_.id -eq $view.id } else { $_.name -eq $view.name }
    })
    if ($matches.Count -gt 1) { throw "More than one Project view is named '$($view.name)'; resolve it rather than guessing." }
    if ($view.ContainsKey('id') -and $matches.Count -ne 1) { throw 'The configured All actions view is missing; inspect the Project configuration.' }
    Write-Host "View '$($view.name)': $filter"
    if (-not $Apply) { continue }
    if ($matches.Count -eq 0) {
        $created = Invoke-WorkActionsGh -Arguments @('api', 'graphql', '--input', '-') -InputObject @{
            query = 'mutation($input: CreateProjectV2ViewInput!) { createProjectV2View(input: $input) { projectV2View { id } } }'
            variables = @{ input = @{ projectId = $project.id; name = $view.name; layout = 'TABLE_LAYOUT' } }
        }
        $viewId = $created.data.createProjectV2View.projectV2View.id
    } else {
        $viewId = $matches[0].id
    }
    $null = Invoke-WorkActionsGh -Arguments @('api', 'graphql', '--input', '-') -InputObject @{
        query = 'mutation($input: UpdateProjectV2ViewInput!) { updateProjectV2View(input: $input) { projectV2View { id name filter } } }'
        variables = @{
            input = @{
                viewId = $viewId; name = $view.name; layout = 'TABLE_LAYOUT'; filter = $filter
                configuration = @{ visibleFieldIds = $fields }
            }
        }
    }
}

if ($Apply) {
    $null = Invoke-WorkActionsGh -Arguments @('project', 'link', [string]$config.project.number, '--owner', $config.project.owner, '--repo', $config.repository)
    $readme = @"
One issue per action. Human accountability stays with the assignee; executor and run links belong in issue updates.

Use the saved attention views to choose work and the decision, running, and failure views to oversee agents. Labels are authoritative; the native Project Status field is intentionally hidden.

Dates use the configured time zone. Refresh is manual unless this repository's owner has separately approved and configured an automation workflow. A merge or Project setup does not enable automation.

Follow this ledger repository's own governance, issue template and operating guidance where present. This Project description does not create policy or link to files that may not exist here.

Forms add issues here when the creator has Project write access. API-created issues need an explicit Project add step. This is a shared ledger, not an automatic agent dispatcher.
"@
    $null = Invoke-WorkActionsGh -Arguments @(
        'project', 'edit', [string]$config.project.number, '--owner', $config.project.owner,
        '--description', 'Human attention, shared next actions, and explicit agent handoffs.',
        '--readme', $readme, '--format', 'json'
    )
}

$pages = Invoke-WorkActionsGh -Arguments @('api', "repos/$($config.repository)/issues?state=all&per_page=100", '--paginate', '--slurp')
foreach ($page in $pages) {
    foreach ($issue in $page) {
        if ($issue.ContainsKey('pull_request')) { continue }
        $labels = Get-IssueLabelNames $issue
        if ('kind:action' -notin $labels -and 'Project' -notin $labels) { continue }
        Write-Host "Ensure issue #$($issue.number) belongs to the Project."
        if ($Apply) {
            $null = Invoke-WorkActionsGh -Arguments @(
                'project', 'item-add', [string]$config.project.number,
                '--owner', $config.project.owner, '--url', $issue.html_url, '--format', 'json'
            )
        }
    }
}
if (-not $Apply) { Write-Host 'Preview only. Re-run with -Apply to write these changes.' }
