# Capture rules

Load when capturing or reconciling an occurrence's evidence. Frontmatter schemas are in [evidence-frontmatter.md](../assets/evidence-frontmatter.md).

## Contents

0. Retrieval preflight and automatic recovery
1. Transcripts
2. Chats
3. Attendance and meeting details
4. Recordings, renderings and recaps
5. Tied email, notes and follow-up
6. Reusable resources

## 0. Retrieval preflight and automatic recovery

Apply this sequence to every source type below, within the approved occurrence, date range and storage boundary. It implements the existing local-first capture and online-review rules; it does not expand access or research scope.

### Bound discovery and close known assets

- Start with the exact occurrence identities, approved date/change window, known source IDs, relevant containers and storage boundary. Inventory the occurrence-related surfaces: calendar/meeting identity, every transcript and recording object, meeting and follow-up chats or channels and replies, tied email, attendance, notes and recaps, shared resources, attachments, and supplied evidence. Include inline images and hosted media referenced in message bodies or hosted-content relationships; an empty attachment collection does not establish that a message has no images.
- Use exact entity reads and enumerate supported collections through their continuation pages. Record the collection or surface, filter/window, page or continuation outcome, available total, and known limit. Semantic search and path discovery identify candidates; neither proves exhaustive enumeration or absence. A search miss conflicting with known evidence requires an exact in-scope read, not a broader tenant or filesystem search.
- In a refresh, use the bounded change window to discover candidates, and compare known in-scope source identities/versions—including exact older objects where available—to detect relevant edits and replaced assets. A creation-date boundary or latest-message timestamp alone does not prove that older content was unchanged. Use source change markers or exact reads when supported; otherwise state the change-detection limit.
- Resolve each reference to an authoritative source identity and version where available. Deduplicate identical source objects for storage, while retaining every occurrence/message relationship. Keep counts of references distinct from counts of unique source objects and retained originals.
- Give each known reference an outcome: verified local original, already-retained equivalent, online-only review, unresolved identity, or a specific not-captured limitation. Do not leave an already-authorized, accessible asset as a link-only observation when an applicable route can retrieve its payload. Continue independent sources when one is blocked.

### Establish the available routes once

- Inspect the actual tool schemas for discovery, exact entity/metadata reads, full-text retrieval and pagination, original-byte download, local file writing and online viewing. Discover unknown paths before calling them. Prove a small supported request before applying it across sources; do not repeatedly rediscover the same schema or transport limitation.
- Include available source-specific alternatives, not only WorkIQ: dedicated mail attachment tools for email, and SharePoint/OneDrive tools for drive items, metadata and download links. If the configured client has an on-demand tool registry, discover and load the relevant already-authorised toolsets there before declaring a capability missing. This is not permission to install or persistently configure servers, acquire new scopes or consent to access. A metadata-only tool may resolve a download link without carrying the file itself.
- Resolve real entity IDs from an authoritative collection or exact record. A search citation, title or retrieval `resourceId` is not automatically a drive item, message, call or transcript ID. Keep paired IDs from the same record and preserve their case.
- Check existing retained evidence by source identity and version before downloading again. Reuse an unchanged complete capture; do not scan unrelated folders or treat a similarly named local file as the same source.
- For binary sources, read exposed size, original filename/type, canonical source URL, version/ETag or modified time, any content hash and any download-URL field before choosing a transfer. If a narrowed field selection omits the download-URL fields (observed with WorkIQ item reads), read the item record without that selection. The currently exposed WorkIQ `fetch_blob` limits the raw file to **4 MB** and returns base64, for email attachments as well as drive files. Other tools that return inline base64 document their own limits (some about 5 MB), so read each schema rather than assuming. Do not submit a known oversized original to a capped route, repeat the same capped request for every large file, or mistake the cap for a SharePoint/OneDrive or mailbox limit.

### Recover in the same run

Do not stop at the first failed wrapper or ask whether to try alternatives already within the user's request. Use the next available authorised route, not every conceivable route:

| Observation | Next action |
|---|---|
| Unknown/unsupported path, invalid filter, mismatched IDs or rejected continuation | Check the schema/path and resolved IDs, then correct the invocation or use a supported dedicated endpoint once. Distinguish a wrapper's unsupported-path refusal from an actual source permission denial. |
| Inline binary size cap, base64 response limit or known oversized original | Go straight to the original-file routes below; do not wait to be asked. Text pagination, repeated `fetch_blob` calls or `format=pdf` do not retain an oversized original. A converted PDF or preview is a distinct derivative, not the original deck. |
| Host output is truncated or saved to a tool-output file | Recover the complete structured result or the exact output file the host returned; the on-screen preview is only a prefix. Parse that file as JSON with filesystem/shell tools, then decode the field, rather than copying a displayed base64 preview through the model. Do not extract the base64 with a text pattern: the serialiser can escape characters inside it (`+` as `\u002B` was observed), which corrupts the decode. Verify the decoded bytes as described under Verify. If the complete payload is unavailable, use a direct transfer for binaries or smaller bounded pages for text; never assemble a file from truncated snippets. |
| Timeout, transient service failure or throttling | Retry the same request at most once when safe, respecting `Retry-After`; if the delay cannot be accommodated, park that source and continue independent work. Then use another supported route if available. Do not loop or immediately retry a throttled service. |
| No semantic-search hit for a known source, or an empty result that conflicts with known evidence | Try the exact resolved entity, occurrence or attachment read within scope. A search miss is not absence; do not widen into unrelated meetings or recursively browse links. |
| Missing authentication, consent, download capability or tool approval | Try other already-authorised non-interactive routes and continue independent sources. If completion still needs user action (for example approval for a last-resort browser download), ask once as soon as that need is established, naming every source waiting on it, not a generic instruction to continue. Do not install a server, obtain new scopes or sign in to another account. |
| `401`/`403`, a sign-in page or an empty body from a plain HTTP client, or from a token that lacks file scope or the right audience | A route failure, not a source verdict. Remember the result for the same route, credential and host for the rest of the run, not for every tool accessing that host. Continue other authorised non-interactive routes before considering the browser; do not record a denial or stop. |
| Confirmed source permission denial, blocked download or technical protection | Confirmed only when the source itself refuses the signed-in user: an access-denied page in the user's own browser session, or an access-denied result from an authenticated, file-scoped tool for the exact item. Stop attempts to obtain the denied content and record the exact limitation. Do not rotate accounts, request access, alter sharing, guess alternative URLs or unpack/decrypt local copies. An already-permitted online preview may still support a separately recorded review; it is not permission to extract blocked original bytes. |

For original-file transfer, take the first available route that can save the exact bytes within the authorised boundary and passes verification. Exhaust the applicable non-interactive routes (1-3), or record a concrete capability/failure reason for each, before using either browser route (4-5). Opening a URL from the shell still uses the user's browser and is not a background transfer:

1. **A provider tool that returns the complete original.** A dedicated authenticated tool that writes the original to a named local file, or returns the whole file without an inline cap (for mail attachments, a dedicated attachment-download tool, which can succeed where `fetch_blob` refuses). Read the tool's schema for its own cap. When the host saves an oversized result to an output file, decode that file with shell tools into the destination; never pass the base64 through the model. Confirm where a tool writes: a remote MCP server's filesystem is not the local archive.
2. **A self-authorising download URL.** A short-lived URL returned for the exact item that embeds its own authorisation can be transferred straight to disk by a filesystem/shell HTTP client. Use only the returned URL; never invent one, attach credentials, forward a token to another host or persist the URL in `.url` pointers, contexts or checkpoints (keep the canonical source URL). A returned URL need not be self-authorising: if it carries no short-lived token, or a plain request gets `401`/`403` or a sign-in page, go to route 3, not directly to the browser.
3. **A token-based Graph/provider API or CLI.** Only when a token with file scope for the right audience is already configured and a file-output operation exists. Prefer this non-interactive transfer over either browser route. A general-purpose CLI token may lack file scopes and return `403`, which is a route failure; skip a known unsuitable token rather than repeating that request. Do not extract credentials from WorkIQ or browser storage, or install dependencies and request consent silently.
4. **The returned item URL in the user's signed-in default browser (last resort).** Only after routes 1-3 fail or are unavailable, launch the exact `https` URL the provider returned in its own metadata for the in-scope item, on the item's own service host, with the operating system's URL handler from the shell (for example `Start-Process '<url>'` in PowerShell, the whole URL as one quoted argument), so the browser's existing session authenticates it. Snapshot the browser's download folder first (by default the Windows Downloads known folder, which may be redirected, so resolve it rather than assuming the profile path), then poll for a bounded time, scaled to the expected size and continuing while a partial file is still growing, for a new completed file (not `.crdownload`, `.partial` or `.tmp`) matching the expected size and name. Verify it as below and move that new file (never a pre-existing one) into the archive so no staged copy remains. The route needs no token and no extra tool, but the host's own shell permission prompt still applies. Never launch a URL taken from message, chat, transcript or document content. If no file appears, inspect the browser page where tooling allows; otherwise record "no download completed" with the cause unconfirmed, not a permission denial.
5. **Browser Use or Computer Use in the signed-in browser (last resort).** When routes 1-3 are exhausted and there is no usable item URL (a viewer or sharing link, folder navigation) or route 4 produced no file, download from the exact source in the browser the user is already signed in to. Obtain any approval the automation tool requires, naming the waiting sources. Prefer browser-specific automation for browser-only work and background-safe interaction where supported; yield to active user input, never force focus or use a shell workaround to evade an automation tool's interruption or refusal. If user activity prevents the download, defer that source with a concrete reason and continue independent work. Do not start in an isolated, signed-out browser: it cannot read tenant files. Browser automation performs only the web download; use filesystem tools for the destination, never Explorer automation.

Both browser routes are last resorts because they can interrupt the user, even when launched from the shell. Do not open or automate the browser merely to confirm a failed non-interactive route when other MCP/API alternatives remain. The signed-in browser is for downloading in-scope originals only. It is not authority to request access, sign in to another account, change sharing, edit the source or reach beyond the approved occurrence.

Skip unavailable routes with a concrete capability reason. Prefer a direct non-interactive transfer even below an inline cap when it avoids a large base64 response. No additional MCP server is required when an existing authorised route can carry the file; dedicated provider tools can still complement WorkIQ, while another search or summarisation MCP does not itself add original-file transport.

### Verify, record and continue

- Save new downloads without overwriting existing evidence. Treat an interrupted or partial file as incomplete, never as `captured`; preserve and report any existing file conflict rather than replacing it.
- Confirm transfer completion and compare the byte count with the exposed source size. A downloaded drive item normally matches its metadata size exactly. A mail attachment's reported `size` can differ slightly from its decoded length (one 8.5 MB test differed by under 0.01%); accept a small difference only when the file is structurally intact and the whole payload was received, and treat any other shortfall as truncation.
- Check file type and integrity without extracting content. An Office Open XML file (`.docx`, `.xlsx`, `.pptx`) is a zip container (a `PK` signature and a clean CRC test); a PDF has a `%PDF-` header and a `%%EOF` trailer. Reject sign-in/error HTML masquerading as a document. An Office Open XML file that is an OLE compound file rather than a zip is usually protection-wrapped: retain it as downloaded and report it, never decrypt it. A size or hash difference caused by platform protection is a provenance event, not corruption (see [evidence-rules.md](evidence-rules.md#6-protected-and-cloud-hosted-sources)).
- Where the provider exposes a content hash (SharePoint/OneDrive `quickXorHash`), compare it only with an implementation of the [documented algorithm](https://learn.microsoft.com/en-us/onedrive/developer/code-snippets/quickxorhash) that has been checked against a known value; a mismatch caused by protection is not corruption. Compute a local SHA-256 for later identity checks. A hash match or successful download does not establish semantic review or event-day version equivalence.
- If a supported transfer uses byte ranges, bind them to the same source version, verify `206`/`Content-Range`, non-overlapping ranges and final size, and reject an assembly if the version changes. A `200` response may be the entire file, not the requested chunk; never append it as a range. Do not assume the inline WorkIQ tool accepts range headers.
- Compare source version/ETag or modified metadata before and after retrieval where available. Preserve a changed-version or unavailable-version limitation; never label a current deck as the exact version presented without evidence. Do not edit, resave or convert the source to make it downloadable.
- Record attempted routes, actual errors/times, successful local path and verification, online review and the remaining blocker in the existing context Capture log and coverage rows. Do not create a new manifest, copy credentials or put source bodies in checkpoints.
- Finish each source as verified local retention or an explicit gap, then continue the other independent sources. Where original retention remains unavailable, perform the authorised online review described below and mark it Not captured locally. Preserve good prior evidence and checkpoint the exact pending source/range before a handoff.

## 1. Transcripts

Recognise official Teams transcript objects, recording-backed transcripts, customer-supplied transcript documents, indexed transcript renderings, local exports and transcripts derived from audio.

- Prefer authoritative transcript text. Derive from audio when none exists and tooling permits. An audio-derived transcript is **Captured** with an identified derivation method, not a word-perfect record: mark uncertain words and unresolved speakers. Summarising it is **Synthesised**; filling gaps by reasoning is **Inferred** and never inserted as speech.
- Attempt to save every transcript read in full as a local Markdown transcript companion (`Transcript.md`, see [filenames](../assets/context-record.md#ids-and-filenames)) using the transcript schema in [evidence-frontmatter.md](../assets/evidence-frontmatter.md). If local saving fails, retain the canonical source link and error, then read through normal authorised platform access if available. Use an online-reviewed transcript in the context synthesis, but mark it Not captured locally; reading remotely is not local capture.
- Enumerate all transcript objects; the first may be incomplete. Record object ID, call ID, source, segment counts, time bounds, pagination state and retrieval time.
- Detect restarts, repeated cursors, non-advancing pages and overlaps. Keep objects separate unless ordering and overlap are proven.
- Cross-check the occurrence's chat/call lifecycle IDs against the transcript collection before declaring occurrence-level completeness. A fully read object may cover only one call; another call or restart under the same occurrence stays an explicit gap until resolved.
- Split one large source only when tool or document limits require it, using explicit non-overlapping ranges with preserved totals and boundaries. Keep one file per source object or proven range and record their relationships.
- Preserve wording, timestamps, speakers, language and unattributed segments. Record gaps rather than inventing transitions.
- Record the **attribution level** (evidence-rules §3) in the transcript companion's `speaker_attribution` field, per object or part. Before accepting level 3–4 attribution for a material meeting, try the upgrade routes once: a recording with audio (for a fresh diarised transcript, where tooling permits), and an organiser-side or participant-side transcript, notes or minutes with better labels. A Teams recap, AI notes or a transcript rendering built from the same transcript is not an upgrade. Record each route tried and its outcome in the context; a search that finds nothing is "not found", not proof of absence. Do not repeat the attempt unless new evidence of a better source appears.
- Never replace an existing transcript because another attendee cannot retrieve it.
- `time_bounds` holds the first and last evidence timestamps. With only relative timestamps, keep relative bounds; add absolute bounds only when transcript, recording or lifecycle metadata supplies an explicit anchor. Never add relative offsets to the scheduled start.
- Do not infer a platform-specific `source_type` from a generic export; use `local-transcript-export` or `local-chat-export` unless the source establishes the platform.
- Retain original transcript files beside the companions in the occurrence folder, using short distinguishable names. Do not add format or audience layers. Preserve existing filenames until an approved migration changes them.

**Semantic review.** Start with modest text pages (typically 50–100 segments), shrinking as needed; read every returned segment in each claimed range. Use small structured boundary/anchor reads for exact timestamps, speaker metadata and citations that text mode omits. Count unique source segments, not repeated anchor reads or result-arrival order. Record reviewed ranges and the anchors behind content-dependent conclusions in the evidence table, separately from retrieved and retained coverage.

## 2. Chats

- Retrieve every page of the exact meeting or participant chat.
- Preserve substantive non-system messages chronologically, plus lifecycle events establishing call, transcript, recording or recap identity. Keep sender, created and modified times, wording, attachments and source identity.
- For recurring threads, isolate the occurrence using lifecycle markers and time boundaries. A shared series or chat ID is a source, not an occurrence key; never mix adjacent occurrences.
- On later runs, re-enumerate the whole occurrence window so edits and replaced attachments are found. `latest_message_at` alone does not prove nothing changed. A creation-date boundary does not review edits or deletions to older messages; state the actual scope.
- Preserve deletion/tombstone metadata where relevant without reconstructing absent wording.
- If no total count is available, say so. Exhausted pagination proves the returned query's coverage only (see the known-change check in the [retrieval playbook](evidence-rules.md#4-retrieval-playbook)).
- Inspect the complete supported message body and hosted-content relationships as well as attachment metadata. An empty attachment array is not evidence that inline or hosted images are absent. Resolve the exact hosted-content identity and use only a supported authorised byte route; metadata or an HTML image reference is not image retention. If bytes cannot be retrieved, preserve the canonical reference and actual limitation, and keep that image as an open asset outcome.
- Create a chat file whenever the exact occurrence chat has substantive content or lifecycle identity, using the chat schema in [evidence-frontmatter.md](../assets/evidence-frontmatter.md); attempt to save every substantive message locally in full. If local saving fails but the chat remains readable through normal authorised platform access, link and review it online for the context synthesis, and mark it Not captured locally. When an exact read finds nothing worth keeping, record `none-found` in the context instead of an empty file.

## 3. Attendance and meeting details

The context distinguishes: scheduled from actual transcript/recording time; organiser from attendees; invitees from evidenced attendance; attendance-report participants from attributed speakers; identified speakers from unresolved labels; original title from the filename descriptor.

Attendance evidence comes from transcript attribution, attendance reports and call lifecycle records. Invitation status alone is insufficient, and absence of attributed speech is not absence from the meeting. Do not claim a complete attendance list while unattributed speakers or partial coverage remain. Speakers come only from source labels (evidence-rules §3); record attribution risks rather than reassigning speech.

## 4. Recordings, renderings and recaps

Classify media from inspected duration, streams and audio before naming or relying on it:

| Media class | Meaning | Filename |
| --- | --- | --- |
| `full-recording` | Meeting audio/video recording | `Recording.<ext>` |
| `recording-continuation` | Proven later part of the same occurrence | `Recording Part N.<ext>` |
| `silent-recording` | No recoverable substantive audio | `Silent Recording.<ext>` |
| `transcript-rendering` | Video rendering of transcript text, often silent | `Transcript Rendering.<ext>` |
| `related-demo` | Separate demonstration referenced by the meeting | `Related Demo Recording.<ext>` |
| `recap-pointer` | Recap or summary media source | `Recap Recording.<ext>` |

- A rendering, silent capture or placeholder is not a full recording, and never substitutes for a distinct full recording.
- Attempt to retain accessible media locally under the meeting descriptor, with an authoritative pointer when a URL exists. Use the recording schema in [evidence-frontmatter.md](../assets/evidence-frontmatter.md) for any Markdown recording companion. If download is blocked, keep the pointer and record owner, tenant, object and error; if the source remains readable online through normal authorised access, review it for synthesis and mark it Not captured locally.

## 5. Tied email, notes and follow-up

Communication is tied to an occurrence only through a thread, meeting or call ID, join URL, named artefact, explicit meeting reference or otherwise unambiguous context. Participant or keyword proximity is insufficient. The window may extend after the meeting while the same thread discusses its outputs; recheck such threads during reconciliation.

Attempt to create typed local companions for every tied communication that materially supports the meeting, saving the full text in Markdown. Use the matching filename and schema in [evidence-frontmatter.md](../assets/evidence-frontmatter.md):

| Companion filename | Schema |
|---|---|
| `Email.md` | `meeting-email-companion` |
| `Follow-up Email.md` | `meeting-follow-up-email-companion` |
| `Follow-up Chat.md` | `meeting-follow-up-chat-companion` |
| `Recap.md` | `meeting-recap-companion` |
| `Notes.md` | `meeting-notes-companion` |
| `Attendance.md` | `meeting-attendance-companion` |

If local saving fails but the source remains readable online through normal authorised access, link and review it for synthesis, and state that it was not retained locally. If online review also fails, record the source and actual limitation.

- Preserve source identity, author, timestamps, any platform-applied classification label as metadata, thread relationship, reporting chain and attachment disposition. Do not infer classification from markings in the message or attachment content.
- State whether the companion preserves an original, selects passages or newly summarises.
- A later summary is supplementary unless the meeting explicitly incorporated it.

## 6. Reusable resources

Classify every URL and attachment encountered in approved occurrences once. Resources (presented or shared documents, decks, spreadsheets, PDFs, Loop and web pages) are **referenced, not rendered**: keep the original file or link, record identity and use, and never convert them to Markdown (evidence-rules Key guidance 2). Reuse resolved equivalents and mark incidental navigation without opening it. This is not licence for recursive browsing.

| Disposition | Meaning |
| --- | --- |
| `captured` | The original file (where one is available) and the source pointer are saved under `sources_root` (step 3 below), with stable identity. The default for every accessible in-scope resource. No Markdown rendering is made. (A storage outcome: its contents are not thereby all **Captured** information.) |
| `existing` | The same source or payload already exists in the resource corpus |
| `incidental` | Navigation, sign-in, reaction, media placeholder or other non-resource URL |
| `inaccessible` | The original could not be saved locally or its identity resolved; pointer, route and error retained. A Not-captured-locally item. If it remains readable online through normal authorised platform access, review it for synthesis and record that separately. |
| `pending-source` | A named or promised resource has not been supplied. A Not-captured item. |
| `not-uniquely-resolved` | Evidence cannot identify one authoritative resource. A Not-captured item. |

`pointer-only` is retired: record a locally retained resource as `captured` (original plus pointer) and anything else as a Not-captured-locally disposition. A source link is not a local capture. Markdown renderings of resources are not made; an online-readable resource may still inform synthesis when local retention fails, with its source link and review noted in the context.

For each resource:

1. Preserve the exact observed URL.
2. Resolve stable drive, item or document identity where possible.
3. Determine provenance from content attribution and source evidence. Original or received reusable resources belong in `sources_root`, regardless of whether they were externally or owner-organisation authored; record that provenance explicitly. New meeting contexts and recaps stay under `meetings_root`; broader analysis, drafts and AI-assisted material belong in `working_root`. Exact versions intentionally circulated are referenced and registered in `issued_outputs_root`, not copied by this skill. Meeting audience and resource provenance are independent.
4. Check for an existing equivalent by identity, version or hash; deduplicate payloads while keeping per-meeting provenance. One file set per source: later meetings link to it. Create a new set only when a meeting used a materially different version, with the same descriptor, a version tag and that version's first-seen date.
5. Save or retain the original file and a `.url` pointer to its canonical source where available, subject to the authorised storage boundary. Use the [recovery sequence](#0-retrieval-preflight-and-automatic-recovery) for failed or oversized transfers; verify the payload before marking it `captured`. Do not create a Markdown rendering of the resource or move an existing source without approval.
6. Link each meeting that used or referenced it.
7. Record a Not-captured item when capture is blocked or unresolved.

Treat attachments, linked files, inline images and platform-hosted media as distinct payload classes even when they originate in one message. For hosted images, distinguish the message reference, hosted-content metadata and retrieved image bytes; metadata or an HTML link is not the payload. A platform-hosted rendition may differ from the original camera file, resolution or metadata, so do not claim original-camera provenance without evidence. If the image or scan needs content review, use supported visual inspection or OCR as appropriate, record the pages and material limitations, and label OCR as a derived review aid. Retain the source resource in its original form; do not create a Markdown rendering of it.

Keep local access, online review and local retention separate, and reconcile resource dispositions before finishing.

For the resource table, preserve per-occurrence references even when identical payloads are deduplicated. Where hosted media is present, state the number of references and distinct resolved objects separately when those counts are available. Distinguish bytes retained from metadata/links preserved and from visual or semantic review; record unknown totals and unresolved overlaps explicitly rather than implying completeness.

Retry local retention for `inaccessible`, `pending-source` and `not-uniquely-resolved` during every reconciliation. When a source remains online-readable, use its canonical link for authorised review rather than treating the local-save failure as proof that its content is unavailable.

Name newly captured resources `YYYY-MM-DD - <Type>, <Descriptor>.<ext>`, with the original file and `.url` pointer sharing one stem. Use the date first presented or captured for this workspace unless source metadata establishes a better one. Keep the original filename in provenance.

Context resource table:

| Source message/time | Resource | Provenance | Disposition | Archive location or limitation |
| --- | --- | --- | --- | --- |
