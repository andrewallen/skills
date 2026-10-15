---
document_role: common-workspace-architecture
architecture_version: "1.1"
effective_date: "2026-10-09"
---

# Common Workspace Architecture

Use the same structure for an event, engagement, initiative, research activity, planning exercise or discrete piece of work:

```text
00 Start Here
10 Issued Outputs
20 Working Material
30 Source Material
40 Meetings
50 People and Organisations
60 Media and Recordings
70 Governance and Administration
99 Archive
```

## Everyday work

Governance is not required for ordinary reading, reasoning, drafting or editing.

- Read the material needed for the task.
- Put new analysis, synthesis, presentations and AI-assisted drafts in `20 Working Material`.
- Edit working files normally.
- Preserve original or received evidence in `30 Source Material`.
- Preserve exact issued versions in `10 Issued Outputs`.
- Use a governance skill only when maintaining its governed collection or changing structure or lifecycle state.

## Folder roles

| Folder | Use |
|---|---|
| `00 Start Here` | Short orientation, current position and navigation. |
| `10 Issued Outputs` | Exact versions deliberately circulated, plus distribution history. |
| `20 Working Material` | Drafts, analysis, synthesis, presentations and AI-assisted work. |
| `30 Source Material` | Original or received evidence and reference material. |
| `40 Meetings` | Governed meeting, workshop and session evidence. |
| `50 People and Organisations` | Evidence-backed profiles of relevant people and organisations. |
| `60 Media and Recordings` | Standalone media not tied to a governed meeting. |
| `70 Governance and Administration` | Architecture, controls and local governance skills. |
| `99 Archive` | Superseded, withdrawn or inactive retained material. |

## Routing

Use the first applicable rule:

1. Meeting-specific evidence, including occurrence recordings, goes to `40 Meetings`.
2. Person and organisation analysis goes to `50 People and Organisations`.
3. An exact version deliberately circulated goes to `10 Issued Outputs`.
4. Original or received evidence goes to `30 Source Material`.
5. New analysis, drafts and AI-assisted work go to `20 Working Material`.
6. Standalone media goes to `60 Media and Recordings`.
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

## Issued outputs

Keep one canonical issued file. Record each audience, issue date, channel and evidence in the Issued Outputs Index. Create another file only when the content or required format differs.

Before resolving a filename conflict, compare identity, version and hashes. Preserve non-identical files. Never overwrite or delete merely because names match.

## Skill ownership

| Skill | Owns |
|---|---|
| `workspace-governance` | Fixed roots, Start Here, Issued Outputs Index, routing and duplicate review. |
| `meetings-governance` | Meeting discovery, capture, contexts, index and reconciliation. |
| `stakeholder-governance` | Evidence-backed person and organisation profiles and research maps. |

The skills have no runtime dependency on one another. Handoffs are optional and bounded. One skill does not create or repair another skill's files.

## Generated-file provenance

Governed templates use three fields:

```yaml
template: <template-id>@<template-version>
created_by: <skill-name>@<skill-version-at-creation>
last_governed_by: <skill-name>@<skill-version-at-last-material-update>
```

Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A newer skill version does not require an automatic file migration.

## Change safety

- Create only what the request authorises.
- Preserve established valid content.
- Do not move, rename, archive, delete or bulk-edit without explicit approval.
- Before reorganisation, provide current path, proposed destination, reason and risk.
