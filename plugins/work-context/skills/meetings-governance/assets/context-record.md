# Context record template

Every governed record has a context file. Start from this complete template rather than writing frontmatter from memory: every key must be present, and validation fails if any is missing, including empty relationship keys.

## Frontmatter

```yaml
document_role: meeting-context
template: meeting-context@2.2
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_date:
meeting_id:
meeting_title:
occurrence_type:        # scheduled | ad-hoc | imported-historical
start_time:
end_time:
time_zone:
organiser:
audience:               # internal | external
matched_principles: []  # stable IDs from the Archive Guide
source_identity: {}     # YAML mapping, never a block scalar
sensitivity:
sensitivity_source:
related_transcripts: []
related_chat: []
related_recordings: []
related_artifacts: []
transcript_completeness:
evidence_scope:         # fixed range/cutoff and surfaces checked
evidence_checked_at:    # actual source-inspection time
tags: []
```

Value rules:

- Use `[]`, `none-found`, `not-applicable` or `unknown` rather than omitting a key.
- `unknown` is only for human-readable details that were checked but cannot be established. Never use it, or a filesystem path, as a calendar, call, transcript or document ID.
- `source_identity` is an inline or nested mapping. Local evidence puts paths and hashes here; imported history without modern IDs uses `{status: historical-unscoped}` plus matching evidence and confidence.
- `evidence_checked_at` records actual source inspection. Keep only the precision known; never copy the cutoff into it. Neither it nor `evidence_scope` alone establishes archive-wide completeness.

## IDs and filenames

- ID: `<PROJECT_CODE>-YYYY-MM-DD-HHMM` in owner-local time; add a deterministic short suffix when two occurrences share a minute. Preserve existing IDs.
- New records use one short occurrence folder; companion names identify their role without repeating the project and date:

```text
YYYY-MM-DD - Descriptor
    Context.md
    Transcript.md
    Transcript Part N.md
    Chat.md
    Recording.mp4
```

For a rescheduled or misdated occurrence, name and index the exact occurrence time and preserve the series title and conflict in context.

Add a short time or stable identity qualifier for same-day namesakes. Use these role names where capture references specify typed suffixes. Keep distinct source objects distinguishable. Existing stems, paths and names remain unchanged until an approved migration; preserve identity and repair approved links when moving them.

## Body sections

The context is an anchored map into the transcript and companions, reused by many downstream processes. It must let a reader find, trust and check any part of the meeting without reading the whole transcript, and it must never let AI selection or framing replace the record.

Include all thirteen, in this order; use a concise `none-found`, `not-applicable` or limitation statement when a section is empty.

1. **Historical-record notice.** Identifies the context as **Synthesised (AI-assisted)**, with source links as authority, the actual evidence cutoff and review limitations, and references the configured current-work system (or states that the context does not establish current ownership or status). Add one **Use this for / go to the transcript for** line: for example, positions, follow-ups and locating topics here; exact wording, tone and anything the topic map lists but key points do not cover in the transcript. State the anchor convention once (for example, transcript offsets from 00:00 with the owner-local time of the first segment, and chat or email in clock time).
2. **Neutral summary.** Three to six sentences using neutral verbs: *raised, proposed, asked, supported, questioned, disagreed*. Use *agreed* or *decided* only when an explicit agreement is anchored in section 7. No outcome is asserted that the record does not show.
3. **Topic map.** Contiguous time ranges covering the **whole** transcript, one line each: `start–end · topic · main speakers`. Every part of the meeting appears, including tangents, so nothing is silently dropped. **Synthesised** navigation. For multi-part or multi-object transcripts, name the part in each range.
4. **Purpose and exact source identity.**
5. **Evidence coverage.**

   | Surface | Status | Scope/count | Archive location or limitation |
   | --- | --- | --- | --- |

   Show local retrieval, online retrieval, semantic/visual review and local retention separately. Record the approved occurrence/date scope, relevant surfaces or collections checked, available totals/pages and known change-detection limits. For media and resources, distinguish references from unique source objects, metadata/links from retrieved bytes, and retained originals from reviewed content; give separate counts when available and state when totals or overlaps cannot be established. Retained originals count as local retention; resources are not rendered to Markdown. Any source not retained locally is a **Not captured locally** row, even if it was reviewed online. Link each online-only source and state how it informed the synthesis. A source that could not be read online is a coverage gap, not `none-found`.
6. **Attendance evidence.** **Extracted**, with anchors. Include an **Attribution quality** line: the attribution level per transcript object or part (evidence-rules §3), where the labels come from, any risk signs (shared or room device, generic or anonymous labels, one label carrying several voices, rapid cross-talk fragments), any upgrade attempt, and a plain verdict on what the labels can support. People named in discussion without attributed speech are listed as "no attributed speech", never as absent.
7. **Recorded positions or decisions** (key points). **Extracted**, one row per point:

   | ID | Speaker | Anchor | Point (close paraphrase or short verified quote) | Status |
   | --- | --- | --- | --- | --- |

   - **Speaker** follows the attribution level (evidence-rules §3): the name at level 1; `Label: Name (room device)` at level 2; `Speaker 1` at level 3; `unattributed` at level 4. Never inferred from content. At levels 2–5, quote from the body of a turn, not its first or last few words (evidence-rules §3, turn edges); a very short turn wedged inside another speaker's sentence is treated as part of that sentence with an uncertain boundary, not as a separate point. A follow-up addressed to a named person ("Participant B, can you send…") records the addressee in **Stated owner**, which is extracted, not a guess at the speaker.
   - **Anchor** is the transcript timestamp (plus part) or chat/email message ID and time. No anchor, no key point.
   - **Status** uses the shared decision-status vocabulary: `question`, `request`, `proposal`, `suggestion`, `position`, `claim`, `concern`, `disagreement`, `working-session agreement`, `formal approval` or `evidenced completion`. Keep conditional or situational advice conditional; never restate it as a rule. Where a point depends on reading a garbled or ambiguous passage, say so in the row.
   - **Selection is rule-based, not AI judgement:** include every explicit proposal, request, question to be answered, agreement, disagreement or concern, follow-up commitment, figure or statistic, factual claim, and statement bearing on the Archive Guide's working principles. If in doubt, include it.
8. **Historical follow-up mentions.** Same columns as key points, plus **Stated owner** and **Stated due** exactly as said (`not stated` otherwise; never infer an owner). Attributed source mentions, not new assignments or proof of completion.
9. **Questions, claims and evidence anchors**, when material. Each with speaker and anchor.
10. **Observations** _(Inferred)_. Patterns across the meeting that go beyond any single statement: emphasis, convergence, shifts, tensions, unanswered questions. Each gives the anchors it rests on and a plain caveat; observations that depend on speaker labels say so when attribution needs caution. Meeting-level only: never judgements about a person's character or motives. **Suggested speakers** for level 2–4 passages go here as a short list (`anchor · label · suggested person · cue · corroborated or not`), using only the strong cues in evidence-rules §3, and never change the speaker column. Cross-meeting links (such as "continues from" or "relates to") belong here or are labelled **Inferred**. The reader may reject any observation.
11. **Owner notes.** What the archive owner thinks mattered, in their words, attributed to them and dated. Created empty (`_None yet._`) for the owner to fill. The skill never writes, edits, reorders or removes owner notes; later runs preserve them verbatim. Downstream use treats them as the owner's view, not as source evidence.
12. **Resource dispositions.** The resource table from [capture.md](../references/capture.md). Preserve each occurrence/message reference when deduplicating the same payload. For inline or hosted media, report references and distinct resolved objects separately where countable, and state whether its bytes were retained and whether the content was reviewed. A message body, metadata record or hosted-content link alone does not establish that the image bytes were captured.
13. **Provenance, uncertainty and limitations.** Source dependence, reporting chains and actual review scope. Interpretation is labelled **Inferred**. Any requested new advice goes in a separate **Proposed / Recommendation** subsection, never in the neutral account. Operational detail (message IDs, versions, ETags, access errors and reconciliation notes) goes last, under a **Capture log** subheading, so it does not crowd the content.

Replace `<CURRENT_SKILL_VERSION>` when creating the context. Preserve `created_by` and update `last_governed_by` only after a material update or validation. Legacy contexts keep their existing fields, sections, evidence, IDs and historical class/baseline values; do not migrate them automatically or use legacy class values to determine capture or routing. New contexts omit class and baseline fields.

For new or materially updated Markdown companions, add a brief provenance note outside the preserved source body: dominant information type, original author/source, capture or derivation method and material limitations.
