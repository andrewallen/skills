# ADR-0013: Use a minimal shared evidence model across skills

- Status: Accepted
- Date: 2026-10-22

## Context

The skills need enough common structure to let one skill use another's records without rereading every source or requiring a particular producer skill. A broad information model could define many vocabularies and relationships, but the immediate functional need is narrower: preserve source identity and links, make derived information traceable, and distinguish what was retrieved, reviewed and retained. Requiring a universal schema, database or ontology would add maintenance without improving that outcome.

Meeting records also contain required `archive_class`, `baseline_version` and `baseline_impact` fields whose meanings and values were never established. The intended project workflow is to gather related meetings, retain their evidence locally where possible, and create anchored contexts that support later retrieval and synthesis. Those fields are not needed to identify project scope or navigate evidence.

## Decision

- Use a small repository-wide conceptual model: source and derived record; identity and explicit relationships; provenance/transformation; attribution and authority; relevant time and scope; retrieval, review and retention coverage; and lifecycle or decision status where the owning skill uses it.
- Keep these concepts distinct. A source, its excerpt, a synthesis and an inference are not interchangeable evidence. Derived claims link to the source and anchor where available. A derived record does not independently corroborate its source.
- For meeting capture, distinguish local retrieval, online retrieval, semantic review and local retention. Platform-applied classification labels are observed metadata under ADR-0012, not a shared content-classification vocabulary.
- Keep domain vocabularies and records with their owning skills. Meetings owns occurrence contexts and evidence; Stakeholder Governance owns profiles; Work Actions keeps its GitHub issue and execution-state model. Skills remain independently usable and exchange bounded source links or records without requiring another skill to run first.
- Do not require a common serialization, database, graph, new workspace root, universal business taxonomy or identical lifecycle values across plugins.
- Remove `archive_class`, `baseline_version` and `baseline_impact` from new meeting-context templates and retire class-based meeting routing and reporting. Project scope, occurrence identity, source relationships, anchored context content and workspace-specific principle links provide navigation. Do not use legacy class values to omit an in-scope source or alter local capture.
- Preserve existing workspace files and legacy class/baseline values. Do not migrate or delete them automatically. Update legacy records only within an explicitly authorised material update, preserving historical content.

This decision supersedes the broader proposal in [ADR-0009](0009-establish-a-shared-information-model.md) with a narrower shared model. It does not accept [ADR-0008](0008-define-independent-skill-contracts.md) or [ADR-0010](0010-define-evidence-retrieval-semantics.md) in full.

## Consequences

Skill authors have shared concepts for source traceability and bounded interoperability without a repo-wide schema. Each skill can keep the fields needed for its operation, while contributors can evaluate their meaning against a consistent core. Meeting records and review materials become simpler, but class counts and class-specific routes are no longer generated. Existing workspaces remain readable and unchanged unless their owner authorizes an update.
