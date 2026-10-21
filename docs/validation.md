# Repository validation

From the repository root, with Git and PowerShell 7 available:

```powershell
pwsh -NoProfile -File .\scripts\validate-repository.ps1
git diff --check
```

Package-specific helper isolation checks for `work-actions` run separately with `pwsh -NoProfile -File .\scripts\test-work-actions-plugin.ps1` (synthetic fixtures, faked `gh`, no live GitHub access).

The script is read-only, uses no downloaded modules or services, and resolves the repository from its own location. It checks tracked and non-ignored untracked files, so newly added documentation is included before staging. It prints failures and exits nonzero; it does not repair files, install the plugin or publish anything.

## Automated scope

| Check | Coverage |
|---|---|
| JSON and package discovery | Parse catalogue and plugin JSON; check required identity fields, plugin semantic versions, unique catalogue names/sources, in-repository sources, manifest/name agreement and catalogue coverage of plugin manifests. Reject duplicate version declarations in catalogue plugin entries and configurable skill paths. |
| Skills and architecture | Check immediate skill discovery, directory/name agreement, current scalar metadata conventions (`runtime-dependencies` must be `none` unless the skill bundles `scripts`, then it must name PowerShell 7.2+ and `gh`), shared architecture role/version agreement and the Common Architecture ownership table's skill names. |
| Governed templates | For assets that already declare `template`, check its identifier/version and the owning skill in both provenance placeholders. Assets without that field are not assigned a new schema. |
| Markdown | Check inline link/image destinations and reference-definition destinations outside fenced or inline code. Resolve URI-encoded relative or repository-root paths, check file-name case and simple ATX heading fragments (including duplicate heading suffixes). Fenced examples are not expected to exist as repository files. |
| ADR index | Check that every numbered ADR is listed once, has a matching number/title/status and uses a documented status. No acceptance or rejection is inferred. |

These are selected repository invariants, not full remote JSON-schema, YAML or CommonMark validation. The scalar metadata checks follow the existing frontmatter layout, not arbitrary YAML syntax. Markdown checking supports the forms used here, not every extension: Setext headings, HTML link/anchor syntax and complex nested link syntax are outside its scope. External URLs are not fetched. Update the checker alongside an intentionally changed convention rather than treating it as an independent architecture authority.

## Review and behavioural evidence

Read the diff and follow [Governance](../GOVERNANCE.md) and the [pull request checklist](../.github/pull_request_template.md). The checks cannot establish that prose is consistent in meaning, that no private material is present, or that an agent follows the instructions.

For a behavioural change, use focused anonymised scenarios in a separate disposable target, never governed workspace folders in this repository. Select from the current skills' completion checks:

| Change | Useful scenario and expected boundary |
|---|---|
| Workspace setup or repair | Initialise a named blank target, then repeat. Requested roots/controls exist once, repetition makes no changes, and no specialist records appear. |
| Meeting refresh or capture | Use a bounded named occurrence and a source gap. Preserve identity and existing notes, report Not captured items, avoid unrelated roots/profiles, and create no new files on an unchanged repeat. |
| Stakeholder evidence or profiles | Use supplied sources without a meeting archive, including insufficient evidence. Produce only supported profiles or an explicit partial result; do not collect meetings or invent endorsement. |
| Shared reference or template | Exercise each consuming skill affected by the change, not only the edited file. Preserve provenance and existing-workspace behaviour. |

These are review scenarios, not an automated agent test suite or new skill behaviour. Documentation/tooling-only changes need repository checks and diff review, not a claim of live skill execution.

For a plugin change, separately record the marketplace's tracked ref and the authorised installation/new-session check required after merge. Local static checks do not prove installation, client discovery, remote retrieval, publication or automatic updates. Record exact commands and results, checks not run, and any migration implications; do not turn an unperformed check into a pass.
