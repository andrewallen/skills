# Meetings evidence rules

These rules belong to Meetings Governance. Stakeholder Governance has its own shorter guidance for consuming evidence and writing profiles.

## Key guidance: local-first meeting capture and online review

1. **Save without a protection check, and flag an unexpected destination.** The resolved meeting folder is the approved store for in-scope workspace material, so do not hold capture to assess destination protection. If that destination looks unexpected for the workspace (for example not under the expected OneDrive or sync root, or different from the storage boundary recorded in the Archive Guide), save as normal and add a **Destination** line to the run report naming the path and why it looks unexpected, so the owner can decide whether to act.
2. **Attempt local capture first.** For in-scope meeting communications (transcripts, meeting and follow-up chats, tied emails, notes, minutes and recaps), attempt a faithful Markdown companion in the governed folder. For recordings and reusable resources, attempt to retain the original file locally and record its identity and source link. Online reading is not local retention.
   **Resources are not rendered.** Presented or shared documents, decks, spreadsheets, PDFs, Loop pages and web pages (customer, internal or AI-generated) stay as their original files or links. Do not convert them to Markdown.
3. **Use platform labels as metadata only.** Record classification labels applied by the source platform, exactly as exposed. Do not infer or interpret classification from words, banners, filenames or markings in source content. A platform label alone is not a reason to withhold local capture, online review, quotation or synthesis. Preserve source content faithfully; downstream outputs still use only material relevant to their purpose.
4. **If local retention fails, review online when authorised.** Record the canonical source link, attempted route, observed error and time. If the source remains readable through normal, authorised platform access, review it online and include it in the synthesis alongside locally retained sources. Link it from the context and record online review separately from local retention in the evidence-coverage table.
5. **Do not bypass access or technical controls.** If online reading also fails, record the exact source and actual limitation in the evidence-coverage table, add it to the Remaining-work queue and list it first in the run report under **Not captured**. Do not decrypt or unpack synced copies, change sharing, or use an unapproved route. Never imply an unreadable source was considered.
6. **Prove the distinct outcomes before finishing.** Track local retrieval, online retrieval, semantic review and local retention separately for every in-scope source. A source missing from the local archive remains **Not captured locally** even when reviewed online. State any source that could not be reviewed at all as a coverage gap; do not describe the local archive as complete while any in-scope source is not retained.

## Contents

0. Key guidance: local-first capture and online review
1. Ownership and handoff
2. Information-provenance taxonomy
3. Applying the taxonomy
4. Retrieval playbook
5. Output limits and retention
6. Protected and cloud-hosted sources
7. Version-safe viewing
8. Delegation
9. Checkpoint and resume
10. Links and paths

## 1. Ownership and handoff

**Meetings Governance owns meeting collection. Stakeholder Governance owns person and organisation analysis. Workspace Governance owns structure.**

| Owner | Responsibility |
| --- | --- |
| `meetings-governance` | Meeting discovery, exact occurrence resolution, transcript/chat retrieval and pagination, recording/media checks, meeting-linked correspondence and resources, reconciliation. Supplies the Meetings Index, contexts, source companions, resource pointers and coverage limitations. |
| `stakeholder-governance` | Reads those records, extracts attributed contributions, distinguishes personal statements from evidenced organisational positions, compares them across sources and produces person profiles, organisation profiles, research maps and content-review recommendations. Reads the project's other files for non-meeting evidence and researches beyond the project only when separately authorised. |
| `workspace-governance` | Owns the fixed common folders, Start Here, Issued Outputs Index, routing and duplicate-candidate review. It is not an evidence producer and does not capture meetings or write entity analysis. |

**Handoff to meetings** (entity evidence gap): workspace/archive path, known occurrence or bounded date range, existing source links, the specific gap and the affected claims. Batch gaps affecting several entities so each meeting is reconciled once.

Meetings governance checks existing capture first and fetches only missing or stale evidence within the authorised scope. Stakeholder governance does not re-enumerate calendars, re-download transcripts, re-page archived chats, reclassify media or re-resolve unchanged attachments. An exact source-pointer read to ground one profile passage is consumption, not recapture; a metadata-only handoff supports navigation, not new substantive claims.

**Return from meetings:** context/source/resource links, resolved identities, what changed, actual evidence cutoff and remaining access or attribution gaps.

**Handoff to stakeholder governance** (source change): the corrected wording, person attribution, organisation representation, occurrence or qualified decision and the affected profile citation. After a `recalibrate`, identify changed scope relationships: source citations stay valid, but reasoning that depended on scope is re-checked. Preserve legacy class values without using them for routing.

- Use existing archive files and the conversation. No registry, packet or manifest is required.
- A handoff never implies automatic synchronisation or permission to widen scope. Run the other skill only when the user's request authorises that work; otherwise report the bounded next step.
- Request a producer refresh once per gap per run. If it remains unresolved, keep the limitation rather than bouncing between skills.
- The meeting archive never holds person/organisation profiles or entity-level interpretation; stakeholder governance never builds a second meeting archive.
- Workspace governance may link governed records for navigation, but it never uses its index or routing decision as corroborating evidence.
- Neither skill uses the other's outputs as independent evidence: a profile does not corroborate a meeting, and a context does not corroborate its own transcript.

## 2. Information-provenance taxonomy

Use the five information types (Captured, Extracted, Synthesised, Inferred, Proposed) exactly as defined in [Common Architecture](../../../Common%20Architecture.md#information-and-lifecycle). They describe the information and its transformation, not its sensitivity, reliability or approval.

Keep these axes separate:

- **Type:** one of the five.
- **Attribution:** direct, reported or unresolved; preserve every reporting intermediary. "Reported" qualifies attribution; it is not a sixth type.
- **Decision status:** question, request, proposal, suggestion, position, claim, concern, disagreement, working-session agreement, formal approval or evidenced completion.
- **Coverage:** defined by each skill and recorded separately from information types; meeting contexts report it per source rather than as one aggregate capture status.
- **Sensitivity and usage rights:** handling requirements, not evidence strength.

"Interpretation" is a reader-friendly label for **Inferred** and "Recommendation" for **Proposed**; they are not extra types. Express evidence strength and source reliability as plain-language caveats, not numerical confidence scores.

## 3. Applying the taxonomy

- Label information, not just files. A captured artefact (minutes, notes, a received AI recap, an agenda) can contain reporting, synthesis, inference or proposals. Copying it does not make it verbatim speech or corroborated fact.
- A source reporting another person's view or agreement is direct evidence of the report and indirect evidence of the underlying view.
- "The group agreed" in minutes does not establish each attendee's assent or the authority for formal approval. Verify authority before calling anything approved. An action mentioned or allocated is not an action completed.
- A captured person or organisation proposal is **Extracted** evidence of the attributed proposal; only our own suggestions are **Proposed**. Record acceptance or implementation separately without changing that provenance.
- One employee's statement does not become an organisation's formal position without evidenced authority, an institutional source or sufficient qualified corroboration. Preserve differing positions within an organisation.
- AI-assisted authorship and human review are separate provenance facts. Neither turns an inference into fact or a proposal into approval, and user acceptance is not personal or organisational endorsement. Presented AI material proves use, not approval; recorded adoption proves only the decision actually recorded. Link the material and the source passage establishing its use or adoption; never use the material alone to prove what happened.
- Keep exact quotation, faithful paraphrase and our application distinct. Do not tidy wording into invented verbatim speech or attribute anonymous voices by guesswork. Mark unverified quotations as such.
- **Speaker = source label only.** A speaker is the transcript's speaker label, or the chat or email sender, exactly as the source records it. Never assign or change a speaker from content, named references ("Participant A, you've got your hand up"), self-descriptions, speaking style or likely role. Labels can themselves be wrong (a shared or room device carrying several voices, generic or anonymous labels, misassigned fragments during cross-talk): record such risks, never "correct" them. A content-based view of who was really speaking is **Inferred**, stated separately with its basis, and never replaces the label.
- Absence of attributed speech does not mean absence from the meeting; say "no attributed speech", not "not present".
- **Attribution levels.** Record one per transcript object (or per part where it changes), in plain words:

  | Level | Source gives | Speaker column | Supports |
  | --- | --- | --- | --- |
  | 1 Source-attributed | One person per account or device, named by the platform | The name | Quotes and personal positions |
  | 2 Named, at risk | Named labels with a known problem: shared or room device, one label carrying several voices | `Label: Name (room device)` | Meeting-level points; personal quotes only where that person's own voice is corroborated |
  | 3 Consistent but anonymous | Generic labels stable within the meeting ("Speaker 1") | `Speaker 1` | Meeting-level points; tracking what one anonymous voice argued |
  | 4 Unattributed | No labels, or "Unknown speaker" | `unattributed` | Meeting-level content only |
  | 5 Garbled | Unreliable words at any level | As above, plus "garbled passage" | Topics and clearly worded points only |

  A higher level never comes from inference. A **suggested speaker** for a level 2–4 passage is **Inferred**, recorded separately with its cue and anchor, and never replaces the label. Strong cues: self-introduction; being addressed by name immediately before replying; a later chat, email or minutes from that person or the organiser referring to what they said (a corroborated suggestion, still labelled). Weak cues, which alone never justify a suggestion: expertise, style, seniority, topic ownership. An attendee's recollection is that attendee's reported attribution, not source evidence.
- **Garbled passages.** Preserve the source wording exactly; never clean it into fluent speech. Build a key point on a garbled passage only when its meaning is clear, and say that it rests on a reading of that passage.
- **Turn edges.** At levels 2–5, and wherever a sentence visibly runs across labels, the first and last few words of a turn may belong to the neighbouring speaker. Anchor quotations to the body of a turn, not its opening or closing words; where a point depends on words at a turn edge, paraphrase it and say that the boundary is uncertain.
- Split a sentence that blends a source statement with interpretation or advice.
- Deduplicate quoted email chains, copied transcripts and repeated recaps. Several copies of one statement are not independent corroboration.
- Keep an original and a corrected account distinguishable, with the correction's author, date and evidence. Integrate corrections where the claim appears, not only in an appended disclaimer.
- Do not mass-edit existing sources or add mandatory fields just to adopt the taxonomy; annotate records when they are created or materially updated.
- A provenance-only or taxonomy-only review changes the annotation/review date, never an evidence cutoff or reconciliation watermark, and is not reported as fresh research.

## 4. Retrieval playbook

- Apply the [bounded discovery, capture preflight and recovery sequence](capture.md#0-retrieval-preflight-and-automatic-recovery) to all source types. It covers route recovery and browser last resorts.
- Prefer dedicated entity tools for exact reads and pagination. Semantic search supplies leads, not collection inventories, substitute identities or negative findings.
- Prove one small request before repeating it across sources.
- Copy paired identifiers from the same resolved record. Compare opaque IDs case-sensitively and ordinally, including in PowerShell (`-ceq`, not `-eq`). Never lowercase, rebuild or repair IDs or cursors. Decode URL query encoding only when the tool's token parameter requires it, without changing the value.
- Use supported filters with matching ordering. If a tool accepts only `gt`/`lt`, use the supported upper bound with client-side lower-bound stopping rather than guessing `ge`. Keep endpoint, filter/order and continuation together, and follow short pages while a next cursor exists.
- Request only needed fields at readable page sizes. If a cursor fixes an oversized page, restart only that bounded collection with smaller pages and deduplicate the overlap.
- If a wrapper rejects a cursor or drops metadata, use the supported dedicated route once. A mismatched ID pair or invalid query is an invocation error, not access denial. Stop on an actual permission denial; never bypass it.
- Before claiming complete change detection, test the query against an already-known in-window change where available. If it omits that change, or no control exists, exhausted pagination proves only returned coverage; use exact known-source comparisons and retain the broader gap. Do not invent a control.
- An access denial, timeout, throttle, failed search or missing search hit is not proof of absence. Report the exact source attempted and the observed failure; do not generalise one failed link to every document.

## 5. Output limits and retention

- Tool hosts may retain oversized responses automatically. Minimise payloads; do not promise zero retention. Record runtime retention separately from deliberate archive output.
- Source continuation and host-output truncation are different conditions. Read only authorised bounded results and never count unseen truncated content as reviewed or retained; re-read in smaller bounded pages until the whole source is saved locally where possible, otherwise apply Key guidance 4 and 5.
- Recover a complete host-retained output or structured payload before repeating the source call. For binary originals beyond inline limits, use the capture reference's original-file routes; pagination or a preview/conversion is not original-file retention. Never reconstruct an original from truncated base64.
- Distinguish what was retrieved locally, retrieved online, **semantically reviewed** and retained locally (Key guidance 6).

## 6. Protected and cloud-hosted sources

- Read cloud-hosted Office files through authorised Microsoft 365 grounding or supported source access when a meeting-evidence companion (for example a transcript exported to Word) needs saving as Markdown; edit through supported cloud editing. Resource documents are not rendered (Key guidance 2).
- Do not unzip, decrypt or parse a synced local copy to bypass failed cloud access or encryption. A source that cannot be read online is Not captured; a local-save failure alone is not a failed read if the original remains readable online.
- Platform labels are metadata only (Key guidance 3); never treat source-content markings as handling instructions.
- Never change platform labels, unlock containers, change sharing or send notifications as part of maintenance.
- Treat protection rewrapping or hash changes as a provenance event, not automatic corruption.
- Never downgrade or erase good prior evidence because current access is worse.

## 7. Version-safe viewing

- Keep three times distinct: the frozen evidence cutoff, the actual inspection time and the source version's modified/effective time. Record only times actually established; never reuse the cutoff as a retrieval timestamp.
- Prefer grounded or version-pinned reads over opening a collaborative app. Verify that each answer or citation used the exact intended item, version and attachment parent; a familiar title or a URL in the prompt does not guarantee it. Discard mismatched-source comparisons.
- For a necessary authorised native view (including Loop), capture item/version/modified metadata before opening and compare after closing where supported. A first fingerprint taken after opening cannot prove a pre-view state. Native viewing is not assumed side-effect-free.
- For viewing, use an observed viewing/preview link, not a guessed download URL, and enable download cancellation where supported. Explicit original-file capture uses the capture reference's authorised download routes instead; it is distinct from an unexpected download during viewing.
- If navigation starts an unexpected download or the version advances, stop that route, record the observation and tell the user. Do not infer a content change or cause, use the download as a workaround, revert the source or delete files.
- Current content cannot establish a historical version; retain that limitation.
- Record physical page/slide numbers, hidden slides and unreadable image-only content. A current PPTX, an earlier version and an emailed PDF are distinct evidence until equivalence is shown; matching extracted text is not byte or visual equivalence.
- Do not reopen a resource merely to repeat an inspection the producer already recorded.

## 8. Delegation

Default to a direct run. Delegate only genuinely independent, substantial evidence sets.

- One coordinator owns all writes; browser ownership is exclusive.
- Readers return one final result to the coordinator, not peer status questions. Queued progress messages are not final handoffs.
- A final result contains only: scope/cutoff, exact source identities, unique reviewed coverage, saved paths or proposed changes, and remaining gaps/incidents.
- The coordinator waits for assigned results, consolidates once and reads back changed records. A correction explicitly supersedes the earlier value; it does not trigger another research round.
- Do not keep a completed reader active to repeat an answered clarification.

## 9. Checkpoint and resume

- Freeze the scope and evidence cutoff at the start; a resume keeps the original cutoff.
- Checkpoint after each completed unit and before compaction or handoff, in the skill's existing current-state location or permitted session state. Record item and exact source IDs, what is done, the exact resume cursor/range with the last completed page boundary, and the next step or blocker.
- Checkpoints hold operational metadata only: never source bodies or credentials. No separate manifest or database.
- Resume from the checkpoint before rediscovery. Lost internal state is an execution gap, not an access blocker: recover the returned result or minimally re-enumerate metadata, deduplicating ordinally.
- Finish or explicitly disposition the current unit before opening new branches. Park weak or out-of-scope leads with a reason rather than widening the run.

## 10. Links and paths

- Use Windows paths for filesystem operations and URL syntax for Markdown links.
- Generate local links relative to the file containing them. URI-encode spaces and reserved characters (`%20`, `%2C` for commas, `%5B`/`%5D` for brackets). A raw space, comma or bracket in a local link target fails validation. Validate every generated link before finishing.
- In YAML, single-quote Windows paths so backslashes stay literal; escape an embedded single quote by doubling it. Never put a Windows path in double quotes.
- Preserve observed URLs and stable identities verbatim. A local path is not a cloud document ID; never invent message, document or timestamp anchors.
