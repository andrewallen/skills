# ADR-0014: Record meeting evidence coverage per source

- Status: Accepted
- Date: 2026-10-22

## Context

New meeting contexts required one `capture_status` token, but the package did not define an authoritative set or criteria for those tokens. A per-source evidence-coverage table already distinguishes local retrieval, online retrieval, semantic review and local retention. Meeting archive inventory and maturity are separate, archive-level measures.

An aggregate status would duplicate those per-source facts and could conflate local retention with online review. This decision applies the minimal evidence model in [ADR-0013](0013-minimal-shared-evidence-model.md) to meeting contexts and narrows the per-context capture-status guidance in [ADR-0012](0012-local-first-meeting-evidence-capture.md).

## Decision

- Remove the per-context `capture_status` field from new meeting-context templates. The per-source evidence-coverage table is the record of retrieval, online review, semantic review and local retention.
- Keep local retention and online review distinct. An online-reviewed source that was not retained locally must remain explicitly identified as not captured locally; an inaccessible source must be reported as a coverage gap with its actual limitation.
- Keep archive `inventory_status` and archive maturity separate from source-level coverage. Neither establishes local-retention completeness; use the coverage rows to determine which in-scope sources were retained locally.
- Preserve existing contexts and their `capture_status` values as historical data. Do not migrate them automatically or use legacy values to gate capture or review.

## Consequences

Source-level coverage communicates what was retrieved, read and retained without an undefined aggregate vocabulary. Readers must consult the evidence-coverage table rather than rely on a one-word per-context summary. The context template schema changes and gains a version key; new records use template `meeting-context@1.0`, while existing workspace records, which carry no template version, remain untouched unless their owner authorizes an update.
