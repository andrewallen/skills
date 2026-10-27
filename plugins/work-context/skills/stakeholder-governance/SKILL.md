---
name: stakeholder-governance
description: Create or refresh evidence-backed profiles of relevant people and organisations from the project's own files. Use when new evidence affects a profile, for named profile creation, bounded stakeholder discovery or reviewing a draft against recorded positions. Not a CRM, personality model, account plan or meeting archive.
metadata:
  version: "6.3"
  architecture: common-workspace-architecture v2.4
  runtime-dependencies: Direct filesystem or shell access using Windows path conventions; any local readers available for the document formats in scope; WorkIQ MCP or equivalent authorised Microsoft 365 tools only for separately authorised live research
---

# Stakeholder Governance

A stakeholder is a relevant person or organisation other than the workspace owner's own organisation (the *owner organisation*, resolved under [Eligibility](#eligibility)) and its employees. Store both entity types directly under `50 Stakeholders`, with one canonical profile per entity.

The normal operation is to refresh only the profiles affected by new evidence.

## Invariants

These hold in every operation. If an action would break one, stop that item and report it.

- Resolve the target from the user's input, never from this skill's location: the installed package is not a workspace.
- Never profile the owner organisation or its employees (see [Eligibility](#eligibility)): the profiles exist to understand counterparts.
- Read the content before citing it, and name what was not read: a title or pointer is not evidence.
- One person's statement is not their organisation's position without evidenced authority: misattributed positions mislead the work.
- Research beyond the project's own files only when separately authorised for a stated question: profiling must stay proportionate.
- Consume meeting evidence; never recollect it: Meetings Governance owns capture.

## Dependencies

Use direct filesystem or shell access for the project's local files, supplied evidence and profiles. Read relevant documents, reports and presentations with the local readers available; disclose content that cannot be read rather than omitting it, and do not add a dependency without approval.

Live Microsoft 365, directory or public research is a separate operation that needs explicit authorisation for a stated question. It is not part of ordinary profile creation or refresh. When authorised, it requires WorkIQ MCP or equivalent tools, configured separately by the client; check exact source access before relying on search results, and disclose unavailable sources and permissions rather than claiming no evidence exists. This dependency does not permit parallel meeting capture or broaden the authorised research scope.

## Files

| Load | When |
|---|---|
| [../../Common Architecture.md](../../Common%20Architecture.md) | Every run: shared structure, provenance, navigation and migration boundaries. |
| [references/evidence-guidance.md](references/evidence-guidance.md) | Every profile creation, refresh or content review. |
| [references/sources.md](references/sources.md) | Discovery, full-profile research, refresh source review, document review or authorised supplementary research. |
| [assets/person-profile.md](assets/person-profile.md) | Creating or repairing a person profile. |
| [assets/organisation-profile.md](assets/organisation-profile.md) | Creating or repairing an organisation profile. |
| [assets/research-map.md](assets/research-map.md) | Only when a separate source map adds navigation value. |

## Default operation: refresh affected stakeholders

Unless the user asks for discovery, named creation, content review or repair:

1. Resolve the stakeholder root and the evidence added or changed since the previous profile update.
2. Identify only the eligible people and organisations materially affected.
3. Read the exact source passages, including the relevant content of changed documents and presentations, and the current canonical profiles.
4. Update the affected sections, citations, coverage and review date.
5. Preserve prior positions, role changes, disagreements and unresolved gaps.
6. Report the profiles changed, any excluded entities, and the remaining evidence and review gaps.

Do not refresh every profile merely because one meeting or document changed.

## Resolve the target

Never infer the target from this skill's location.

- A supplied `50 Stakeholders` folder is `stakeholder_root`.
- Legacy stakeholder locations may be read as evidence. Before writing profiles there, report the need for approved structural migration; do not create a permanent alternative layout.
- An existing entity folder means a targeted profile operation.
- Otherwise the supplied path is `workspace_root` and `stakeholder_root` is its `50 Stakeholders` child.
- A blank or absent named target is valid when the user asked to create or discover profiles.
- If the entity, entity type or target is ambiguous, ask one focused question.

## Work from project files

Work from the project's own files and supplied material: `30 Sources`, `40 Meetings`, `20 Working`, `10 Issued Outputs` and any relevant retained history, without treating every version as current authority. Screen the inventory for relevance; do not load everything because it is available.

- Read relevant primary content, including documents, reports and presentations, with surrounding passages, corrections and counter-evidence. A file's presence, title, metadata, search snippet or retained pointer is not review.
- A link or pointer to material outside the project is a lead, not reviewed content. Do not follow it, search Microsoft 365, verify directory roles or research public sources unless the user separately authorises that research for a stated question.
- Include relevant wider relationship context found in the project, but lead with evidence relevant to the project's purpose. Do not turn adjacent contributions into project requirements. Order qualitatively; do not score.
- If relevant content cannot be read, no local reader is available or a source was only partly reviewed, name it and the reason in the existing coverage table. A partial profile is useful when labelled partial; do not describe a review as complete while relevant available content remains unread.

## Eligibility

Do not create profiles for the owner organisation or its employees. This applies equally to the workspace owner and their colleagues.

- Resolve the owner organisation once per run, before creating or refreshing any profile, in this order: the user's request or the target's own instructions; the `owner_organisation` field of the workspace's meeting Archive Guide, when one exists and is not a placeholder; otherwise ask one focused question. If the owner says there is none, no organisation is excluded. State the value used in the report; do not write it to a new file.
- Check the project evidence for affiliation before creating or refreshing a profile, for example a stated organisation, signature or email domain. If it is unclear, report it or ask one focused question; do not infer it from a name or title.
- Keep their attributed contributions in source evidence, and use them where relevant to analyse a counterpart.
- If an excluded entity already has a profile, flag the conflict in the report. Do not delete, move, archive or rewrite it without approval.

## Operations

| Operation | Use |
|---|---|
| `refresh-affected` | Default. Update profiles affected by new or corrected evidence. |
| `targeted-create` | Create profiles for named people or organisations. |
| `discover` | Identify relevant, eligible stakeholders within a bounded workspace question and source range. |
| `content-review` | Review a draft against evidenced stakeholder positions without simulating approval. |
| `repair` | Restore missing profile structure, provenance or links without broad rewriting. |

## Initialise the stakeholder area

An explicit request to create or discover profiles authorises:

```text
50 Stakeholders
|-- Full Name
|   `-- Full Name - Person Profile.md
`-- Organisation Name
    `-- Organisation Name - Organisation Profile.md
```

If `stakeholder_root` was supplied directly, do not add another `50 Stakeholders`.

Compatible supplied evidence may come from people or other tools; no producer skill is required. Preserve source limitations and report missing required information instead of inventing provenance. Existing entity folders outside the baseline require an approved transition before maintenance there.

Create only named entities, entities approved through bounded discovery or eligible entities supported by sufficient evidence. Do not create empty placeholders, mandatory `People` and `Organisations` containers, a permanent entity index or a copy of this skill.

## Identity and evidence

Resolve entity identity and type before creating or merging a folder.

- Use the evidenced display name and the smallest stable qualifier for genuine namesakes.
- Do not infer or merge identity from name similarity. A provisional profile may record the uncertainty, labelled with its sources.
- Keep dated role, remit and relationship inside the profile.
- A person speaking in a meeting does not automatically establish an organisation's position.
- Attendance, seniority, directory membership, copied correspondence and silence do not establish endorsement.
- Historical contributions do not establish current decisions, actions or delivery status.
- Without sufficient evidence, state the gap rather than inventing a profile.

Meetings Governance owns meeting retrieval and capture. Use an available Meetings Index and its source links, but do not re-enumerate calendars, download transcripts or build a second meeting archive. If material meeting evidence is missing, either use Meetings Governance when authorised or report the bounded gap.

## Profiles

Use the person or organisation asset and keep the profile proportionate to the evidence. Where evidence is thin, use the compact provisional form: identity or uncertainty, purpose, review range and cutoff, a short source-backed perspective, practical implications and material gaps. Expand to the fuller form only as evidence supports it, and do not pad it with placeholder sections or repeated limitation statements. Preserve attribution and relevant counter-evidence in either form.

A person profile covers:

1. perspective;
2. voice and observed working practice;
3. contribution timeline;
4. implications for the work.

An organisation profile covers:

1. identity, remit and relationship;
2. evidenced priorities, positions and constraints;
3. engagement and contribution timeline;
4. connected people and roles;
5. implications for the work.

The compact form needs only the summary paragraph, the implications and the gaps; the fuller form adds the remaining sections as evidence supports them.

Profiles are Synthesised. Label interpretation as Inferred and advice as Proposed. Keep exact quotations, attributed statements, institutional positions and recommendations distinguishable.

Use a research map only for a complex source set or a Word-based profile that needs separate navigation.

## Content review

Assess a draft against dated evidenced criteria as:

- aligned;
- partially addressed;
- in tension;
- not assessable.

Say that the draft addresses or conflicts with recorded evidence. Do not predict personal approval or organisational endorsement.

## Completion

Check that:

- each requested entity has the correct type and one canonical profile, or an explicit partial outcome;
- the owner organisation was resolved and reported, no profile was created for it or its employees, and any existing one was flagged rather than changed;
- relevant available document content was read, or each material unread source is named with its reason, and no partial review is described as complete;
- material claims have source anchors and attribution limits;
- organisation claims are not inferred from one unauthorised person;
- only affected profiles changed;
- meeting evidence was consumed rather than recollected;
- no external research or link-following occurred without separate authorisation;
- no CRM, personality model, task system, duplicate profile or unrelated root was created;
- repeating the operation without new evidence creates no new files.

Report the profiles created or refreshed, the material change, any excluded entities and the remaining evidence and review gaps. Specialist records provide their own navigation; profile changes do not require updating or handing off common signposts.
