---
name: stakeholder-governance
description: Create or refresh evidence-backed profiles of relevant people and organisations. Use after new meeting or source evidence, for named profile creation, bounded stakeholder discovery or evidence-based content review. Do not create a CRM, personality model, account plan or second meeting archive.
metadata:
  version: "4.1"
  architecture: common-workspace-architecture v1.1
  runtime-dependencies: none
  predecessor: stakeholders-governance v2.7
---

# Stakeholder Governance

A stakeholder is a relevant person or organisation. Store both entity types directly under `50 People and Organisations`, with one canonical profile per entity.

The normal operation is to refresh only the profiles affected by new evidence.

## Files

| Load | When |
|---|---|
| [references/evidence-guidance.md](references/evidence-guidance.md) | Every profile creation, refresh or content review. |
| [references/sources.md](references/sources.md) | Discovery, full-profile research or supplementary source research. |
| [assets/person-profile.md](assets/person-profile.md) | Creating or repairing a person profile. |
| [assets/organisation-profile.md](assets/organisation-profile.md) | Creating or repairing an organisation profile. |
| [assets/research-map.md](assets/research-map.md) | Only when a separate source map adds navigation value. |

## Default operation: refresh affected stakeholders

Unless the user asks for discovery, named creation, content review or repair:

1. Resolve the stakeholder root and the evidence added or changed since the previous profile update.
2. Identify only the people and organisations materially affected.
3. Read the exact source passages and the current canonical profiles.
4. Update the affected sections, citations, coverage and review date.
5. Preserve prior positions, role changes, disagreements and unresolved gaps.
6. Report the profiles changed and any missing evidence.

Do not refresh every profile merely because one meeting or document changed.

## Resolve the target

Never infer the target from this skill's location.

- A supplied `50 People and Organisations` folder is `stakeholder_root`.
- A supplied legacy `Stakeholders` folder is used directly.
- An existing entity folder means a targeted profile operation.
- Otherwise the supplied path is `workspace_root` and `stakeholder_root` is its `50 People and Organisations` child.
- A blank or absent named target is valid when the user asked to create or discover profiles.
- If the entity, entity type or target is ambiguous, ask one focused question.

## Operations

| Operation | Use |
|---|---|
| `refresh-affected` | Default. Update profiles affected by new or corrected evidence. |
| `targeted-create` | Create profiles for named people or organisations. |
| `discover` | Identify relevant stakeholders within a bounded workspace question and source range. |
| `content-review` | Review a draft against evidenced stakeholder positions without simulating approval. |
| `repair` | Restore missing profile structure, provenance or links without broad rewriting. |

## Initialise the stakeholder area

An explicit request to create or discover profiles authorises:

```text
50 People and Organisations
|-- Full Name
|   `-- Full Name - Person Profile.md
`-- Organisation Name
    `-- Organisation Name - Organisation Profile.md
```

If `stakeholder_root` was supplied directly, do not add another `50 People and Organisations`.

Create only named entities, entities approved through bounded discovery or entities supported by sufficient evidence. Do not create empty placeholders, mandatory `People` and `Organisations` containers, a permanent entity index or a copy of this skill.

## Identity and evidence

Resolve entity identity and type before creating or merging a folder.

- Use the evidenced display name and the smallest stable qualifier for genuine namesakes.
- Keep dated role, remit and relationship inside the profile.
- A person speaking in a meeting does not automatically establish an organisation's position.
- Attendance, seniority, directory membership, copied correspondence and silence do not establish endorsement.
- Historical contributions do not establish current decisions, actions or delivery status.
- Without sufficient evidence, state the gap rather than inventing a profile.

Meetings Governance owns meeting retrieval and capture. Use an available Meetings Index and its source links, but do not re-enumerate calendars, download transcripts or build a second meeting archive. If material meeting evidence is missing, either use Meetings Governance when authorised or report the bounded gap.

## Profiles

Use the person or organisation asset and keep the profile proportionate to the evidence.

A person profile covers:

1. perspective;
2. voice and working style;
3. contribution timeline;
4. implications for the work.

An organisation profile covers:

1. identity, remit and relationship;
2. evidenced priorities, positions and constraints;
3. engagement and contribution timeline;
4. connected people and roles;
5. implications for the work.

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
- material claims have source anchors and attribution limits;
- organisation claims are not inferred from one unauthorised person;
- only affected profiles changed;
- meeting evidence was consumed rather than recollected;
- no CRM, personality model, task system, duplicate profile or unrelated root was created;
- repeating the operation without new evidence creates no new files.

Report the profiles created or refreshed, the material change and the remaining evidence gaps.
