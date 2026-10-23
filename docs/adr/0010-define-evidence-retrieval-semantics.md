# ADR-0010: Define evidence retrieval and interpretation semantics

- Status: Proposed
- Date: 2026-10-20

## Context

The skills already contain important rules about what evidence supports a claim: attendance is not endorsement, an individual statement is not automatically an organisational position, a summary is not independent corroboration of its source, and an access failure is not proof that evidence does not exist.

The recent discussion of AI knowledge bases adds a useful retrieval pattern: retain source material, create searchable summaries and precise extracts, use those representations to find relevant material, and return to the source to ground conclusions. It also highlights freshness and checking whether ingestion is working. These ideas complement the existing evidence rules but do not define a formal query engine or justify recency-only ranking.

## Decision

**Proposed:** Define shared semantics for finding, evaluating and using evidence, independent of any specific skill or search technology.

The guidance should establish that:

1. Search results, summaries and extracts are discovery aids; material claims must be grounded in the relevant source and anchor where available.
2. Derived records preserve their relationship to source records and are not independent corroboration of those sources.
3. Attribution, authority, source independence, effective time, observation time and coverage qualify what may be concluded.
4. Newer information does not automatically supersede older information; authority, applicability, effective dates and explicit correction or supersession evidence matter.
5. Failed or bounded searches are reported with their actual scope and limitations; a missing result is not global proof of absence.
6. Workspace-specific business definitions and metrics belong to workspace governance, not the portable plugin core.

Summaries, extracts, metadata and other retrieval representations may be used without creating a new information-provenance type or mandatory folder. No specific ranking algorithm, vector database, background ingestion service or retention policy is selected by this proposal.

This proposal does not change current skill behaviour until accepted and implemented.

## Consequences

Consistent retrieval semantics can improve agent answers without requiring a new storage platform. The guidance must remain compatible with source-handling rules, and should distinguish a useful navigation representation from evidence sufficient to support a conclusion. Current position: points 1, 2, 3 and 5 already appear in Common Architecture and the specialist evidence references. Point 4 is only partly stated and point 6 is not. No shared retrieval reference exists. This proposal remains Proposed.

Acceptance will require aligning the shared guidance with each skill's existing evidence and source-use instructions. Any resulting behavioural change must be versioned and validated under repository governance.
