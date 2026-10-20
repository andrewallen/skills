# Current information model inventory

**Status:** Non-normative inventory of current repository definitions and gaps, prepared 2026-10-20. This document does not establish new requirements or resolve proposed decisions.

Related proposals:

- [ADR-0008: Independent skill contracts and interoperability](adr/0008-define-independent-skill-contracts.md)
- [ADR-0009: Shared information model](adr/0009-establish-a-shared-information-model.md)
- [ADR-0010: Evidence retrieval and interpretation semantics](adr/0010-define-evidence-retrieval-semantics.md)

## Terms in the current repository

| View | Current definition or use | Current source |
|---|---|---|
| **Vocabulary** | Terms such as `Captured`, `Extracted`, `Synthesised`, `Inferred`, `Proposed`, `working`, `approved`, `issued` and `archived` have meanings in specific contexts. | [Common Architecture](../plugins/work-context/Common%20Architecture.md); [Meetings evidence rules](../plugins/work-context/skills/meetings-governance/references/evidence-rules.md) |
| **Taxonomy** | Several independent classification dimensions are used; they should not be treated as one status field. The current dimensions are listed below. | Common Architecture, meeting evidence rules and skill templates |
| **Ontology** | Records imply entities and relationships, such as a meeting occurrence having transcripts, a context linking to evidence, a profile citing sources, and an issued output having distribution events. These relationships are not yet stated as one shared model. | [Context record](../plugins/work-context/skills/meetings-governance/assets/context-record.md); [Person profile](../plugins/work-context/skills/stakeholder-governance/assets/person-profile.md); [Issued Outputs Index](../plugins/work-context/skills/workspace-governance/assets/issued-outputs-index.md) |
| **Information requirements** | Templates specify fields and sections needed for contexts, evidence companions, profiles, indexes and orientation documents. | Templates under `plugins/work-context/skills/*/assets` |
| **Logical record structure** | Records use Markdown, YAML frontmatter, stable IDs, source anchors, relative links and tables. No cross-skill logical identifier or relationship contract is defined centrally. | Meeting and stakeholder templates |
| **Interpretation semantics** | Existing rules limit claims based on attribution, authority, corroboration, completeness, time and source access. They are mainly distributed through specialist instructions. | Meeting evidence rules; stakeholder evidence guidance and source rules |
| **Physical representation** | The plugin package is Markdown skill definitions, references, templates and a JSON manifest. Workspaces use the fixed numbered roots in Common Architecture. | [README](../README.md); Common Architecture |

## Current classification dimensions

These are separate axes. A value in one axis must not be used as a value or conclusion in another.

| Dimension | Values or current use | Notes |
|---|---|---|
| **Information provenance / transformation** | `Captured`, `Extracted`, `Synthesised`, `Inferred`, `Proposed`. | The five types describe information and transformation, not reliability, sensitivity or approval. `Interpretation` is a reader-friendly label for `Inferred`; `Recommendation` for `Proposed`. |
| **Meeting decision status** | `question`, `request`, `proposal`, `suggestion`, `position`, `claim`, `concern`, `disagreement`, `working-session agreement`, `formal approval`, `evidenced completion`. | Describes the status of a recorded point, not its provenance type. |
| **Attribution** | Direct, reported or unresolved; transcript-specific attribution levels 1–5: source-attributed, named-at-risk, consistent-but-anonymous, unattributed, garbled. | Attribution qualifies a source claim and is not an information type or confidence score. |
| **Lifecycle** | `working`, `review-required`, `approved`, `issued`, `superseded`, `withdrawn`, `archived`. | These are common lifecycle terms; approval and issue are explicitly distinct. |
| **Audience** | Meeting audience uses `internal` or `external`; issued-output distribution records audience per event. | Audience is not provenance or authority. |
| **Meeting/archive classification** | Contexts require `archive_class`, `baseline_version`, `baseline_impact` and matched principle IDs. Archive Guide template calls for class and impact tables. | The package does not currently provide the promised authoritative class and baseline-impact tables. |
| **Capture status** | Context requires exactly one `capture_status`; the meeting rules direct blocked capture to `partial`. | The package does not define a complete authoritative set of capture-state tokens. Descriptive uses of “complete” do not by themselves establish an allowed token. |
| **Meeting archive inventory** | `provisional` or `complete-through-<date>`; onboarding describes archive maturity as `blank`, `partial` or `established`. | Inventory and archive maturity are not the same as an individual record's capture status. |
| **Stakeholder source coverage** | `Reviewed`, `Partial`, `Unavailable`, `Not checked`, `No relevant evidence found`, `Not applicable`. | These describe the bounded research pass, not information type, confidence or meeting capture status. |
| **Sensitivity and usage rights** | Recorded as handling metadata where established. | No common controlled vocabulary is defined in this package. |
| **Date and freshness** | Occurrence time, source modified/effective time, actual inspection time, evidence cutoff and reconciliation time. | The meeting rules require these to remain distinct; no general recency-ranking rule is defined. |
| **Record kind** | Examples include source companion, meeting context, meetings index, archive guide, person profile, organisation profile, research map, Start Here and Issued Outputs Index. | Some templates use `document_role`; no complete shared record-kind vocabulary is defined. |

## Current entities and relationships

| Entity or record | Relationships represented today | Evidence / limitation |
|---|---|---|
| Workspace | Has a purpose and scope; has fixed roots and systems of record. | Common Architecture and Start Here template. |
| Meeting occurrence | Has an exact occurrence identity and can relate to transcripts, chat, recordings and artifacts. | Context frontmatter has `meeting_id` and `related_*` fields. |
| Source artifact or version | Has source identity, author/sender, dates, provenance and possibly a stable link or hash. | Evidence companion frontmatter and evidence rules. |
| Passage or contribution | Is anchored to a transcript, chat or email; has a source speaker/sender and attribution qualifications. | Context key-points table and attribution rules. |
| Person or organisation | Has a canonical profile and dated roles, positions, contributions and relationships relevant to a workspace. | Stakeholder profile templates. |
| Derived record | Summarises, extracts from or interprets one or more sources and should point readers back to them. | Context, profile and index templates. |
| Resource | Is referenced by one or more meetings; equivalent resource payloads may be retained once with per-meeting provenance. | Meetings capture rules. |
| Issued output | Has one canonical file and can have distribution events recorded in the index. | Common Architecture and Issued Outputs Index. |
| Governance principle | Has a stable ID and may be matched to a meeting context. | Archive Guide and context `matched_principles`. |

The inventory observes these links in current formats; it does not establish a new canonical identifier scheme or formal graph vocabulary.

## Existing interpretation rules

- Attendance or participation does not establish endorsement.
- One person's statement is not automatically an organisation's position.
- A derived profile or context does not independently corroborate its source.
- A reported view is direct evidence that the view was reported, not necessarily direct evidence of the underlying statement.
- Approval is not distribution; an action mentioned or allocated is not evidenced completion.
- A later timestamp alone does not establish authority or supersession.
- An inaccessible source or missing search result is not proof that no relevant evidence exists.
- A summary or paraphrase is a navigation aid when the exact source passage is needed for a claim or quotation.
- Search, source coverage and capture completeness are bounded by the actual query, source range and access observed.

These rules are present in specialist guidance, not yet consolidated into a shared semantic reference.

## Open definitions to resolve

1. What meeting/archive classes are supported, and what class-specific retention or routing follows each?
2. What are the allowed `baseline_impact` values, and how do they differ from archive class?
3. What is the complete allowed set for per-record `capture_status`? How does it relate to archive maturity and index completeness?
4. Which common record kinds and relationship names need stable definitions, versus remaining skill-local?
5. Which attribution, decision-status, lifecycle, audience and coverage vocabularies are portable shared terms, and which need controlled extensions?
6. What minimum identity, source-anchor and version information makes a record interoperable without requiring a particular producer skill?
7. Which authority, effective-date, correction and supersession rules should be common semantics, and which are workspace-specific?
8. How should sensitivity and usage-rights terms be represented without implying permission from a label or an unverified classification?
9. What should be searchable summaries or precise extracts, what must remain source-grounded, and how should stale or failed ingestion be reported?
10. Which domain terms and business definitions belong only in a workspace's governed controls, such as “Strategic Engagement” or “Active Programme”?

Resolving these questions may change skill behaviour or generated records. Until the related ADRs are accepted, this inventory is descriptive only; it does not authorise new required fields, vocabulary, migrations or capture behaviour.
