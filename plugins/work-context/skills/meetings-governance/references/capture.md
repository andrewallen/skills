# Capture rules

Load when capturing or reconciling an occurrence's evidence. Frontmatter schemas are in [evidence-frontmatter.md](../assets/evidence-frontmatter.md); filenames are in the [context record](../assets/context-record.md#ids-and-filenames). Current tool limits and quirks are in [known-tool-behaviour.md](known-tool-behaviour.md); check it before choosing a transfer route.

**When local retention fails.** Every section below uses the same fallback from [evidence-rules.md](evidence-rules.md#key-guidance-local-first-meeting-capture-and-online-review) (Key guidance 4 and 5): keep the canonical source link and the observed error; if the source is still readable through normal authorised platform access, review it online, use it in the synthesis and mark it **Not captured locally**; if it cannot be read online either, record it as **Not captured** with the actual limitation. Sections refer to this as *the fallback*.

## Contents

0. Retrieval preflight and automatic recovery
1. Transcripts
2. Chats
3. Attendance and meeting details
4. Recordings, renderings and recaps
5. Tied email, notes and follow-up
6. Reusable resources

## 0. Retrieval preflight and automatic recovery

Apply this sequence to every source type below, within the approved occurrence, date range and storage boundary. It implements local-first capture and online review; it does not widen access or research scope.

### Bound discovery and close known assets

The aim is to account for every asset of the approved occurrence, and nothing beyond it.

- **Start from what is known:** the exact occurrence identities, the approved date or change window, known source IDs, relevant containers and the storage boundary.
- **Inventory the occurrence's surfaces:** calendar and meeting identity; every transcript and recording object; meeting and follow-up chats or channels, with replies; tied email; attendance; notes and recaps; shared resources and attachments; supplied evidence. Include inline images and hosted media referenced in message bodies or hosted-content relationships, because an empty attachment collection does not mean a message has no images.
- **Enumerate collections exactly.** Use exact entity reads and follow continuation pages to the end. Record the collection, filter or window, page outcome, available total and any known limit. Semantic search and path discovery find candidates only; they never prove completeness or absence. When a search miss conflicts with known evidence, make an exact in-scope read rather than a broader tenant or filesystem search.
- **Detect changes in a refresh.** Use the change window to find candidates, then compare known source identities and versions, including older objects where available, to catch edits and replaced assets. A creation-date boundary or latest-message time does not prove older content is unchanged. Use change markers or exact reads where supported; otherwise state the change-detection limit.
- **Resolve and deduplicate.** Resolve each reference to an authoritative identity and version where available. Store identical objects once but keep every occurrence and message relationship. Count references, unique objects and retained originals separately.
- **Close every reference** with one outcome: verified local original, already-retained equivalent, online-only review, unresolved identity, or a specific not-captured limitation. If an authorised route can retrieve an accessible asset's payload, retrieve it rather than leaving a link. Continue with independent sources when one is blocked.

### Establish the available routes once

- Inspect the actual tool schemas for discovery, exact reads, full-text retrieval and pagination, original-byte download, local writing and online viewing. Discover an unknown path before calling it. Prove one small request before repeating it across sources, and record a schema or transport limit once rather than rediscovering it.
- Look beyond WorkIQ for source-specific tools: mail attachment tools for email; SharePoint and OneDrive tools for drive items, metadata and download links. If the client has an on-demand tool registry, load the relevant already-authorised toolsets before declaring a capability missing. This does not permit installing or persistently configuring servers, acquiring scopes or consenting to access. A metadata-only tool may still resolve a download link.
- Take entity IDs from an authoritative collection or exact record. A search citation, title or retrieval `resourceId` is not automatically a drive item, message, call or transcript ID. Keep paired IDs from the same record and preserve their case.
- Before downloading, check retained evidence by source identity and version. Reuse an unchanged complete capture. A similarly named local file is not the same source, and unrelated folders are out of scope.
- For a binary source, read its size, original filename and type, canonical URL, version or ETag or modified time, content hash and any download-URL field before choosing a transfer. Read each tool's schema for its inline cap rather than assuming one. Never send a known oversized original to a capped route, and do not mistake a tool's cap for a SharePoint, OneDrive or mailbox limit.

### Recover in the same run

Retrying through another already-authorised route is part of the user's request, so do it without asking. Use the next suitable route, not every conceivable one:

| Observation | Next action |
|---|---|
| Unknown or unsupported path, invalid filter, mismatched IDs or rejected continuation | Check the schema, path and resolved IDs, then correct the call or use a supported dedicated endpoint once. A wrapper refusing a path is not a source permission denial. |
| Inline binary cap, base64 response limit or known oversized original | Go straight to the original-file routes below. Text pagination, repeated inline calls and `format=pdf` do not retain an oversized original; a converted PDF or preview is a separate derivative. |
| Host output truncated or saved to a tool-output file | Recover the complete structured result or the exact output file; the on-screen preview is only a prefix. Parse that file as JSON with shell tools, then decode the field. Never extract base64 with a text pattern, because serialisers escape characters inside it, and never assemble a file from truncated snippets. If the full payload is unavailable, use a direct transfer for binaries or smaller pages for text. |
| Timeout, transient failure or throttling | Retry once when safe, respecting `Retry-After`. If the delay is too long, park that source, continue independent work, then try another supported route. Do not loop. |
| No search hit for a known source, or an empty result that conflicts with known evidence | Make the exact entity, occurrence or attachment read within scope. Do not widen into other meetings or browse links recursively. |
| Missing authentication, consent, download capability or tool approval | Try other already-authorised non-interactive routes and continue independent sources. If completion still needs the user (for example approval for a last-resort browser download), ask once, as soon as that is clear, naming every waiting source. Do not install a server, obtain scopes or switch account. |
| `401`/`403`, a sign-in page or an empty body from a plain HTTP client or an unsuitable token | A route failure, not a source verdict. Remember it for that route, credential and host for the rest of the run, and continue other non-interactive routes. Do not record a denial or stop. |
| Confirmed source denial, blocked download or technical protection | Confirmed only when the source refuses the signed-in user: an access-denied page in the user's own browser session, or an access-denied result from an authenticated, file-scoped tool for the exact item. Stop trying for that content and record the limitation. Do not rotate accounts, request access, alter sharing, guess URLs or unpack or decrypt local copies. A permitted online preview can still support a separately recorded review; it is not permission to extract blocked bytes. |

### Original-file transfer routes

Take the first route that saves the exact bytes within the authorised boundary and passes verification. Try the non-interactive routes 1 to 3, or record a concrete reason each cannot be used, before either browser route, because the browser routes can interrupt the user. Opening a URL from the shell still uses the user's browser.

1. **A provider tool that returns the complete original:** one that writes the file to a named local path, or returns it whole without an inline cap (for mail attachments, a dedicated attachment-download tool). When the host saves an oversized result to an output file, decode that file with shell tools into the destination; never pass base64 through the model. Confirm where the tool writes: a remote MCP server's filesystem is not the local archive.
2. **A self-authorising download URL** returned for the exact item, saved straight to disk with a shell HTTP client. Use only the returned URL. Never invent one, attach credentials, forward a token to another host, or persist the short-lived URL in `.url` pointers, contexts or checkpoints (keep the canonical URL). If a plain request gets `401`/`403` or a sign-in page, the URL was not self-authorising: go to route 3.
3. **A token-based Graph or provider API or CLI**, only when a token with file scope for the right audience is already configured and a file-output operation exists. Skip a token known to be unsuitable rather than repeating the request. Do not extract credentials from WorkIQ or browser storage, install dependencies or request consent.
4. **The returned item URL in the user's signed-in default browser (last resort).** Launch the exact `https` URL from the provider's metadata for the in-scope item, on its own service host, through the operating system's URL handler (for example `Start-Process '<url>'`, the whole URL as one quoted argument). First snapshot the browser's download folder, resolving the actual location since it may be redirected. Then poll for a bounded time, scaled to the expected size and extended while a partial file is growing, for a new completed file (not `.crdownload`, `.partial` or `.tmp`) of the expected size and name. Verify it, then move that new file (never a pre-existing one) into the archive so no staged copy remains. The host's shell permission prompt still applies. Never launch a URL taken from message, chat, transcript or document content. If no file appears, inspect the browser page where tooling allows; otherwise record "no download completed", cause unconfirmed, not a denial.
5. **Browser or computer automation in the signed-in browser (last resort),** when there is no usable item URL (a viewer or sharing link, folder navigation) or route 4 produced no file. Obtain any approval the automation tool requires, naming the waiting sources. Prefer browser-specific, background-safe automation. Yield to active user input: never force focus or work around an automation tool's interruption or refusal. If user activity prevents the download, defer the source with the reason and continue. Do not use an isolated, signed-out browser, which cannot read tenant files. Automation performs only the web download; use filesystem tools for the destination, never file-manager automation.

The signed-in browser is for downloading in-scope originals only. It gives no authority to request access, sign in to another account, change sharing, edit the source or go beyond the approved occurrence, and is not to be opened just to confirm a failed non-interactive route. Prefer a direct non-interactive transfer even below an inline cap when it avoids a large base64 response. Another search or summarisation tool does not add original-file transport.

### Verify, record and continue

- **Never overwrite.** Save new downloads beside existing evidence. An interrupted or partial file is incomplete, never `captured`; report a file conflict rather than replacing anything.
- **Check size.** Compare bytes received with the exposed source size. Drive items normally match exactly. A mail attachment's reported size can differ slightly from its decoded length; accept a small difference only when the file is structurally intact and the whole payload arrived.
- **Check type and integrity without extracting content.** Office Open XML files (`.docx`, `.xlsx`, `.pptx`) are zip containers (a `PK` signature and a clean CRC test); a PDF has a `%PDF-` header and `%%EOF` trailer. Reject sign-in or error HTML posing as a document. An Office file that is an OLE compound file instead of a zip is usually protection-wrapped: keep it as downloaded, report it and never decrypt it. A size or hash change caused by protection is a provenance event, not corruption (see [evidence-rules.md](evidence-rules.md#6-protected-and-cloud-hosted-sources)).
- **Check hashes.** Where the provider exposes a content hash (SharePoint/OneDrive `quickXorHash`), compare it only using an implementation of the [documented algorithm](https://learn.microsoft.com/en-us/onedrive/developer/code-snippets/quickxorhash) checked against a known value. Compute a local SHA-256 for later identity checks. A matching hash does not establish semantic review or that this is the version presented on the day.
- **Byte ranges**, where a route supports them, must be bound to one source version, with `206`/`Content-Range`, non-overlapping ranges and the final size verified. A `200` response may be the whole file; never append it as a range. Reject the assembly if the version changes.
- **Versions.** Compare version, ETag or modified metadata before and after retrieval where available. Never label a current deck as the version presented without evidence. Do not edit, resave or convert a source to make it downloadable.
- **Record** attempted routes, actual errors and times, the saved path and its verification, any online review and the remaining blocker in the context's Capture log and coverage rows. Do not create a manifest, copy credentials or put source bodies in checkpoints.
- **Finish each source** as verified local retention or an explicit gap, applying the fallback where retention fails, then move on. Preserve good prior evidence and checkpoint the exact pending source or range before a handoff.

## 1. Transcripts

Recognise official Teams transcript objects, recording-backed transcripts, customer-supplied transcript documents, indexed transcript renderings, local exports and transcripts derived from audio.

- **Source.** Prefer authoritative transcript text; derive from audio only when none exists and tooling permits. An audio-derived transcript is **Captured** with its derivation method stated, not a word-perfect record: mark uncertain words and unresolved speakers. Summarising it is **Synthesised**; filling gaps by reasoning is **Inferred** and is never inserted as speech.
- **Retention.** Save every transcript read in full as `Transcript.md` (or `Transcript Part N.md`) using the transcript schema, applying the fallback if saving fails. Keep original transcript files beside the companions, with short distinguishable names and no format or audience layers.
- **Completeness.** Enumerate every transcript object, because the first may be incomplete. Record object ID, call ID, source, segment counts, time bounds, pagination state and retrieval time. Detect restarts, repeated cursors, non-advancing pages and overlaps, and keep objects separate unless order and overlap are proven. Cross-check the occurrence's chat and call lifecycle IDs against the transcript collection: a fully read object may cover only one call, and another call or restart stays an explicit gap until resolved.
- **Splitting.** Split a large source only when tool or document limits require it, with explicit non-overlapping ranges and preserved totals and boundaries. Keep one file per source object or proven range and record their relationships.
- **Fidelity.** Preserve wording, timestamps, speakers, language and unattributed segments. Record gaps rather than inventing transitions. Never replace an existing transcript because another attendee cannot retrieve it.
- **Attribution level.** Record the level ([evidence-rules §3](evidence-rules.md#3-applying-the-taxonomy)) in `speaker_attribution`, per object or part. Before accepting level 3 or 4 for a material meeting, try the upgrade routes once: a recording with audio for a fresh diarised transcript, where tooling permits; an organiser-side or participant-side transcript, notes or minutes with better labels. A recap, AI notes or rendering built from the same transcript is not an upgrade. Record each route tried and its outcome; a fruitless search is "not found", not proof of absence. Repeat only if new evidence of a better source appears.
- **Times.** `time_bounds` holds the first and last evidence timestamps. With only relative timestamps, keep relative bounds; add absolute bounds only when transcript, recording or lifecycle metadata supplies an explicit anchor. Never add relative offsets to the scheduled start.
- **Source type.** Do not infer a platform-specific `source_type` from a generic export; use `local-transcript-export` or `local-chat-export` unless the source establishes the platform.

**Semantic review.** Read in modest text pages (typically 50 to 100 segments), shrinking as needed, and read every returned segment in each claimed range. Use small structured boundary reads for exact timestamps, speaker metadata and citations that text mode omits. Count unique source segments, not repeated anchor reads. Record reviewed ranges, and the anchors behind content-dependent conclusions, separately from retrieved and retained coverage.

## 2. Chats

- Retrieve every page of the exact meeting or participant chat.
- Preserve substantive non-system messages in order, plus lifecycle events that establish call, transcript, recording or recap identity. Keep sender, created and modified times, wording, attachments and source identity.
- For recurring threads, isolate the occurrence by lifecycle markers and time boundaries. A shared series or chat ID is a source, not an occurrence key; never mix adjacent occurrences.
- On later runs, re-enumerate the whole occurrence window so edits and replaced attachments are found. Neither `latest_message_at` nor a creation-date boundary proves older messages are unchanged; state the actual scope.
- Preserve deletion and tombstone metadata where relevant, without reconstructing absent wording.
- If no total count is available, say so. Exhausted pagination proves only the returned query's coverage (see the known-change check in the [retrieval playbook](evidence-rules.md#4-retrieval-playbook)).
- Inspect the full message body and hosted-content relationships as well as attachment metadata. Retrieve hosted images only through a supported authorised byte route, using the exact hosted-content identity; an HTML image reference or metadata is not image retention. If bytes cannot be retrieved, keep the reference and limitation and leave the image as an open asset outcome.
- Create `Chat.md` whenever the occurrence chat has substantive content or lifecycle identity, using the chat schema and saving every substantive message in full; apply the fallback if saving fails. When an exact read finds nothing worth keeping, record `none-found` in the context instead of creating an empty file.

## 3. Attendance and meeting details

The context distinguishes: scheduled from actual transcript or recording time; organiser from attendees; invitees from evidenced attendance; attendance-report participants from attributed speakers; identified speakers from unresolved labels; original title from the filename descriptor.

Attendance evidence comes from transcript attribution, attendance reports and call lifecycle records. Invitation status alone is not attendance, and absence of attributed speech is not absence from the meeting. Do not claim a complete attendance list while unattributed speakers or partial coverage remain. Speakers come only from source labels ([evidence-rules §3](evidence-rules.md#3-applying-the-taxonomy)); record attribution risks rather than reassigning speech.

## 4. Recordings, renderings and recaps

Classify media from its inspected duration, streams and audio before naming or relying on it:

| Media class | Meaning | Filename |
| --- | --- | --- |
| `full-recording` | Meeting audio/video recording | `Recording.<ext>` |
| `recording-continuation` | Proven later part of the same occurrence | `Recording Part N.<ext>` |
| `silent-recording` | No recoverable substantive audio | `Silent Recording.<ext>` |
| `transcript-rendering` | Video rendering of transcript text, often silent | `Transcript Rendering.<ext>` |
| `related-demo` | Separate demonstration referenced by the meeting | `Related Demo Recording.<ext>` |
| `recap-pointer` | Recap or summary media source | `Recap Recording.<ext>` |

- A rendering, silent capture or placeholder is not a full recording and never substitutes for one.
- Retain accessible media in the occurrence folder, with an authoritative pointer when a URL exists. Use the recording schema for any Markdown recording companion. If download is blocked, keep the pointer and record owner, tenant, object and error, then apply the fallback.

## 5. Tied email, notes and follow-up

Communication is tied to an occurrence only through a thread, meeting or call ID, join URL, named artefact, explicit meeting reference or otherwise unambiguous context. Participant or keyword proximity is not enough. The window may extend past the meeting while the same thread discusses its outputs; recheck such threads during reconciliation.

Save a typed companion, in full Markdown, for every tied communication that materially supports the meeting, applying the fallback if saving fails:

| Companion filename | Schema |
|---|---|
| `Email.md` | `meeting-email-companion` |
| `Follow-up Email.md` | `meeting-follow-up-email-companion` |
| `Follow-up Chat.md` | `meeting-follow-up-chat-companion` |
| `Recap.md` | `meeting-recap-companion` |
| `Notes.md` | `meeting-notes-companion` |
| `Attendance.md` | `meeting-attendance-companion` |

- Preserve source identity, author, timestamps, any platform-applied classification label (as metadata), thread relationship, reporting chain and attachment disposition. Do not infer classification from markings in the content.
- State whether the companion preserves an original, selects passages or newly summarises.
- A later summary is supplementary unless the meeting explicitly incorporated it.

## 6. Reusable resources

Resources (presented or shared documents, decks, spreadsheets, PDFs, Loop and web pages) are **referenced, not rendered**: keep the original file or link and record its identity and use, but never convert it to Markdown (evidence-rules Key guidance 2). Classify every URL and attachment in an approved occurrence once. Reuse resolved equivalents and mark incidental navigation without opening it; this is not licence for recursive browsing.

| Disposition | Meaning |
| --- | --- |
| `captured` | The original file (where one exists) and source pointer are saved under `sources_root` with stable identity. The default for every accessible in-scope resource. A storage outcome: the contents are not thereby all **Captured** information. |
| `existing` | The same source or payload already exists in the resource corpus. |
| `incidental` | Navigation, sign-in, reaction, media placeholder or other non-resource URL. |
| `inaccessible` | The original could not be saved or its identity resolved; pointer, route and error retained. Not captured locally; apply the fallback. |
| `pending-source` | A named or promised resource has not been supplied. Not captured. |
| `not-uniquely-resolved` | Evidence cannot identify one authoritative resource. Not captured. |

A source link alone is not local capture. Older records may carry the legacy value `pointer-only`: preserve it, and record new resources as `captured` or a not-captured disposition.

For each resource:

1. Preserve the exact observed URL.
2. Resolve stable drive, item or document identity where possible.
3. Determine provenance from content attribution and source evidence. Original or received resources belong in `sources_root`, whether externally or owner-organisation authored; record that provenance. New contexts and recaps stay under `meetings_root`; broader analysis, drafts and AI-assisted material belong in `working_root`. Exact circulated versions are referenced and registered in `issued_outputs_root`, not copied by this skill. Meeting audience and resource provenance are independent.
4. Check for an existing equivalent by identity, version or hash. Store one file set per source and link later meetings to it; create a new set only when a meeting used a materially different version, with the same descriptor, a version tag and that version's first-seen date.
5. Save the original file and a `.url` pointer to its canonical source, within the authorised storage boundary. Use the [recovery sequence](#0-retrieval-preflight-and-automatic-recovery) for failed or oversized transfers and verify the payload before marking it `captured`. Do not move an existing source without approval.
6. Link each meeting that used or referenced it.
7. Record a not-captured item when capture is blocked or unresolved.

Name new resources `YYYY-MM-DD - <Type>, <Descriptor>.<ext>`, with the original and its `.url` pointer sharing one stem. Use the date first presented or captured for this workspace unless source metadata establishes a better one, and keep the original filename in provenance.

**Media and images.** Treat attachments, linked files, inline images and platform-hosted media as distinct payload classes, even from one message. For hosted images, keep the message reference, hosted-content metadata and retrieved bytes distinct. A platform-hosted rendition may differ from the original camera file, so do not claim original-camera provenance without evidence. When an image or scan needs content review, use supported visual inspection or OCR, record the pages and limitations, and label OCR as a derived review aid.

**Reconciliation.** Keep local access, online review and local retention separate, and reconcile dispositions before finishing. Retry retention for `inaccessible`, `pending-source` and `not-uniquely-resolved` on every reconciliation.

**Resource table.** Keep per-occurrence references even when payloads are deduplicated. Where hosted media is present, give reference counts and distinct resolved objects separately when countable. Distinguish retained bytes from preserved metadata or links and from review, and record unknown totals and unresolved overlaps rather than implying completeness.

| Source message/time | Resource | Provenance | Disposition | Archive location or limitation |
| --- | --- | --- | --- | --- |
