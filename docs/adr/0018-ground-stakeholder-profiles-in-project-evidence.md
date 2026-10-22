# ADR-0018: Ground stakeholder profiles in project evidence

- Status: Accepted
- Date: 2026-10-22

## Context

A review of recent project use found that stakeholder profiles were carefully attributed but not always grounded in what the project actually held. Reports, presentations and other retained documents were linked or checked by title and metadata while a profile described its review as complete. Thin evidence was expanded into the full template, and wider relationship context competed with evidence relevant to the project. Start Here pages still described the stakeholder collection as empty after profiles existed. Retained-but-unread, inaccessible and not-retained sources were reported in the same terms. Profile creation also implied broad Microsoft 365 research that had not been authorised, and profiles were created for Microsoft and its employees, contrary to the owner's direction.

This decision complements [ADR-0013](0013-minimal-shared-evidence-model.md) and [ADR-0014](0014-record-meeting-evidence-coverage-per-source.md), preserves the ownership boundaries in [ADR-0003](0003-independent-skills-with-fixed-ownership.md), and does not change meeting capture under [ADR-0012](0012-local-first-meeting-evidence-capture.md).

## Decision

- **Work from project files by default.** Stakeholder Governance builds and refreshes profiles from the project's available local files and supplied material: Sources, Meetings, Working, Issued Outputs and relevant retained history. A link or pointer to material outside the project is a lead, not reviewed content. Searching Microsoft 365, verifying directory roles, researching public sources or following external links needs separate explicit authorisation for a stated question; WorkIQ or equivalent tools are a dependency only for that research.
- **Do not profile Microsoft or Microsoft employees.** Their attributed contributions remain in source evidence and meeting contexts and may inform analysis of a counterpart, but they do not receive stakeholder profiles. Where affiliation is unclear, report it or ask one focused question; do not infer it. An existing profile of an excluded entity in a workspace is flagged, not deleted, moved or silently rewritten.
- **Read the relevant documents.** A profile review is complete only when the relevant available content has been read. File presence, titles, metadata, search snippets and links are not review. If content is unreadable or no local reader is available, say so rather than skipping it or adding a dependency without approval. A partial review remains useful when labelled partial, with the material unread sources and their reasons named.
- **Lead with project-relevant evidence.** Include wider relationship context found in the project, but lead with evidence relevant to the project's purpose and keep adjacent contributions distinct from project requirements. Ordering is qualitative; there is no scoring.
- **Scale profiles to the evidence.** The person and organisation templates permit a compact provisional form for thin evidence, expanded as evidence warrants. There remains one template per entity type and no separate provisional template family.
- **Keep orientation honest without cross-writing.** A specialist that finds another owner's orientation stale reports it through a bounded handoff and does not edit that owner's files. Workspace Governance checks the actual local records before stating that a collection is empty or lagging, and separates the orientation's review date from the evidence cutoff.
- **Leave meeting capture unchanged.** Retaining a resource original continues to record retention, not that its content was read, as under ADR-0014. A consumer that relies on a document reads it.
- **Add no new machinery.** No new schema, database, stakeholder index, scoring system, extraction service or mandatory research map. Existing workspaces are not migrated or edited retroactively.

## Consequences

Profiles are grounded in the project's own documents and state plainly what was not read. Reviews may take more reading and report more gaps instead of implying completeness, and owners who want Microsoft 365 or public research must ask for it. The change narrows the default profiling scope and entity eligibility, so the plugin, Stakeholder Governance and the person and organisation templates take major versions, while Workspace Governance and the Common Architecture take compatible updates. Meetings Governance's behaviour is unchanged: it updates its architecture reference and one descriptive row about the stakeholder skill, without a version bump. Existing profiles and orientation pages are not edited automatically; later authorised maintenance applies the new guidance. [ADR-0008](0008-define-independent-skill-contracts.md) and [ADR-0010](0010-define-evidence-retrieval-semantics.md) remain Proposed.
