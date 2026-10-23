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

`Sync-ActionViews.ps1` and `Sync-ActionProject.ps1` use `gh api --paginate
--slurp`; use a GitHub CLI release that supports both flags. Project
initialisation and synchronisation also require the `project` authentication
scope and access to the configured private Project. Check `gh auth status` and
the target's Project permissions before applying changes. No helper adds
scopes, grants access or creates the Project.

The view-refresh helper inspects every open non-pull-request issue and flags
records without valid action or parent-Project metadata. Its target repository
must therefore be a dedicated action ledger, not a general-purpose issue
tracker. The interactive skill can still operate on one explicitly named
action issue without running a repository-wide refresh.

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
configuration remains required for that operation; no Projects-optional mode
is implemented.

`Sync-ActionProject.ps1` maintains the All actions view, the eight configured
attention views and any entries in the optional `extraViews` array of
`.github/work-actions.json`. Omit `extraViews`, or set it to `[]`, when no
further views are needed. Each entry has only a non-empty `name` and optional
non-empty `label`: a `label` limits that view to open issues carrying it;
without one it shows every issue in the repository. Do not set an `id` on an
extra view; `id` is reserved for the configured All actions view.

Every entry point validates `extraViews` before any GitHub request and stops on
a malformed value. It must be an array of objects. Each `name` must be a
non-empty string and each `label`, if present, a non-empty string without
quotes or control characters. Names must be unique, ignoring case, across
`All actions`, the eight configured views and the other entries, because the
Project script matches existing views by name. `Sync-ActionViews.ps1` derives
only the configured attention labels and the validation label, so an extra
view should filter on a label that people or agents apply, such as
`state:review`.

## Target configuration

The ledger owns both files below; the fixtures in this repository are
synthetic examples, not defaults to copy with their repository or Project IDs.

`.github/work-actions.json` is a JSON object with:

| Field | Shape and purpose |
|---|---|
| `repository` | `owner/name`, matching the explicitly selected ledger. |
| `timeZone` | A system time-zone ID used for calendar-date boundaries. |
| `project` | Object with `owner`, numeric `number`, GraphQL `id`, `url`, and `allActionsViewId`. Keep the configured Project private and verify access before use. |
| `validationLabel` | The exact managed validation label `automation:needs-fix`. |
| `views` | The eight required entries; each has a `key`, display `name` and unique `view:*` `label`. |
| `extraViews` | Optional array of objects with unique `name` and optional `label`; omit it or use `[]` when not needed. |

`.github/labels.json` is an array of label definitions, each with a `name`,
six-character hexadecimal `color` (without `#`) and `description`. Setup
creates missing labels and repairs matching definitions; it does not delete
labels.

Use this order: review the target policy and configuration, initialise labels,
preview and apply issue-view reconciliation as authorised, then preview and
apply Project view/link/membership maintenance as separately authorised.
These operations are not a bootstrap or permission grant.

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
