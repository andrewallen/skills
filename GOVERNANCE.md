# Governance

This is a personal repository. It governs how the `work-context` plugin and any future plugins are changed and distributed. It does not govern the workspaces the skills operate on; those rules live in the plugin's [Common Architecture](plugins/work-context/Common%20Architecture.md).

## Roles

- **Owner:** `andrewallen` decides scope, approves changes and publishes releases.

## Decisions

- Significant decisions are recorded as Architecture Decision Records in [docs/adr](docs/adr/README.md).
- A decision is significant if it changes plugin structure, skill ownership boundaries, the manifest or marketplace format, distribution, or data-handling rules.
- Superseded ADRs are kept and marked, never deleted.

## Changes

- Work on a branch and merge to `main` by pull request where practical.
- Update a skill's `metadata.version` when its behaviour changes, and the plugin version in `plugin.json` when distributing an update.
- Keep governed-file template versions separate from skill and plugin versions.
- Update the README when layout, installation or maintenance steps change.

## Content rules

- Do not commit workspace evidence, customer documents, generated outputs, credentials or local caches.
- Examples must be anonymised.
- Changes to data-handling guidance (for example capture, retention or redaction rules) need an ADR.

## Licensing

No reuse licence is currently configured; all rights are reserved until the owner chooses one (see [ADR-0004](docs/adr/0004-licence-not-yet-chosen.md)).
