# Repository validation

From the repository root, with Git and PowerShell 7.2+ available:

```powershell
pwsh -NoProfile -File .\scripts\validate-repository.ps1
git diff --check
```

Package-specific helper isolation checks for `work-actions` run separately with `pwsh -NoProfile -File .\scripts\test-work-actions-plugin.ps1` (synthetic fixtures, faked `gh`, no live GitHub access).

The optional workspace migration helper has a separate synthetic-fixture test: `pwsh -NoProfile -File .\scripts\test-workspace-migration-helper.ps1`. It executes the helper only against disposable temporary directories outside the repository package; it does not exercise a real workspace or authorise a migration.

The script is read-only, uses no downloaded modules or services, and resolves the repository from its own location. It checks tracked and non-ignored untracked files, so newly added documentation is included before staging. It prints failures and exits nonzero; it does not repair files, install the plugin or publish anything.

## Automated scope

The pull-request workflow in [repository-validation.yml](../.github/workflows/repository-validation.yml) runs the repository validator, both isolated helper tests and a whitespace comparison against the PR base on Windows. The GitHub Actions job `Repository validation` is required by the `main` ruleset as observed on 27 October 2026; see the [configuration record](repository-configuration.md#observed-configuration-on-27-october-2026). This does not replace owner review, public-content review or runtime checks outside the workflow's scope.

| Check | Coverage |
|---|---|
| JSON and package discovery | Parse catalogue and plugin JSON; check required identity and MIT licence fields, plugin semantic versions, matching catalogue/manifest descriptions, unique catalogue names/sources, in-repository sources, manifest/name agreement and catalogue coverage of plugin manifests. Reject duplicate version declarations in catalogue plugin entries and configurable skill paths. |
| Skills and architecture | Check discovery, names, nonempty runtime-dependencies metadata, architecture/version agreement and ownership. Scripted skills declare PowerShell 7.2+; Action Ledger additionally declares `gh`. Skills without bundled scripts still declare required client capabilities and conditional dependencies; lack of scripts does not imply `none`. |
| Governed templates | For assets that already declare `template`, check its identifier/version and the owning skill in both provenance placeholders. Assets without that field are not assigned a new schema. |
| Markdown | Check inline link/image destinations and reference-definition destinations outside fenced or inline code. Resolve URI-encoded relative or repository-root paths, check file-name case and simple ATX heading fragments (including duplicate heading suffixes). Fenced examples are not expected to exist as repository files. |
| ADR index | Check that every numbered ADR is listed once, has a matching number/title/status and uses a documented status. A superseded ADR must name an existing target, and that target must refer back to it as superseded. No acceptance or rejection is inferred. |
| Migration and PowerShell | Check the exact seven-root architecture, matching helper root names, stale active plugin folder names and PowerShell parser errors. The dedicated migration test separately executes the optional helper against disposable synthetic paths. |

These are selected repository invariants, not full remote JSON-schema, YAML or CommonMark validation. The scalar metadata checks follow the existing frontmatter layout, not arbitrary YAML syntax. The Actions workflow is reviewed as source but is not parsed or executed by this checker. Markdown checking supports the forms used here, not every extension: Setext headings, HTML link/anchor syntax and complex nested link syntax are outside its scope. External URLs are not fetched. Update the checker alongside an intentionally changed convention rather than treating it as an independent architecture authority.

## Review and behavioural evidence

Read the diff and follow [Governance](../GOVERNANCE.md) and the [pull request checklist](../.github/pull_request_template.md). The checks cannot establish that prose is consistent in meaning, that no private material is present, or that an agent follows the instructions.

For visitor-facing documentation, follow the README routes through each plugin overview to its skill sources and installation guidance. Check that every marketplace plugin and skill is discoverable, examples agree with the source instructions and are labelled as illustrations, and current versions are linked rather than copied. Preserve existing installation and update anchors when reorganising the README.

For a behavioural change, use focused anonymised scenarios in a separate disposable target, never governed workspace folders in this repository. Select from the current skills' completion checks:

| Change | Useful scenario and expected boundary |
|---|---|
| Workspace setup or repair | Initialise a named blank target, then repeat. Requested roots/controls exist once, repetition makes no changes, and no specialist records appear. |
| Meeting refresh or capture | Use a bounded named occurrence and a source gap. Preserve identity and existing notes, report Not captured items, avoid unrelated roots/profiles, and create no new files on an unchanged repeat. |
| Meeting retrieval recovery | Trace a fictional 48 MiB deck beyond an inline binary cap, a complete host-retained tool result, truncated base64 with no recoverable full result, a large email attachment whose complete output the host saved to a file, an unsupported entity path, a throttled source and a known source omitted by semantic search. Include configured on-demand mail and SharePoint/OneDrive tools not initially loaded. Expect discovery of relevant already-authorised toolsets and their schemas once, exact identity resolution, the saved output parsed as JSON before decoding, available non-interactive alternatives in the same run without a generic reprompt, bounded retries, no reconstruction from previews, and other sources completed independently. A WorkIQ limit must not skip a suitable dedicated provider route or trigger browser use. |
| Original-file transfer and remaining gaps | Review the routes in order for a fictional large deck: a provider tool, a returned self-authorising URL, a configured file-scoped API/CLI, then the last-resort browser routes. Include a URL a plain client cannot use (`401`/`403` or sign-in page), an unsuitable CLI token, a remote-server output path, expired URL, interrupted file, sign-in HTML, ignored byte range, changed source version, protection-wrapped file, missing sign-in or approval, a URL found in chat content and a genuine source denial. Expect no browser launch or automation when a provider/direct/API route succeeds, and a recorded concrete reason for each applicable non-interactive route before any browser use (including a URL launched from the shell). A credential mismatch is not a source denial; a denial from a correctly authenticated file-scoped tool stops attempts without browser confirmation. Last-resort downloads poll the resolved downloads folder, move only the verified new file without overwrite, and defer when active user input blocks safe interaction; no forced focus or shell workaround after an automation refusal. Expect verified size, container integrity and provider hash, or a stated reason for none; no persisted credentials/temporary URLs, automatic install, consent, account change or launch of content-sourced URLs. Distinguish Not-captured-locally from online review. A current deck is not proof of the event-day version; an unchanged repeat reuses verified evidence. |
| Stakeholder evidence or profiles | Use supplied sources without a meeting archive, including insufficient evidence. Produce only supported profiles or an explicit partial result; do not collect meetings or invent endorsement. |
| Stakeholder profile grounding | Use a fictional project with an organisation, a Microsoft employee and an external counterpart; a transcript plus a presentation that corrects it; project-relevant and wider-context evidence; one transactional contribution; a retained report that cannot be read and a pointer to material outside the project; and an existing profile of a Microsoft employee. Expect no Microsoft profile and the existing one flagged, not changed; document content read or named as unread; project-relevant evidence first; a short provisional profile for thin evidence; no external research or link-following without authorisation; no meeting collection. An unchanged repeat creates no files; a repeat after one changed source updates only the affected profile. |
| Stable workspace signposts | Initialise a fictional workspace and repeat unchanged. Expect a concise folder-role map and root `AGENTS.md`, both with template and skill provenance; no project narrative, file/entity inventory, status, evidence cutoff or review date. Adding meetings, profiles, sources or outputs must not require a signpost edit or handoff. An existing signpost with a newer template version remains unchanged absent an explicitly authorised upgrade; any approved upgrade preserves `created_by` and user additions. |
| Shared reference or template | Exercise each consuming skill affected by the change, not only the edited file. Preserve provenance and existing-workspace behaviour. |
| File-operation tool choice | Review a direct folder rename, an approved create/move/empty-cleanup mapping, a conflicting destination, hidden content left in an old folder, a helper refusal and a provider restriction. Expect filesystem tools by default, no overwrite or nonempty-folder deletion, no GUI fallback, and a provider tool or explicit blocker only where needed. Review all three consumers of Common Architecture. |

These are review scenarios, not an automated agent test suite or new skill behaviour. Documentation/tooling-only changes need repository checks and diff review, not a claim of live skill execution.

For [repository configuration](repository-configuration.md) documentation, distinguish the intended baseline and dated settings observations from current effective enforcement. The repository script checks links and ADR consistency, not GitHub settings. Use the guide's authorised read-only inspection when recording observations; report unavailable surfaces rather than assuming absence. Settings writes and enforcement exercises require separate authority and must not be claimed from static validation alone.

## Static-only changes and public disclosure

The seven-root and project-evidence guidance is validated by repository consistency and manual instruction review only; do not execute skills, real workspace operations or live source retrieval as part of repository validation. The dedicated migration test executes the optional helper only against synthetic temporary targets. The `work-actions` isolation test executes that package's helpers against synthetic fixtures with a faked `gh`. Neither test exercises live GitHub, actual workspaces, client behaviour, collaboration, cloud moves or shared-link preservation. Static success is not an operational safety guarantee.

Review changed instructions, templates, JSON examples, scripts and links together. Check routing, approval boundaries, helper/plan/journal fields, dependency declarations, versions, legacy compatibility and honest partial outcomes. Search old names throughout the repository, distinguishing historical ADRs and explicit migration examples from active defaults.

This public package must not contain employer/customer proprietary material, identifiable case narratives, personal profiles, private URLs, tenant IDs, real inventories or source captures. Use fictional paths and explicit observed-value placeholders. Preserve functional private-workspace input contracts: actual source identity is supplied at runtime, not replaced with fabricated evidence. Product names and public documentation links are not inherently proprietary.

Record exact commands/results and manual disclosure-review scope in the handoff. Automated checks do not prove the absence of proprietary content. No private example workspace is required or modified.

For a plugin change, separately record the marketplace's tracked ref and the authorised installation/new-session check required after merge. Local static checks do not prove installation, client discovery, remote retrieval, publication or automatic updates. Record exact commands and results, checks not run, and any migration implications; do not turn an unperformed check into a pass.
