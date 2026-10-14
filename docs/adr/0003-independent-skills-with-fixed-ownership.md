# ADR-0003: Keep skills independent with fixed ownership boundaries

- Status: Accepted
- Date: 2026-10-14

## Context

Workspace structure, meeting evidence and stakeholder profiles overlap in practice. Blurring them risks duplicated archives, circular corroboration and unrequested changes.

## Decision

Follow the ownership table in [Common Architecture](../../plugins/work-context/Common%20Architecture.md):

- `workspace-governance` owns fixed roots, Start Here, the Issued Outputs Index, routing and duplicate review.
- `meetings-governance` owns meeting discovery, capture, contexts and the index.
- `stakeholder-governance` owns evidence-backed person and organisation profiles.

Skills have no runtime dependency on one another. Handoffs are optional and bounded. One skill never creates or repairs another's files, and neither uses the other's outputs as independent evidence.

## Consequences

Each skill can be used alone and has a clear completion check. Cross-skill work needs explicit handoffs, and the user's request must authorise each skill that runs.
