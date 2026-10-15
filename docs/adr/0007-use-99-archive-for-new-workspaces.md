# ADR-0007: Use 99 Archive for new workspaces

- Status: Accepted
- Date: 2026-10-15

## Context

The owner requested that Workspace Governance create `99 Archive` rather than `90 Archive`, with references kept consistent across the plugins. The folder-name correction was made before its associated version metadata was updated.

## Decision

Use `99 Archive` in the common folder structure and archive routing guidance. Record the shared architecture as version 1.2, Workspace Governance as 2.2 and the corrected plugin package as 1.0.1.

Preserve explicitly supplied legacy structures. Do not rename or move an existing archive without owner approval. This correction changes the default for newly initialised workspaces, not permission to migrate existing content.

## Consequences

New workspaces use the requested folder name. The skills' architecture metadata must all reference version 1.2. Existing workspaces can keep their established structure; an approved migration must repair affected links and preserve content.
