# Capture rules

Load when capturing or reconciling an occurrence's evidence. Frontmatter schemas are in [evidence-frontmatter.md](../assets/evidence-frontmatter.md).

## Contents

1. Transcripts
2. Chats
3. Attendance and meeting details
4. Recordings, renderings and recaps
5. Tied email, notes and follow-up
6. Reusable resources

## 1. Transcripts

Recognise official Teams transcript objects, recording-backed transcripts, customer-supplied transcript documents, indexed transcript renderings, local exports and transcripts derived from audio.

- Prefer authoritative transcript text. Derive from audio when none exists and tooling permits. An audio-derived transcript is **Captured** with an identified derivation method, not a word-perfect record: mark uncertain words and unresolved speakers. Summarising it is **Synthesised**; filling gaps by reasoning is **Inferred** and never inserted as speech.
- Every transcript read is saved in full as a Markdown `[Transcript]` companion, whatever its label or marking (evidence-rules Key guidance). Reading remotely without saving is not capture.
- Enumerate all transcript objects; the first may be incomplete. Record object ID, call ID, source, segment counts, time bounds, pagination state and retrieval time.
- Detect restarts, repeated cursors, non-advancing pages and overlaps. Keep objects separate unless ordering and overlap are proven.
- Cross-check the occurrence's chat/call lifecycle IDs against the transcript collection before declaring occurrence-level completeness. A fully read object may cover only one call; another call or restart under the same occurrence stays an explicit gap until resolved.
- Split one large source only when tool or document limits require it, using explicit non-overlapping ranges with preserved totals and boundaries. Keep one file per source object or proven range and record their relationships.
- Preserve wording, timestamps, speakers, language and unattributed segments. Record gaps rather than inventing transitions.
- Record the **attribution level** (evidence-rules §3) in the transcript companion's `speaker_attribution` field, per object or part. Before accepting level 3–4 attribution for a material meeting, try the upgrade routes once: a recording with audio (for a fresh diarised transcript, where tooling permits), and an organiser-side or participant-side transcript, notes or minutes with better labels. A Teams recap, AI notes or a transcript rendering built from the same transcript is not an upgrade. Record each route tried and its outcome in the context; a search that finds nothing is "not found", not proof of absence. Do not repeat the attempt unless new evidence of a better source appears.
- Never replace an existing transcript because another attendee cannot retrieve it.
- `time_bounds` holds the first and last evidence timestamps. With only relative timestamps, keep relative bounds; add absolute bounds only when transcript, recording or lifecycle metadata supplies an explicit anchor. Never add relative offsets to the scheduled start.
- Do not infer a platform-specific `source_type` from a generic export; use `local-transcript-export` or `local-chat-export` unless the source establishes the platform.
- Retain transcript DOCX files under the matching audience `docx` folder. Other formats may sit beside the meeting evidence with a typed suffix.

**Semantic review.** Start with modest text pages (typically 50–100 segments), shrinking as needed; read every returned segment in each claimed range. Use small structured boundary/anchor reads for exact timestamps, speaker metadata and citations that text mode omits. Count unique source segments, not repeated anchor reads or result-arrival order. Record reviewed ranges and the anchors behind content-dependent conclusions in the evidence table, separately from retrieved and retained coverage.

## 2. Chats

- Retrieve every page of the exact meeting or participant chat.
- Preserve substantive non-system messages chronologically, plus lifecycle events establishing call, transcript, recording or recap identity. Keep sender, created and modified times, wording, attachments and source identity.
- For recurring threads, isolate the occurrence using lifecycle markers and time boundaries. A shared series or chat ID is a source, not an occurrence key; never mix adjacent occurrences.
- On later runs, re-enumerate the whole occurrence window so edits and replaced attachments are found. `latest_message_at` alone does not prove nothing changed. A creation-date boundary does not review edits or deletions to older messages; state the actual scope.
- Preserve deletion/tombstone metadata where relevant without reconstructing absent wording.
- If no total count is available, say so. Exhausted pagination proves the returned query's coverage only (see the retrieval playbook's known-change check).
- Create a chat file whenever the exact occurrence chat has substantive content or lifecycle identity; save every substantive message in full. When an exact read finds nothing worth keeping, record `none-found` in the context instead of an empty file.

## 3. Attendance and meeting details

The context distinguishes: scheduled from actual transcript/recording time; organiser from attendees; invitees from evidenced attendance; attendance-report participants from attributed speakers; identified speakers from unresolved labels; original title from the filename descriptor.

Attendance evidence comes from transcript attribution, attendance reports and call lifecycle records. Invitation status alone is insufficient, and absence of attributed speech is not absence from the meeting. Do not claim a complete attendance list while unattributed speakers or partial coverage remain. Speakers come only from source labels (evidence-rules §3); record attribution risks rather than reassigning speech.

## 4. Recordings, renderings and recaps

Classify media from inspected duration, streams and audio before naming or relying on it:

| Media class | Meaning | Suffix |
| --- | --- | --- |
| `full-recording` | Meeting audio/video recording | `[Recording]` |
| `recording-continuation` | Proven later part of the same occurrence | `[Recording Part N]` |
| `silent-recording` | No recoverable substantive audio | `[Silent Recording]` |
| `transcript-rendering` | Video rendering of transcript text, often silent | `[Transcript Rendering]` |
| `related-demo` | Separate demonstration referenced by the meeting | `[Related Demo Recording]` |
| `recap-pointer` | Recap or summary source | `[Recap]` |

- A rendering, silent capture or placeholder is not a full recording, and never substitutes for a distinct full recording.
- Preserve accessible media under the meeting descriptor, with an authoritative pointer when a URL exists. If download is blocked, keep the pointer and record owner, tenant, object and error.

## 5. Tied email, notes and follow-up

Communication is tied to an occurrence only through a thread, meeting or call ID, join URL, named artefact, explicit meeting reference or otherwise unambiguous context. Participant or keyword proximity is insufficient. The window may extend after the meeting while the same thread discusses its outputs; recheck such threads during reconciliation.

Create typed companions for every tied communication that materially supports the meeting, saving the full text in Markdown: `[Email]`, `[Follow-up Email]`, `[Follow-up Chat]`, `[Recap]`, `[Notes]`, `[Attendance]`.

- Preserve source identity, author, timestamps, sensitivity, thread relationship, reporting chain and attachment disposition.
- State whether the companion preserves an original, selects passages or newly summarises.
- A later summary is supplementary unless the meeting explicitly incorporated it.

## 6. Reusable resources

Classify every URL and attachment encountered in approved occurrences once. Resources (presented or shared documents, decks, spreadsheets, PDFs, Loop and web pages) are **referenced, not rendered**: keep the original file or link, record identity and use, and never convert them to Markdown (evidence-rules Key guidance 2). Reuse resolved equivalents and mark incidental navigation without opening it. This is not licence for recursive browsing.

| Disposition | Meaning |
| --- | --- |
| `captured` | The original file (where one is available) and the source pointer are saved in the resource folder, with stable identity. The default for every accessible in-scope resource. No Markdown rendering is made. (A storage outcome: its contents are not thereby all **Captured** information.) |
| `existing` | The same source or payload already exists in the resource corpus |
| `incidental` | Navigation, sign-in, reaction, media placeholder or other non-resource URL |
| `inaccessible` | The original could not be saved or its identity resolved (for example access denied); pointer, route and error retained. A Not-captured item. |
| `pending-source` | A named or promised resource has not been supplied. A Not-captured item. |
| `not-uniquely-resolved` | Evidence cannot identify one authoritative resource. A Not-captured item. |

`pointer-only` is retired: record an accessible resource as `captured` (original plus pointer) and anything else as a Not-captured disposition. Markdown renderings of resources are not made; a resource's substance enters the archive through the meeting evidence that discusses it.

For each resource:

1. Preserve the exact observed URL.
2. Resolve stable drive, item or document identity where possible.
3. Determine provenance from content attribution and source evidence. Original or received reusable resources belong in `source_material_root`, regardless of whether they were externally or owner-organisation authored; record that provenance explicitly. New meeting contexts and recaps stay under `meetings_root`; broader analysis, drafts and AI-assisted material belong in `working_material_root`. Exact versions intentionally circulated are referenced and registered in `issued_outputs_root`, not copied by this skill. Meeting audience and resource provenance are independent.
4. Check for an existing equivalent by identity, version or hash; deduplicate payloads while keeping per-meeting provenance. One file set per source: later meetings link to it. Create a new set only when a meeting used a materially different version, with the same descriptor, a version tag and that version's first-seen date.
5. Save or retain the original file and a `.url` pointer where available, subject to the authorised storage boundary. Do not create a Markdown rendering of the resource or move an existing source without approval.
6. Link each meeting that used or referenced it.
7. Record a Not-captured item when capture is blocked or unresolved.

Keep access and retention separate, and reconcile resource dispositions before finishing.

Retry `inaccessible`, `pending-source` and `not-uniquely-resolved` during every reconciliation.

Name newly captured resources `YYYY-MM-DD - <Type>, <Descriptor>.<ext>`, with the original file and `.url` pointer sharing one stem. Use the date first presented or captured for this workspace unless source metadata establishes a better one. Keep the original filename in provenance.

Context resource table:

| Source message/time | Resource | Provenance | Disposition | Archive location or limitation |
| --- | --- | --- | --- | --- |
