---
document_role: common-workspace-architecture
architecture_version: "2.3"
effective_date: "2026-10-22"
---

# Common Workspace Architecture

Use the same structure for an event, engagement, initiative, research activity, planning exercise or discrete piece of work:

```text
00 Start Here
10 Issued Outputs
20 Working
30 Sources
40 Meetings
50 Stakeholders
99 Archive
```

Root `AGENTS.md`, when deployed, is an instruction file alongside these folders, not an eighth root.

## Everyday work

Governance is not required for ordinary reading, reasoning, drafting or editing.

- Read the material needed for the task.
- Put new analysis, synthesis, presentations and AI-assisted drafts in `20 Working`.
- Edit working files normally.
- Preserve original or received evidence in `30 Sources`.
- Preserve exact issued versions in `10 Issued Outputs`.
- Use a governance skill only when maintaining its governed collection or changing structure or lifecycle state.

## File operations

Use direct filesystem tools or shell commands for listing, reading, writing, creating, renaming, moving and deleting local files and folders. On Windows, use PowerShell with exact literal paths. Do not use Computer Use, Explorer/Finder, simulated keystrokes or clipboard automation for these operations. If filesystem access is unavailable, report that blocker rather than switching to a GUI.

Use the simplest operation that fulfils the authorised request. A folder rename or move does not require a custom helper, JSON plan, digest or journal. A short before/after mapping in the conversation is enough for a simple reorganisation; obtain approval once for its scope, including any empty-folder cleanup. Skill ownership and tool permissions still apply.

A OneDrive or other sync-client path is not by itself a reason to abandon filesystem tools. Use supported filesystem operations where they meet the required preservation guarantees. Hydration alone does not establish cloud identity, history or shared-link preservation. If provider restrictions or those guarantees require a cloud operation, use an authorised provider API/tool, not UI automation; report a blocker if no suitable route is available. Do not bypass reparse-point, protection or access restrictions.

## Folder roles

| Folder | Use |
|---|---|
| `00 Start Here` | Stable human-facing map of the core folder roles. |
| `10 Issued Outputs` | Exact versions deliberately circulated, plus distribution history. |
| `20 Working` | Drafts, analysis, synthesis, presentations and AI-assisted work. |
| `30 Sources` | Original or received evidence and reference material; placement does not establish truth or authority. |
| `40 Meetings` | Governed meeting, workshop and session evidence. |
| `50 Stakeholders` | Evidence-backed profiles of relevant people and organisations. |
| `99 Archive` | Superseded, withdrawn or inactive retained material. |

## Routing

Use the first applicable rule:

1. Meeting communication evidence and occurrence recordings go to `40 Meetings`; reusable shared resources follow their source, working or issued role and are linked from the meeting.
2. Person and organisation analysis goes to `50 Stakeholders`.
3. An exact version deliberately circulated goes to `10 Issued Outputs`.
4. Original or received evidence goes to `30 Sources`.
5. New analysis, drafts and AI-assisted work go to `20 Working`.
6. Standalone media follows its source, working or issued role; format does not require a separate root.
7. Material moves to `99 Archive` only with explicit approval.

Filenames such as `Final`, `Official`, `Clean` or `Customer-Ready` do not establish lifecycle state.

## Information and lifecycle

Keep these separate:

- information type: Captured, Extracted, Synthesised, Inferred or Proposed;
- provenance and attribution;
- audience;
- lifecycle: working, review-required, approved, issued, superseded, withdrawn or archived;
- sensitivity and usage rights.

AI assistance is provenance, not evidence of authority, approval or issue.

## Naming and navigation

All fully initialised or migrated workspaces have the seven core roots, including empty ones. Number only these roots. Supplementary folders are unnumbered, normally one to three meaningful words, and must not compete with core roles. Prefer collections within the appropriate core; a distinct additional function such as `Governance` may sit at the root. Preserve coherent collections rather than flattening them.

Keep paths shallow. Do not repeat the project name or automatically add year, month, audience or format layers. Check full destination paths against actual client limits. Never silently abbreviate existing filenames.

Project documents created or materially updated should visibly state purpose, lifecycle, relevant date/version, material provenance and source limitations in their native format. Static workspace signposts are an exception: their governed metadata records deployment provenance, not a project evidence cutoff or review date. Do not rewrite received originals to add a banner. Optional `AI Exploration` under Working is for speculative material, not every AI-assisted record.

Start Here and root `AGENTS.md` are stable structural signposts, not project summaries. Start Here maps the core roots for human browsing; `AGENTS.md` provides concise agent navigation and stable working safeguards. Neither contains changing project status, inventories, evidence cutoffs or freshness claims. Ordinary project activity does not require either file to be maintained. Create missing signposts only during explicitly authorised initialisation or repair; a newer skill or template version alone does not authorise rewriting an existing file.

Meetings Governance owns its meeting index and contexts. Stakeholder Governance owns eligible entity profiles and any justified research maps. Those specialist records provide their own navigation and provenance; do not copy their changing details into the common signposts or create a competing index. Indexes, contexts and profiles lead to relevant source passages; they do not corroborate them independently. Summaries support navigation; quotations, contested claims and stakeholder characterisations require source grounding. Do not load the whole collection merely because it is available.

## Existing projects and migration

Assessment may read unfamiliar layouts. An approved migration physically converges on this baseline; permanent alternative-root mapping is not compliance. Routine reading or specialist work does not authorise migration.

Workspace Governance owns structural planning, approved moves, progress, verification and the common signpost templates. Preserve source IDs, historical provenance and owner notes. Other owners maintain their specialist records; ordinary changes to those records do not require a navigation handoff. Structural migration edits only explicitly approved navigation.

Resolve software repositories' project-context boundaries before writing. Never move code, configuration, nested repositories, application-managed content or reparse-point targets by inference. Apply the file-operation rules above; local movement does not prove shared-link preservation.

A plan binds exact scope, destinations and observed state. Apply independent safe operations without repeated questions; pause dependent groups on drift or ambiguity. Legacy collections, unresolved items and retired roots left behind are migration gaps, not an accepted alternative structure.

## Issued outputs

Keep one canonical issued file. Record each audience, issue date, channel and evidence in the Issued Outputs Index. Create another file only when the content or required format differs.

Before resolving a filename conflict, compare identity, version and hashes. Preserve non-identical files. Never overwrite or delete merely because names match.

## Skill ownership

| Skill | Owns |
|---|---|
| `workspace-governance` | Fixed roots, stable Start Here and `AGENTS.md` signposts, Issued Outputs Index, routing, migration and duplicate review. |
| `meetings-governance` | Meeting discovery, capture, contexts, index and reconciliation. |
| `stakeholder-governance` | Evidence-backed person and organisation profiles and research maps. |

The skills have no runtime dependency on one another. Handoffs are optional and bounded. One skill does not create or repair another skill's files. Ordinary changes to specialist records do not make common signposts stale or require a handoff.

## Generated-file provenance

Governed templates use three fields:

```yaml
template: <template-id>@<template-version>
created_by: <skill-name>@<skill-version-at-creation>
last_governed_by: <skill-name>@<skill-version-at-last-material-update>
```

Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A newer skill or template version does not require an automatic file migration. For existing signposts, compare their recorded template and creator/governor versions during an explicitly authorised governance operation; decide whether a change is relevant, preserve local additions, and obtain approval for a proposed content migration before rewriting.

## Change safety

- Create only what the request authorises.
- Preserve established valid content.
- Do not move, rename, archive, delete or bulk-edit without explicit approval.
- Before reorganisation, provide current path, proposed destination, reason and risk.
