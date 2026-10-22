# ADR-0016: Migrate projects through approved plans

- Status: Superseded by ADR-0017
- Date: 2026-10-22

Superseded by [ADR-0017](0017-use-direct-filesystem-operations.md), which clarifies direct file operations, proportionate plans and approved empty-folder cleanup.

## Context

Keeping each legacy layout through a permanent path map would not deliver consistency. Migration needs bounded authority, preservation, repeatable progress and explicit handling of shared links and concurrent edits.

## Decision

Workspace Governance assesses, plans, applies, resumes and verifies physical convergence on ADR-0015. Source-to-destination mappings are transitional records, not permanent alternative architectures. A concrete approved plan binds the target, operations, observations, dependencies and reference repairs. No repeated questions are needed for routine already-approved work, but tool permissions still apply.

Preserve source identities, non-identical versions, owner notes and provenance. No implicit overwrite, deletion, deduplication, issue, approval, permission change or publication is allowed. Drift pauses affected work. Unresolved items, legacy roots and link limitations remain explicit gaps; partial progress is not full conformity.

Bundle a preview-by-default PowerShell helper for independent ordinary-local-file moves, digest-bound application and progress. It does not migrate directories/cloud storage, hydrate protected files, bootstrap the project, rewrite references or delete retired containers. Those require separately authorised appropriate operations. Journals are not collaboration locks. Recovery revalidates state.

Keep software and nested repository boundaries explicit. Shared/cloud operations must use supported platform-aware routes; local moves do not establish link/history preservation.

## Consequences

Work Context now has an optional PowerShell prerequisite for this helper, not a GitHub dependency or mandatory migration service. Public examples are fictional; real plans and evidence stay in authorised private targets. Installation never authorises migration.

The implementation's validation scope is static package, parser and consistency checks only. Skill execution, helper execution, live migration and cloud-link preservation are intentionally not verified by this change. Runtime and installation validation require a separate authorised exercise before operational claims.
