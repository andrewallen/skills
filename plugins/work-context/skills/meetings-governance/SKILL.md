---
name: meetings-governance
description: Capture and maintain the governed meeting evidence archive under 40 Meetings (Teams transcripts, meeting chats, recordings, tied email, notes and shared resources), with an anchored context for each meeting. Use to refresh the latest meetings, capture named meetings, or initialise or repair a meeting archive. Not for calendar look-ups, scheduling or a quick one-off meeting summary.
metadata:
  version: "6.6"
  architecture: common-workspace-architecture v2.4
  runtime-dependencies: Direct filesystem or shell access using Windows path conventions; WorkIQ MCP or equivalent authorised Microsoft 365 tools for live discovery and retrieval; an authorised original-file transfer route (provider download tool, returned download URL or configured file-scoped API/CLI; signed-in browser only as a last resort)
---

# Meetings Governance

Maintain the governed meeting evidence under `40 Meetings`. The normal operation is a latest-meeting refresh, not a full historical review.

## Invariants

These hold in every operation. If an action would break one, stop that item and report it.

- Resolve the target from the user's input, never from this skill's location: writing into the installed package corrupts it.
- Never overwrite or delete evidence or owner notes: the archive is only trustworthy if earlier captures survive.
- A speaker is the source's own label, never a guess: misattribution is the error a reader is least able to detect.
- Report a source you could not read as Not captured, never as none found: later decisions rely on absence claims.
- Keep local retention, online review and semantic review separate: each supports a different claim.
- Exhaust non-interactive retrieval routes before any browser route: the browser can interrupt the user.

## Dependencies

- **Local work** uses direct filesystem or shell access for evidence and output files. Work on supplied evidence alone needs nothing else. Never substitute GUI file operations.
- **Live Microsoft 365 access** (calendar, meetings, transcripts, chats, email and shared resources) needs WorkIQ MCP or equivalent authorised tools, configured separately by the client. A connected server or search summary does not prove that exact reads, pagination or downloads work; check those before claiming coverage.
- **Missing access** is reported per source while independent authorised work continues. Inaccessible sources are never reported as absent.
- **Retrieval failures** are handled by the [capture recovery sequence](references/capture.md#0-retrieval-preflight-and-automatic-recovery) in the same run. Discovery, content review and original-file download are separate capabilities, and a wrapper's size or output limit is not a source permission denial. Try the available authorised non-interactive alternatives, including source-specific mail and SharePoint/OneDrive tools, before any browser route.
- **Authority** is never acquired by implication: do not install tools, grant permissions, sign in, switch accounts or request access. Ask once, as soon as the need is clear, for a specific missing authority or approval, naming the affected sources, or about a genuinely ambiguous source.

## Files

| Load | When |
|---|---|
| [../../Common Architecture.md](../../Common%20Architecture.md) | Every run: shared structure, provenance, navigation and migration boundaries. |
| [references/evidence-rules.md](references/evidence-rules.md) | Capturing or reconciling meeting evidence. |
| [references/capture.md](references/capture.md) | Retrieving transcripts, chats, attendance, media, tied correspondence and resources. |
| [references/review-packet.md](references/review-packet.md) | Only for an explicitly requested project-scope or principle-mapping review. |
| [assets/archive-guide.md](assets/archive-guide.md), [assets/meetings-index.md](assets/meetings-index.md) | Creating or repairing controls. |
| [assets/context-record.md](assets/context-record.md), [assets/evidence-frontmatter.md](assets/evidence-frontmatter.md) | Writing meeting records and companions. |

## Default operation: refresh the latest meetings

Unless the user asks for initial backfill, named intake, repair or recalibration:

1. Resolve the meeting root and read the Archive Guide and Meetings Index when present.
2. Use the last completed reconciliation as the starting point; otherwise use a bounded recent window and state it.
3. Find meetings and meeting sources added or changed in that window. Use an occurrence-scoped inventory of relevant source surfaces and linked assets; a semantic search result is a lead, not proof that a collection is complete or empty.
4. Reuse unchanged complete local captures. For sources previously reviewed online but not retained locally, retry local retention within the authorised scope.
5. Capture new or changed evidence, including known inline or hosted media. Automatically recover through available authorised routes when retrieval fails; review authorised online sources when local retention remains unavailable; update affected contexts and update the index once.
6. Report anything not captured, then what changed.

Do not reopen historical scope, regenerate every profile or run classification review during a routine refresh.

## Resolve the target

Never infer the target from this skill's location.

- A supplied `40 Meetings` folder is `meetings_root`. Existing controls identify an archive for assessment, but do not make a differently named root compliant.
- A supplied legacy `Meetings` folder may be read for assessment or consumption. Before new capture there, report the need for approved structural migration; do not silently maintain a competing layout.
- Otherwise the supplied path is `workspace_root` and `meetings_root` is its `40 Meetings` child.
- A blank or absent named target is valid when the user asked to initialise or ingest meetings.
- If the path could be either the workspace root or an unrelated folder, ask one focused question.

## Operations

| Operation | Use |
|---|---|
| `refresh-latest` | Default. Capture meetings and evidence added or changed since the last reconciliation. |
| `targeted-intake` | Capture named meetings and their tied evidence. |
| `initial-backfill` | Establish scope and discover history across a confirmed initial range. |
| `repair` | Restore missing controls, links or incomplete records without implying fresh retrieval. |
| `recalibrate` | Revisit project scope or workspace-principle mappings only when explicitly requested. |

The archive may be:

- `blank`: no guide, index or meeting records;
- `partial`: some structure or evidence exists but required controls or captures are incomplete;
- `established`: guide, index and governed records exist.

## Initialise the meeting archive

An explicit request to initialise or ingest meetings authorises creation of:

```text
40 Meetings
|-- Archive Guide.md
|-- Meetings Index.md
`-- YYYY-MM-DD - Descriptor
    |-- Context.md
    `-- Transcript.md
```

If `meetings_root` was supplied directly, do not add another `40 Meetings`. Create only missing meeting items and resource destinations authorised by the intake. Do not bootstrap unrelated common roots, stakeholder profiles or a local skill copy.

Create occurrence folders only for actual records. Keep audience in metadata/index rows, not mandatory audience folders; do not create format or year/month layers by default. Deferred, excluded or supplementary collections are unnumbered and created only when needed. An authorised migration preserves existing IDs and provenance and repairs approved navigation; it never implies fresh capture.

For a new archive, establish:

- workspace purpose and meeting scope;
- exclusions and adjacent subjects;
- initial range or named occurrences;
- owner, organisation and timezone;
- storage boundary;
- current-work system, or `not specified`.

The Archive Guide may remain provisional until the owner confirms scope.

## Capture meeting evidence

Resolve the exact occurrence before attaching evidence. A title, attendee, keyword or nearby folder is not enough.

For each in-scope meeting:

- attempt to retain every in-scope transcript, meeting or follow-up chat, tied email, note, minute and recap locally as a faithful Markdown companion;
- attempt to retain recordings and shared resources locally in their original form, with their identity and original source link;
- when local retention fails, preserve the canonical source link and observed failure, then use normal authorised platform access to review the source online if possible; include that evidence in the synthesis alongside local sources and state that it was not retained locally;
- record platform-applied classification labels as metadata when exposed; do not infer or interpret classification from markings in source content, and do not treat a platform label alone as a reason to withhold capture or synthesis;
- do not use legacy meeting-class or baseline-impact values to exclude an in-scope source or alter capture; preserve those values in existing records without automatic migration;
- preserve wording, speaker attribution, timestamps, provenance and uncertainty;
- create one context record that links to locally retained evidence and every online-only source considered;
- if online reading also fails, record the source and actual limitation as `Not captured`, never as `none found`;
- keep owner notes untouched.

Use the local capture reference for source-specific retrieval and pagination rules.

For each occurrence, account for the relevant transcript and recording objects, meeting and follow-up chats, tied email, attendance, notes and recaps, shared resources, attachments, and inline or hosted media. Record the bounded surfaces and collections checked, their pagination/change limits, and the outcome for each known source. Distinguish references from unique source objects, verified local originals and content reviewed. A link, metadata record or chat export alone does not close an asset; do not broaden beyond the approved occurrence, dates and storage boundary.

## Classify and index

Assign the five information types from Common Architecture only after reviewing the primary evidence. Keep them distinct from platform classification labels and lifecycle.

Update the Meetings Index once after the affected records are complete. A targeted intake leaves archive-wide inventory status `provisional`.

## Stakeholder handoff

Meeting evidence can support stakeholder profiles, but Stakeholder Governance is optional. When new or corrected evidence materially affects a person or organisation profile, either use that skill when authorised or record the affected entities and source links in the report.

## Advanced operations

- `initial-backfill`: freeze the confirmed range, inventory plausible candidates, resolve exact occurrences and state any coverage gap.
- `repair`: preserve existing evidence and IDs; repair only the missing control, link or provenance field.
- `recalibrate`: use [references/review-packet.md](references/review-packet.md), require owner approval for scope changes and preserve evidence history. Do not remove captured evidence.

## Completion

Check that:

- each requested occurrence has one identity and context;
- every in-scope source had a local-retention attempt;
- the bounded discovery scope and relevant collection/page outcomes are recorded, and every known in-scope asset reference has a disposition; references, unique objects, local originals and reviewed content are not conflated;
- available authorised recovery routes were tried or have a concrete reason they could not be used; a known transport limit did not end the run or trigger a generic request to continue;
- any browser or computer use followed exhaustion of applicable non-interactive MCP/API/download routes, with the reasons recorded and active user input respected;
- online-readable sources that could not be retained locally are linked, identified as online-only review, and considered in the synthesis;
- sources that could not be read online are listed as Not captured with the actual limitation;
- the evidence-coverage table distinguishes each source's local retrieval, online retrieval, semantic review and local retention; archive inventory status does not establish local-retention completeness;
- the index matches the governed records;
- no owner note or non-identical source was overwritten;
- no stakeholder profile or unrelated workspace structure was created;
- repeating the same refresh without new evidence creates no new files.

Report Not captured items and any destination flag first, then meetings added or updated, then any bounded next step.
