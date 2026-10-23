# Migration contract

Load Common Architecture first. The destination is the seven-root baseline, not a permanent interpretation of the old layout. Assessment is read-only; planning writes only when authorised. Keep private inventories and progress outside the public plugin repository.

## Assess and plan

Read applicable instructions. Inventory the confirmed project boundary without recursively following shortcuts or reparse points. Identify coherent collections, versions, source origins, explicit distribution evidence, unreadable items, nested repositories and application-managed content. Do not infer issue from filenames or classification from content markings.

Prepare the [plan](../assets/migration-plan.md) with current paths, exact destinations, keep/rename/move/register/reference/defer actions, reasons and any actual risks or dependencies. For a straightforward reorganisation, a short mapping in the conversation is sufficient; no separate plan file, helper JSON, hashes or journal is required. Preserve collections inside the appropriate core. Plan reference repairs separately from source moves; received originals and other owners' substantive records remain untouched. Shorten paths through sensible structure, not silent filename abbreviation.

Plan all seven roots and minimal controls. Account for every scoped item, including excluded or unresolved content and old empty containers. Include removal of named emptied old folders in the same plan when needed; that cleanup can be approved with the moves, not through a separate approval cycle. No content deletion or duplicate removal is implied. Unapproved retired containers remain an explicit gap.

Obtain approval for this exact plan. A structural approval does not grant permissions, approve content, issue documents, authorise another skill or bypass tool confirmations. Meaning-changing decisions require owner resolution. Do not repeatedly ask about routine actions already approved.

## Apply, resume and verify

Use direct filesystem tools or PowerShell, never Computer Use or Explorer automation:

1. Inspect the exact source and destination, including hidden items. Prefer a direct folder rename or move when its destination does not exist.
2. If the approved mapping needs a different container or merging into an existing folder, create only missing destinations and move the scoped contents, preserving subfolders and hidden items. Check each exact destination; never overwrite, silently merge conflicting entries or invent numbered names. Resolve a conflict before moving that item.
3. Verify moved items at their approved destinations and reconcile anything left at the source. Only then remove the named old folders whose cleanup was approved, after a fresh check confirms they are empty, including hidden entries. Use a non-recursive empty-directory removal; never recursively delete, follow a reparse point or delete the project root.
4. Verify the resulting paths and approved navigation. Report failures and remaining items, not just successful commands.

Do not use create/move/delete as a workaround for a protection, provider or access failure. A helper refusal is a limit of that helper, not a ban on all filesystem tools and not permission to bypass a restriction. Follow Common Architecture's file-operation rules to choose a supported filesystem or provider route.

One coordinator owns migration writes. Check source identity/state immediately before each action and destination before creation. Revalidate shared progress and concurrent changes; a journal is not a lock against other users or agents. Pause a dependent group on drift; independent groups may proceed. Never overwrite a destination, even for identical bytes. Preserve non-identical versions.

Track completed and remaining mappings in the conversation or an existing progress record; use observed identities or fingerprints where needed to distinguish versions. Resume that approved mapping, not fresh classification. Interrupted moves need source/destination inspection; never repeat a move or unconditionally roll it back. Unexpected names or locations stop the affected group; do not attempt speculative repair. Recovery or reverse moves require current-state checks and authority.

Verify:

- all seven roots exist and no conflicting legacy filing roots remain;
- every scoped item is preserved, intentionally excluded or an explicit blocker;
- approved owned links and issued identities resolve;
- evidence IDs, timestamps, owner notes and historical provenance survive;
- source retention and semantic review are not conflated;
- deferred items, cloud limitations and unresolved references are reported.

Report complete only when the full approved scope and baseline pass. Do not call a partial move or successful helper invocation a complete migration.

## Local helper boundary

[Invoke-WorkspaceMigration.ps1](../scripts/Invoke-WorkspaceMigration.ps1) is optional for independent ordinary-local-file batches needing digest-bound progress. It requires Windows and PowerShell 7.2+, no `gh`; the package's path examples and path-safety checks assume Windows, and non-Windows execution is not verified. It does not classify content, bootstrap controls, edit links, delete empty folders, move directories or migrate cloud storage. It rejects reparse/recall/offline paths and protected collections rather than attempting hydration or bypass. Do not require it for routine folder renames, moves or approved empty-folder cleanup.

Only when using this helper, generate its JSON input after inspection; hashes and modification times must be observed, not invented. Every operation is an independent file move. Use direct filesystem operations for supported directory moves and approved reference edits; use an authorised provider API/tool when cloud guarantees require it. Do not flatten dependencies into this helper.

```powershell
# Fictional paths. Substitute the installed skill path and an authorised target.
pwsh -NoProfile -File "<skill-path>\scripts\Invoke-WorkspaceMigration.ps1" `
  -TargetPath "C:\Projects\Example" -PlanPath "C:\Plans\example.json"

# Only after approval of the exact displayed SHA-256 plan digest:
pwsh -NoProfile -File "<skill-path>\scripts\Invoke-WorkspaceMigration.ps1" `
  -TargetPath "C:\Projects\Example" -PlanPath "C:\Plans\example.json" `
  -Apply -ApprovedPlanHash "<observed-plan-sha256>"
```

Preview performs local identity checks without writes. Apply/resume uses the same arguments and exact plan digest. The helper compares both SHA-256 and exact UTC modification-time ticks; a mismatch refuses the move even when the bytes are unchanged. Record the observed timestamp with seven fractional digits. Filesystems that round timestamps may cause a safe false refusal. The journal is under `Governance\Migration`; it records only operational metadata and is atomically replaced. Do not manually edit or delete it to force progress. Verification runs after approved operations and reports unresolved entries, retired paths or missing core roots as partial. A helper error stops this local batch; the coordinator may proceed only with independent separately planned groups.

For cloud/shared material, establish the preservation requirements rather than choosing a route solely from the path prefix. Use supported filesystem operations when sufficient, or an authorised provider API/tool when required to preserve item identity, version or known links. If preservation cannot be established, defer rather than claim success. Never change sharing or permissions. A local move, hydration or a copy of a shared workspace is not proof that its original links will survive.

## Evidence and disclosure

Keep public examples fictional. Do not copy customer or employer documents, names, private links, tenant IDs, live file inventories or captured conversations into this package. Real source identity remains functional data in the explicitly authorised private target. Sanitise reports intended for public use without changing retained source evidence.
