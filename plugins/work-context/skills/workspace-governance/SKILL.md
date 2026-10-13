---
name: workspace-governance
description: Create, explain, assess and safely maintain the common workspace structure. Use for initial setup, structural repair, routing ambiguous material, registering issued outputs, duplicate review or approval-ready reorganisation proposals. Do not use for ordinary reading, reasoning, drafting or editing.
metadata:
  version: "2.1"
  architecture: common-workspace-architecture v1.1
  runtime-dependencies: none
---

# Workspace Governance

Own the common structure, `Start Here.md` and `Issued Outputs Index.md`. Do not capture meetings, write stakeholder profiles or act as a task system.

Ordinary analysis, AI-assisted drafting and human editing do not need this skill. New working outputs normally belong in `20 Working Material`.

## Files

| Load | When |
|---|---|
| [../../Common Architecture.md](../../Common%20Architecture.md) | Every run. Bundled in this plugin; do not assume a copy exists in the target workspace. |
| [assets/start-here.md](assets/start-here.md) | Creating or repairing Start Here. |
| [assets/issued-outputs-index.md](assets/issued-outputs-index.md) | Creating or repairing the Issued Outputs Index. |

## Resolve the target

Resolve `workspace_root` from the supplied path. Never infer it from this skill's location.

- A supplied common child such as `00 Start Here`, `10 Issued Outputs` or `70 Governance and Administration` uses its parent as `workspace_root`.
- A blank or absent named target is valid when the user asked to initialise it.
- If the target could reasonably be an unrelated folder, ask one focused question before writing.
- Preserve an explicitly supplied legacy structure unless the user approves migration.

## Choose the operation

| Operation | Result |
|---|---|
| `bootstrap` | Create the complete fixed root structure and minimum controls. |
| `repair` | Restore missing common roots or controls without moving valid content. |
| `assess` | Report structural and routing recommendations without changes. |
| `route` | Prepare a move table; move only after explicit approval. |
| `register-output` | Register one canonical issued file and its distribution event. |
| `review-duplicates` | Compare identity and hashes; report or propose, never delete. |

## Bootstrap or repair

An explicit request to initialise a named workspace authorises creation of:

```text
workspace_root
|-- 00 Start Here
|   `-- Start Here.md
|-- 10 Issued Outputs
|   `-- Issued Outputs Index.md
|-- 20 Working Material
|-- 30 Source Material
|-- 40 Meetings
|-- 50 People and Organisations
|-- 60 Media and Recordings
|-- 70 Governance and Administration
`-- 90 Archive
```

Create only missing items and preserve everything present. Empty fixed roots are valid. Do not create meeting controls, stakeholder profiles, evidence folders or copies of specialist skills unless separately requested.

## Route material

Apply the routing rules in Common Architecture.

- AI-created or AI-assisted drafts go to Working Material.
- Source Material is organised by origin and evidential role, not audience.
- A meeting recording tied to an occurrence belongs in Meetings; standalone media belongs in Media and Recordings.
- Audience distribution is recorded in the Issued Outputs Index, not by making identical audience copies.
- If ownership, sensitivity or destination is unclear, pause only that item and continue safe independent work.

Use Meetings Governance for meeting collection and Stakeholder Governance for person or organisation profiles only when the request includes that work. Otherwise report the bounded next step.

## Register issued outputs

Register the exact canonical version and append a distribution row. Use a stable version, modified time or SHA-256 when identity is unclear.

`approved` and `issued` are different. Approval does not prove distribution, and distribution does not prove every claim correct.

## Reorganisation and duplicates

Before changing established content, provide:

| Current path | Proposed destination | Reason | Risk or notes |
|---|---|---|---|

For filename conflicts, compare hashes. Preserve non-identical files with a clear qualifier. Never delete files.

## Completion

Check that:

- every requested root or control exists once;
- Start Here and index links resolve;
- issued records point to one canonical file;
- no specialist evidence or profile was duplicated;
- no unapproved move, rename, archive action, overwrite or deletion occurred;
- repeating bootstrap or repair makes no changes.

Report what was created, repaired, registered or proposed, plus any unresolved item or permission block.
