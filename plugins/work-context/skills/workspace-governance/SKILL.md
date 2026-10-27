---
name: workspace-governance
description: Set up, assess, repair or migrate a project folder into the standard seven-folder structure (Start Here, Issued Outputs, Working, Sources, Meetings, Stakeholders, Archive). Use when organising or tidying a project, deciding where a file belongs, registering an issued output or reviewing duplicates. Not needed for ordinary reading or drafting.
metadata:
  version: "4.1"
  architecture: common-workspace-architecture v2.4
  runtime-dependencies: Direct filesystem or shell access; Windows path conventions; PowerShell 7.2+ for the optional local migration helper; authorised provider tools when cloud preservation requires them
---

# Workspace Governance

Own structure, stable human and agent signposts, the Issued Outputs Index and structural migration. Do not collect meetings, write profiles or become a task system.

Use direct filesystem tools or PowerShell for basic file and folder operations, never Computer Use or Explorer automation. The bundled helper is optional, not the gateway to migration. Follow Common Architecture's file-operation rules, including for sync-client paths.

No MCP server is required for local structure work. If cloud preservation requires a provider operation, check that an authorised tool supports that exact action; WorkIQ MCP search/read access does not by itself establish move or rename support. The client supplies external tools and credentials separately.

## Files

| Load | When |
|---|---|
| [../../Common Architecture.md](../../Common%20Architecture.md) | Every run; bundled here, not assumed present in the target. |
| [references/migration.md](references/migration.md) | Assessing migration, planning, applying, resuming or verifying. |
| [assets/migration-plan.md](assets/migration-plan.md) | Preparing a transition plan. |
| [assets/start-here.md](assets/start-here.md), [assets/agents.md](assets/agents.md), [assets/issued-outputs-index.md](assets/issued-outputs-index.md) | Creating owned signposts and the issued-output index. |

## Resolve the target

Use the supplied path, never this skill's location. A supplied core child uses its parent as root. Inspect unfamiliar layouts without assuming names establish authority or lifecycle. A named blank target is valid for initialisation.

Read target instructions and identify nested repositories, cloud storage, reparse points and application-managed collections. For a software repository, agree a project-context boundary before structural writes; do not reorganise engineering roots. Ask only where target or authority is materially ambiguous.

## Operations

| Operation | Result and authority |
|---|---|
| `bootstrap` | Initialisation creates all seven roots, Start Here, root `AGENTS.md` and Issued Outputs Index when absent. |
| `assess` | Read-only inventory, routing gaps and risks; no permanent legacy mapping. |
| `plan-migration` | Concrete before/after mapping in the conversation; use session artifacts for larger plans, or the target when authorised. No moves. |
| `apply-migration` | Execute the specifically approved plan with drift checks and progress. |
| `resume-migration` | Revalidate the same plan and progress before continuing. |
| `verify` | Check baseline, scoped content, references, retired roots and unresolved items. |
| `repair` | Restore authorised missing roots or owned controls, without relocating legacy content by implication or rewriting existing signposts solely due to version drift. |
| `route` | Propose destinations; moves require plan approval. |
| `register-output` | Register an exact deliberately circulated version and append distribution. |
| `review-duplicates` | Compare identity/version/hashes and report; never delete. |

## Structure and routing

Create missing items only:

```text
workspace
|-- AGENTS.md
|-- 00 Start Here
|   `-- Start Here.md
|-- 10 Issued Outputs
|   `-- Issued Outputs Index.md
|-- 20 Working
|-- 30 Sources
|-- 40 Meetings
|-- 50 Stakeholders
`-- 99 Archive
```

Supplementary collections are unnumbered and short. `Governance` may hold approved migration records, not installed skill copies. Bootstrap creates no specialist controls or profiles.

AI drafts belong in Working; received evidence in Sources retains its origin and limitations. Record audience distribution rather than identical issued copies. Preserve non-identical versions. Approval and issue are different, and neither establishes every claim's truth.

## Migration and maintenance

A migration request authorises planning, not unbounded movement. Obtain approval for the exact mapping, including reference edits, any required provider actions and removal of emptied old folders. Then execute independent safe actions without questions about each routine file. Do not require helper JSON, hashes or a journal for ordinary folder operations. Tool permissions still apply.

Prefer a direct folder rename or move. Where the approved layout needs a new or existing destination, create missing folders, move the contents without overwriting, verify the result, then remove only explicitly approved old folders confirmed empty, including hidden entries. Never recursively delete leftover content or switch to GUI renames after an error. See the migration reference for checks and recovery.

An incompatible layout is not the final arrangement. Protected items, uncertain issue state, link limitations and legacy roots are explicit migration gaps, not permanent path aliases.

### Stable signposts

Start Here is a human-facing folder map; root `AGENTS.md` provides concise agent navigation and stable working safeguards. Create either only when absent during explicitly authorised bootstrap or repair, using its bundled versioned asset. The project folder name supplies project identity.

Do not add changing project facts, file or entity inventories, meetings, current status, evidence cutoffs, review dates or open gaps to either signpost. Direct current-information questions to the relevant workspace contents and specialist records. Meetings Governance owns its index and contexts; Stakeholder Governance owns eligible profiles and justified research maps. Neither specialist skill refreshes, hands off for, or edits common signposts as a consequence of ordinary processing.

When target instructions already exist, read and respect them. Do not overwrite or merge an existing `AGENTS.md`, or rewrite existing Start Here content merely because a template or skill version advanced. During an explicitly authorised governance operation, inspect signpost metadata and content against the bundled template and decide whether an upgrade is relevant. Preserve `created_by` and local additions; for an existing signpost content migration, show the proposed change and obtain approval before applying it. Update `last_governed_by` only after material change or validation. A version advance alone is not migration authority.

## Completion

Check seven roots, signpost presence and stable content when creation or repair is authorised, owned links, canonical issued records and preservation of evidence, identities, owner notes and `created_by`. Do not compare common signposts with specialist inventories or current evidence. Unchanged bootstrap/repair makes no changes. Migration also accounts for every scoped item, reference repair and retired root; otherwise report partial completion with concrete blockers.

No unapproved specialist work, overwrite, deletion or move may occur. Report actual errors. Helper verification covers local file operations, not full conformity or cloud behaviour.
