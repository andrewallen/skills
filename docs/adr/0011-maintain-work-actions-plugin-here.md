# ADR-0011: Maintain the work-actions plugin in this repository

- Status: Proposed
- Date: 2026-10-20

## Context

The reusable action-ledger skill, its references, assets and manual PowerShell helpers were first packaged as `work-actions` in the owner's operational ledger repository, `work-actions` (merged at `a2ef997809b8c4f1b30bfb1f18b5a5ebe0dd6b20`). The owner asked to move the plugin here and manage it here. This repository already catalogues and maintains `work-context`, under accepted [ADR-0002](0002-package-skills-as-agent-plugin.md) and [ADR-0006](0006-version-and-publish-plugin-changes-together.md).

## Decision

- `andrewallen/skills` is the canonical source for the `work-actions` plugin (identity unchanged) and its `action-ledger` skill, references, assets and helper scripts, at `plugins/work-actions`.
- The marketplace `andrewallen-personal-skills` registers it beside `work-context`. Plugin version is taken only from its manifest.
- The ledger repository remains the operational ledger: its configuration, Project identifiers, records and workflow policy stay there and are not copied here. It may keep a clearly identified, version-pinned vendored snapshot of only the helper scripts it needs, so its root commands stay offline and deterministic; it must not depend at runtime on an installed plugin directory. The snapshot is not a second source.
- The helpers are the first executable components in this repository. ADR-0002's "no executable components" applies to `work-context`, which is unchanged. Helpers stay manual, preview by default, require PowerShell 7.2+ and authenticated `gh`, and require an explicit absolute `-TargetPath` plus matching `-Repository`. No hooks, MCP servers, runtime downloads or automation are added.
- Isolated helper and package checks live in `scripts/test-work-actions-plugin.ps1` with synthetic fixtures.

This does not change action workflow authority, handoff or acceptance semantics, and does not adopt any Proposed ledger ADR.

## Consequences

Helper or reference changes are made and versioned here (patch/minor/major per [Governance](../../GOVERNANCE.md)); a ledger repository updates its pinned snapshot deliberately. Skill runtime-dependency metadata may now name helper prerequisites instead of `none`, and the repository check enforces that. Existing `work-actions@anallen-work-actions` installations must be replaced by `work-actions@andrewallen-personal-skills`; ledger records need no migration.

The owner requested the move directly; this ADR records the decision for review and remains Proposed until the owner accepts it.
