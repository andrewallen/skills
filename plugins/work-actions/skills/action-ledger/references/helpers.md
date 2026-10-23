# Bundled helpers and target resolution

The [scripts](../scripts) are the single canonical implementation, maintained
in `andrewallen/skills`. A ledger repository may keep a version-pinned vendored
copy of these scripts for offline use; the copy is not a second source. They
work when only `plugins/work-actions` is copied elsewhere and never import
files outside that package. Target configuration and label definitions are
inputs from the explicitly named ledger, not package defaults.

## Prerequisites and boundary

PowerShell **7.2+** and authenticated **GitHub CLI (`gh`)** must already be
available. Use approved existing access to github.com. These helpers do not
install dependencies or acquire permissions. They reject a different `GH_HOST`
rather than silently sending requests to another host.

For every bundled entry point, supply both an **absolute** `-TargetPath` and
`-Repository owner/name`. The path must be an existing ledger checkout outside
the installed plugin directory. It must contain `.github/work-actions.json`
whose repository matches the explicit selection. Never copy the source
configuration into an unrelated target and leave its repository/Project IDs
unchanged. Read the target policy and confirm its approved Project separately.
There is no implicit bootstrap or record migration.

Use the actual installed skill path in place of `<skill-path>`, the actual
approved target checkout in place of `C:\Ledgers\example`, and the explicitly
resolved repository in place of `owner/ledger`:

```powershell
# Preview only: no label/comment writes.
pwsh -NoProfile -File "<skill-path>\scripts\Sync-ActionViews.ps1" `
  -TargetPath "C:\Ledgers\example" -Repository "owner/ledger" -IssueNumber 17

# Only with authority to refresh this issue's derived metadata.
pwsh -NoProfile -File "<skill-path>\scripts\Sync-ActionViews.ps1" `
  -TargetPath "C:\Ledgers\example" -Repository "owner/ledger" -IssueNumber 17 -Apply
```

Omit `-IssueNumber` for full refresh, including daily date-boundary review and
cleanup of closed records' derived labels. `-Now` is a deterministic test
input; use the real current time for operational refresh.

| Entry point | Reads / possible writes with `-Apply` |
|---|---|
| `Sync-ActionViews.ps1` | Target configuration and issues; configured derived labels and validation comments only |
| `Initialize-WorkActions.ps1` | Target configuration and `.github/labels.json`; create/update those label definitions, never delete labels |
| `Sync-ActionProject.ps1` | Target configuration and configured private Project; maintain named views, Project presentation/link and issue membership |

All preview by default. `-Apply` permits writes but does not supply user
authority. Setup/Project maintenance are not routine execution or permission
changes. Project sync stops if the configured Project is inaccessible/public;
it does not create a Project or change its visibility/access. Current Project
configuration remains required for that operation; the Proposed
Projects-optional ADR is not implemented by packaging.

`Sync-ActionProject.ps1` maintains the All actions view, the eight configured
attention views and any entries in the optional `extraViews` array of
`.github/work-actions.json`. Omit `extraViews`, or set it to `[]`, when no
further views are needed. Each entry is an object with a `name` and an optional
`label`: a `label` limits that view to open issues carrying it; without one it
shows every issue in the repository.

A ledger repository's own root commands, if any, select that checkout
explicitly and forward to an implementation. Do not invoke them as an
installed skill or assume they exist in another target.

## Other approved GitHub tools / missing helpers

Ordinary issue reading, capture, source edits, bounded execution and handoffs
can use the client's approved MCP/API/CLI tools; PowerShell/gh are not mandatory
for those record operations. Preserve the same templates, target resolution,
coordination, tool confirmations, human ownership and acceptance rules.

If the checkout/configuration, PowerShell, gh or required access is unavailable,
do not install anything, substitute another repository, hand-edit computed
labels, or claim refresh succeeded. Leave source changes and the real execution
state on the same issue and report: target, issue(s), source change, failed or
unavailable command, actual error, **computed views not refreshed**, and the
coordinator's next refresh step. A missing refresh alone is not failed task
execution; name the dependency accurately. Only report views current after a
successful approved refresh, with its scope and observation time.
