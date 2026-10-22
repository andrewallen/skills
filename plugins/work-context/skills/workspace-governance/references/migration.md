# Migration contract

Load Common Architecture first. The destination is the seven-root baseline, not a permanent interpretation of the old layout. Assessment is read-only; planning writes only when authorised. Keep private inventories and progress outside the public plugin repository.

## Assess and plan

Read applicable instructions. Inventory the confirmed project boundary without recursively following shortcuts or reparse points. Identify coherent collections, versions, source origins, explicit distribution evidence, unreadable items, nested repositories and application-managed content. Do not infer issue from filenames or classification from content markings.

Prepare the [plan](../assets/migration-plan.md) with current paths, exact destinations, keep/move/register/reference/defer actions, reasons, risk and dependencies. Preserve collections inside the appropriate core. Plan reference repairs separately from source moves; received originals and other owners' substantive records remain untouched. Shorten paths through sensible structure, not silent filename abbreviation.

Plan all seven roots and minimal controls. Include an inventory reconciliation: every scoped item is accounted for, including excluded or unresolved content and old empty containers. No automatic deletion or duplicate removal. Removing empty retired containers requires an explicit separately approved cleanup action through an appropriate tool; otherwise their continued existence is reported as a gap.

Obtain approval for this exact plan. A structural approval does not grant permissions, approve content, issue documents, authorise another skill or bypass tool confirmations. Meaning-changing decisions require owner resolution. Do not repeatedly ask about routine actions already approved.

## Apply, resume and verify

One coordinator owns migration writes. Check source identity/state immediately before each action and destination before creation. Revalidate shared progress and concurrent changes; a journal is not a lock against other users or agents. Pause a dependent group on drift; independent groups may proceed. Never overwrite a destination, even for identical bytes. Preserve non-identical versions.

Retain approved plan identity, source/destination, observed fingerprints and progress after each action. Resume that plan, not fresh classification. Interrupted moves need source/destination inspection; never repeat a move or unconditionally roll it back. Recovery or reverse moves require current-state checks and authority.

Verify:

- all seven roots exist and no conflicting legacy filing roots remain;
- every scoped item is preserved, intentionally excluded or an explicit blocker;
- approved owned links and issued identities resolve;
- evidence IDs, timestamps, owner notes and historical provenance survive;
- source retention and semantic review are not conflated;
- deferred items, cloud limitations and unresolved references are reported.

Report complete only when the full approved scope and baseline pass. Do not call a partial move or successful helper invocation a complete migration.

## Local helper boundary

[Invoke-WorkspaceMigration.ps1](../scripts/Invoke-WorkspaceMigration.ps1) requires PowerShell 7.2+, no `gh`, and works only with ordinary local files. It does not classify content, bootstrap controls, edit links, delete empty folders, move directories or migrate cloud storage. It rejects reparse/recall/offline paths and protected collections rather than attempting hydration or bypass.

Generate its JSON input only after inspection; hashes and modification times must be observed, not invented. Every operation is an independent file move. Dependency groups, cloud moves and approved reference edits use a separate supported route; do not flatten dependencies into this helper.

```powershell
# Fictional paths. Substitute the installed skill path and an authorised target.
pwsh -NoProfile -File "<skill-path>\scripts\Invoke-WorkspaceMigration.ps1" `
  -TargetPath "C:\Projects\Example" -PlanPath "C:\Plans\example.json"

# Only after approval of the exact displayed SHA-256 plan digest:
pwsh -NoProfile -File "<skill-path>\scripts\Invoke-WorkspaceMigration.ps1" `
  -TargetPath "C:\Projects\Example" -PlanPath "C:\Plans\example.json" `
  -Apply -ApprovedPlanHash "<observed-plan-sha256>"
```

Preview performs local identity checks without writes. Apply/resume uses the same arguments and exact plan digest. The journal is under `Governance\Migration`; it records only operational metadata and is atomically replaced. Do not manually edit or delete it to force progress. Verification runs after approved operations and reports unresolved entries, retired paths or missing core roots as partial. A helper error stops this local batch; the coordinator may proceed only with independent separately planned groups.

For cloud/shared material use authorised platform-aware operations, preserving item identity, version and known links. If preservation cannot be established, defer rather than claim success. Never change sharing or permissions. A copy of a shared workspace is not proof that its original links will survive.

## Evidence and disclosure

Keep public examples fictional. Do not copy customer or employer documents, names, private links, tenant IDs, live file inventories or captured conversations into this package. Real source identity remains functional data in the explicitly authorised private target. Sanitise reports intended for public use without changing retained source evidence.
