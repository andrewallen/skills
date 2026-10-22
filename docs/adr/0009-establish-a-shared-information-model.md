# ADR-0009: Establish a shared information model

- Status: Superseded by ADR-0013
- Date: 2026-10-20

## Context

The plugin uses shared concepts across workspace, meeting and stakeholder work, but their definitions are distributed between Common Architecture, specialist skill references and templates. Similar words can describe different dimensions: for example, the information type `Proposed`, a recorded meeting proposal and an ADR status of `Proposed` are not interchangeable.

The current structure also contains unresolved or underspecified vocabularies, including meeting class, baseline impact and capture status. A current-state inventory is available in [Current information model inventory](../current-information-model.md).

## Decision

**Proposed:** Establish one technology-neutral shared information model for portable concepts, and keep specialist and workspace-specific extensions separate.

The model should distinguish:

- vocabulary and definitions;
- classification dimensions (taxonomy);
- concepts and their relationships (ontology);
- information needed to describe those concepts (information model);
- logical identities and links between records;
- interpretation rules used when answering questions;
- physical storage and presentation.

The shared core should cover evidence, provenance, attribution, coverage, time, lifecycle, authority and derived information. Meeting-specific occurrence and capture concepts remain a Meetings Governance extension; entity-profile concepts remain a Stakeholder Governance extension. Workspace owners may define domain concepts and business meanings in their governed workspace controls without making those concepts universal plugin requirements.

The model should not require a database, graph store, semantic-search service, new workspace root or a particular serialization format. Existing controlled vocabularies are not changed or extended by this proposal alone. Unresolved values must be decided explicitly before they become required fields or behaviour.

This proposal does not accept or supersede [ADR-0005](0005-safeguards-for-meeting-evidence-capture.md).

## Consequences

A neutral reference can reduce duplicated definitions and make compatible records easier to consume across skills. It also requires explicit ownership for each shared term and a compatibility strategy before changing existing templates.

Had it been accepted, this proposal would have required defining the outstanding vocabularies, checking all skill and template references, and determining which shared-reference changes affect skill versions, architecture versions and the plugin package. Existing workspace records must not be migrated automatically.

The owner selected a narrower conceptual model without a universal schema or new shared vocabularies. See accepted [ADR-0013](0013-minimal-shared-evidence-model.md); this broader proposal was not implemented as written.
