# Current information model inventory

**Status:** Non-normative inventory of current repository definitions and gaps, updated 2026-10-22. This document does not establish new requirements or resolve proposed decisions.

Related proposals (not accepted in full):

- [ADR-0008: Independent skill contracts and interoperability](adr/0008-define-independent-skill-contracts.md)
- [ADR-0010: Evidence retrieval and interpretation semantics](adr/0010-define-evidence-retrieval-semantics.md)

Accepted decision: [ADR-0013: Minimal shared evidence model](adr/0013-minimal-shared-evidence-model.md). This inventory remains descriptive and does not define a schema.

Accepted [ADR-0020](adr/0020-deploy-stable-versioned-workspace-signposts.md) defines stable, versioned workspace signposts while retaining the seven-root physical baseline from superseded [ADR-0015](adr/0015-standardise-project-folders-and-navigation.md). [ADR-0017](adr/0017-use-direct-filesystem-operations.md) defines proportionate approved mappings and direct file operations, not a permanent path map or shared evidence database. Migration state is operational metadata, distinct from evidence coverage and lifecycle. No new universal evidence fields are imposed.

## Terms in the current repository

| View | Current definition or use | Current source |
|---|---|---|
| **Vocabulary** | Terms such as `Captured`, `Extracted`, `Synthesised`, `Inferred`, `Proposed`, `working`, `approved`, `issued` and `archived` have meanings in specific contexts. `Structural signpost` describes navigation guidance, not an evidence-provenance type. | [Common Architecture](../plugins/work-context/Common%20Architecture.md); [Meetings evidence rules](../plugins/work-context/skills/meetings-governance/references/evidence-rules.md); [ADR-0020](adr/0020-deploy-stable-versioned-workspace-signposts.md) |
| **Taxonomy** | Several independent classification dimensions are used; they should not be treated as one status field. Document role is distinct from provenance, lifecycle, authority, audience and evidence coverage. | Common Architecture, meeting evidence rules and skill templates |
| **Ontology** | Records imply entities and relationships, such as a meeting occurrence having transcripts, a context linking to evidence, a profile citing sources, an issued output having distribution events, and a structural signpost pointing to a collection. These relationships are conceptual; there is no universal graph schema. | [Context record](../plugins/work-context/skills/meetings-governance/assets/context-record.md); [Person profile](../plugins/work-context/skills/stakeholder-governance/assets/person-profile.md); [Issued Outputs Index](../plugins/work-context/skills/workspace-governance/assets/issued-outputs-index.md); [signpost templates](../plugins/work-context/skills/workspace-governance/assets) |
| **Information requirements** | Templates specify fields and sections needed for contexts, evidence companions, profiles, indexes and static signposts. Signpost provenance records deployment and governance versions, not a changing evidence cutoff or review date. | Templates under `plugins/work-context/skills/*/assets` |
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
| **Meeting/project navigation** | Meeting identity, project scope, source relationships, topic/decision anchors and workspace-specific matched principle IDs support retrieval. | New contexts do not require archive-class or baseline-impact fields under [ADR-0013](adr/0013-minimal-shared-evidence-model.md). Preserve such values in legacy records; do not use them to gate capture. |
| **Meeting source coverage** | Context evidence-coverage table distinguishes local retrieval, online retrieval, semantic review and local retention for each source. | No aggregate per-context `capture_status` is required; online review does not imply local retention. |
| **Meeting archive inventory** | `provisional` or `complete-through-<date>`; onboarding describes archive maturity as `blank`, `partial` or `established`. | Inventory and archive maturity describe the archive, not any individual source. |
| **Stakeholder source coverage** | `Reviewed`, `Partial`, `Unavailable`, `Not checked`, `No relevant evidence found`, `Not applicable`. | These describe the bounded research pass, not information type or confidence. |
| **Sensitivity and usage rights** | Meeting capture records platform-applied classification labels as metadata when exposed; source-content markings are not interpreted as classification. | See accepted [ADR-0012](adr/0012-local-first-meeting-evidence-capture.md). No common controlled vocabulary is defined in this package. |
| **Date and freshness** | Occurrence time, source modified/effective time, actual inspection time, evidence cutoff and reconciliation time. | The meeting rules require these to remain distinct; no general recency-ranking rule is defined. |
| **Record kind** | Examples include source companion, meeting context, meetings index, archive guide, person profile, organisation profile, research map, Start Here, `AGENTS.md` and Issued Outputs Index. A signpost is structural navigation, not an evidence-bearing derived record or specialist index. | Some templates use `document_role`; no complete shared record-kind vocabulary is defined. |

## Current entities and relationships

| Entity or record | Relationships represented today | Evidence / limitation |
|---|---|---|
| Workspace | Has a purpose and scope; has fixed roots and systems of record. | Common Architecture and Start Here template. |
| Structural signpost | Points readers to stable folder roles and may reference a companion signpost. It does not summarize, index or corroborate project records. | Start Here and root `AGENTS.md` under ADR-0020; no evidence cutoff or review cadence. |
| Specialist index | Locates records owned and maintained by its specialist skill. | Meetings Index; stakeholder skill owns profiles and uses research maps only when justified, with no permanent entity index. |
| Meeting occurrence | Has an exact occurrence identity and can relate to transcripts, chat, recordings and artifacts. | Context frontmatter has `meeting_id` and `related_*` fields. |
| Source artifact or version | Has source identity, author/sender, dates, provenance and possibly a stable link or hash. | Evidence companion frontmatter and evidence rules. |
| Passage or contribution | Is anchored to a transcript, chat or email; has a source speaker/sender and attribution qualifications. | Context key-points table and attribution rules. |
| Person or organisation | Has a canonical profile and dated roles, positions, contributions and relationships relevant to a workspace. | Stakeholder profile templates. |
| Derived record | Summarises, extracts from or interprets one or more sources and should point readers back to them. | Context, profile and index templates. |
| Resource | Is referenced by one or more meetings; equivalent resource payloads may be retained once with per-meeting provenance. | Meetings capture rules. |
| Issued output | Has one canonical file and can have distribution events recorded in the index. | Common Architecture and Issued Outputs Index. |
| Governance principle | Has a stable ID and may be matched to a meeting context. | Archive Guide and context `matched_principles`. |

The inventory observes these links in current formats; it does not establish a new canonical identifier scheme or formal graph vocabulary. In particular, a signpost-to-folder link is structural navigation, not an evidence relationship.

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

1. Which common record kinds and relationship names need stable definitions, versus remaining skill-local?
2. Which attribution, decision-status, lifecycle, audience and coverage vocabularies are portable shared terms, and which need controlled extensions?
3. Which authority, effective-date, correction and supersession rules should be common semantics, and which are workspace-specific?
4. How should usage-rights terms be represented without implying permission from an unverified classification?
5. What should be searchable summaries or precise extracts, what must remain source-grounded, and how should stale or failed ingestion be reported?
6. Which domain terms and business definitions belong only in a workspace's governed controls, such as “Strategic Engagement” or “Active Programme”?

Resolving these questions may change skill behaviour or generated records. Until the related ADRs are accepted, this inventory is descriptive only; it does not authorise new required fields, vocabulary, migrations or capture behaviour.
