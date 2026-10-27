# ADR-0026: Bound occurrence discovery and close known assets

- Status: Accepted
- Date: 2026-10-27

## Context

Meetings Governance already distinguishes retrieval, online review, local retention and authorised recovery routes. Those safeguards do not by themselves establish that discovery covered the relevant occurrence surfaces or that a known asset reference was followed through to its payload. In particular, search results can be mistaken for inventories, and chat messages may reference hosted images that are not exposed as ordinary attachments. A link or metadata record can therefore be preserved while the media bytes remain unretained and unreviewed.

The guidance needs a bounded way to account for relevant source collections and known assets without turning an occurrence capture into unrestricted tenant or filesystem search, duplicating the archive with a new manifest, or requiring a new service.

## Decision

- Inventory relevant sources within the approved occurrence, date/change window and storage boundary: meeting/transcript/recording objects, occurrence and follow-up conversations, tied correspondence, attendance, notes/recaps, shared resources, attachments and inline/hosted media.
- Treat semantic search and path discovery as candidate discovery, not proof of collection completeness or source absence. Enumerate supported exact collections/pages and record their scope, counts and limitations.
- Resolve references to stable source identities and versions where possible. Deduplicate identical payloads for storage but preserve their per-occurrence relationships.
- Distinguish references, unique source objects, metadata, complete payload bytes, local retention and semantic/visual review. Give every known in-scope asset an evidenced outcome or specific gap; do not leave an accessible, authorized asset as a pointer when an applicable existing route can retrieve it.
- For hosted images, inspect supported message bodies and hosted-content relationships independently of attachment arrays. Metadata and links are not image bytes. Do not claim a platform rendition is the original camera file without evidence. Use supported visual inspection/OCR for review when appropriate, while retaining the source in its original form and labelling derived OCR as a review aid.
- Use existing context coverage/resource records and the recovery order in ADR-0024. This decision does not expand source access, storage scope or permissions, require a new tool/server/manifest, or authorize a workspace migration.

## Consequences

Coverage reports become more explicit about what was checked, what is known, what was retained and what remains unresolved. More partial results may be clearly reported because absent totals, inaccessible byte routes and unknown overlaps remain visible instead of being hidden by a search summary or link.

The change adds no runtime dependency and does not migrate existing meeting archives. Static instruction validation cannot prove that a particular provider exposes hosted-image bytes, that a transfer completes, or that an installed client follows these steps; those require separately authorized runtime testing.
