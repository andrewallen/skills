---
name: workspace-governance
description: Create, assess, repair or migrate projects into the seven-folder structure. Plan unfamiliar layouts before approved moves; register issued outputs and review duplicates. Not required for ordinary reading or drafting.
metadata:
  version: "3.2"
  architecture: common-workspace-architecture v2.2
  runtime-dependencies: Direct filesystem or shell access; PowerShell 7.2+ for the optional local migration helper; authorised provider tools when cloud preservation requires them
---

# Workspace Governance

Own structure, Start Here, the Issued Outputs Index and structural migration. Do not collect meetings, write profiles or become a task system.

Use direct filesystem tools or PowerShell for basic file and folder operations, never Computer Use or Explorer automation. The bundled helper is optional, not the gateway to migration. Follow Common Architecture's file-operation rules, including for sync-client paths.

No MCP server is required for local structure work. If cloud preservation requires a provider operation, check that an authorised tool supports that exact action; WorkIQ MCP search/read access does not by itself establish move or rename support. The client supplies external tools and credentials separately.

## Files

| Load | When |
|---|---|
| [../../Common Architecture.md](../../Common%20Architecture.md) | Every run; bundled here, not assumed present in the target. |
| [references/migration.md](references/migration.md) | Assessing migration, planning, applying, resuming or verifying. |
| [assets/migration-plan.md](assets/migration-plan.md) | Preparing a transition plan. |
| [assets/start-here.md](assets/start-here.md), [assets/issued-outputs-index.md](assets/issued-outputs-index.md) | Creating or maintaining owned navigation. |

## Resolve the target

Use the supplied path, never this skill's location. A supplied core child uses its parent as root. Inspect unfamiliar layouts without assuming names establish authority or lifecycle. A named blank target is valid for initialisation.

Read target instructions and identify nested repositories, cloud storage, reparse points and application-managed collections. For a software repository, agree a project-context boundary before structural writes; do not reorganise engineering roots. Ask only where target or authority is materially ambiguous.

## Operations

| Operation | Result and authority |
|---|---|
| `bootstrap` | Initialisation creates all seven roots, Start Here and Issued Outputs Index. |
| `assess` | Read-only inventory, routing gaps and risks; no permanent legacy mapping. |
| `plan-migration` | Concrete before/after mapping in the conversation; use session artifacts for larger plans, or the target when authorised. No moves. |
| `apply-migration` | Execute the specifically approved plan with drift checks and progress. |
| `resume-migration` | Revalidate the same plan and progress before continuing. |
| `verify` | Check baseline, scoped content, references, retired roots and unresolved items. |
| `repair` | Restore authorised missing roots or owned controls, without relocating legacy content by implication. |
| `route` | Propose destinations; moves require plan approval. |
| `register-output` | Register an exact deliberately circulated version and append distribution. |
| `review-duplicates` | Compare identity/version/hashes and report; never delete. |

## Structure and routing

Create missing items only:

```text
00 Start Here
    Start Here.md
10 Issued Outputs
    Issued Outputs Index.md
20 Working
30 Sources
40 Meetings
50 Stakeholders
99 Archive
```

Supplementary collections are unnumbered and short. `Governance` may hold approved migration records, not installed skill copies. Bootstrap creates no specialist controls or profiles.

AI drafts belong in Working; received evidence in Sources retains its origin and limitations. Record audience distribution rather than identical issued copies. Preserve non-identical versions. Approval and issue are different, and neither establishes every claim's truth.

## Migration and maintenance

A migration request authorises planning, not unbounded movement. Obtain approval for the exact mapping, including reference edits, any required provider actions and removal of emptied old folders. Then execute independent safe actions without questions about each routine file. Do not require helper JSON, hashes or a journal for ordinary folder operations. Tool permissions still apply.

Prefer a direct folder rename or move. Where the approved layout needs a new or existing destination, create missing folders, move the contents without overwriting, verify the result, then remove only explicitly approved old folders confirmed empty, including hidden entries. Never recursively delete leftover content or switch to GUI renames after an error. See the migration reference for checks and recovery.

An incompatible layout is not the final arrangement. Protected items, uncertain issue state, link limitations and legacy roots are explicit migration gaps, not permanent path aliases.

Update orientation from reviewed evidence. Check the local records, such as the Meetings Index and `50 Stakeholders`, before describing a collection as empty or lagging, and link the profiles and contexts that exist. Record the orientation review date separately from the evidence cutoff, with any freshness gaps. When another owner reports that its work left Start Here stale, refresh the navigation from the reviewed records; do not edit that owner's files. A project-context refresh may coordinate separately authorised owners; it is not background synchronisation or a dependency on the other skills.

## Completion

Check seven roots, owned links, Start Here statements about specialist collections against the local records, canonical issued records and preservation of evidence, identities, owner notes and `created_by`. Unchanged bootstrap/repair makes no changes. Migration also accounts for every scoped item, reference repair and retired root; otherwise report partial completion with concrete blockers.

No unapproved specialist work, overwrite, deletion or move may occur. Report actual errors. Helper verification covers local file operations, not full conformity or cloud behaviour.
