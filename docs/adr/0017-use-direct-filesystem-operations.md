# ADR-0017: Use direct filesystem operations

- Status: Accepted
- Date: 2026-10-22

## Context

ADR-0016 left directory moves outside the optional helper and called for a platform-aware route without making tool selection clear. A helper limitation must not send basic file operations into GUI automation or turn a small folder reorganisation into a migration service. The owner requested core filesystem operations, including creating destinations, moving contents and deleting emptied old folders when required.

## Decision

Supersede [ADR-0016](0016-migrate-projects-through-approved-plans.md), retaining its seven-root destination, bounded approval, preservation, drift checks and honest partial outcomes.

All Work Context skills use direct filesystem tools or shell commands for basic local file operations, never Computer Use or Explorer/Finder automation. Prefer a direct folder rename/move. Where the approved layout needs it, create missing destinations, move contents without overwriting, verify the result and remove only approved old folders freshly confirmed empty, including hidden entries. Removal is non-recursive and never targets the project root or reparse-point targets.

Keep approval proportionate: a short before/after mapping in the conversation can bind a simple reorganisation, including named empty-folder cleanup and reference edits. Do not require JSON plans, hashes, helper execution or journals for direct operations. Record completed and remaining mappings; inspect both sides after interruptions rather than repeating moves or attempting speculative rollback. Changed scope, conflicts or meaning-changing decisions require resolution.

A sync-client path alone does not mandate a cloud API or make filesystem operations unsafe. Use supported filesystem operations when they meet the preservation requirements; use an authorised provider API/tool when restrictions or identity, version and shared-link guarantees require it. Hydration does not prove those guarantees. Missing tools or unestablished preservation are explicit blockers, not reasons to use a GUI or bypass protections.

The optional helper retains its independent-local-file, digest-bound and preview-by-default contract. Its refusal limits that helper, not every other supported route. Never overwrite content, infer duplicate deletion, alter sharing or permissions, reorganise software roots or move protected collections by implication. Skill ownership and tool permissions remain unchanged.

## Consequences

Routine folder work has a direct route without a mandatory helper workflow. Shared guidance applies to all three skills; the seven roots, ownership and governed-file schemas do not change. No existing workspace is automatically migrated or repaired by this release.

Validation is repository consistency, parser checks and manual instruction review only. Skill/helper execution, filesystem/provider behaviour, recovery, shared-link preservation and installed-client behaviour remain unverified and need separately authorised runtime checks.
