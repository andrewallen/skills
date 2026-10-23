# ADR-0005: Apply safeguards to meeting-evidence capture

- Status: Superseded by ADR-0012
- Date: 2026-10-14

## Context

At the time this proposal was written, the meeting evidence rules directed the skill to retain all accessible meeting evidence in full, including personal or private remarks and material marked Confidential or OFFICIAL-SENSITIVE. They also stated that OneDrive folders are secure by default and that sensitivity markings are not reasons to withhold material (`plugins/work-context/skills/meetings-governance/references/evidence-rules.md`, then lines 9–13).

This can conflict with applicable privacy, classification, retention, access-control or source-use requirements. A destination being generally approved does not establish that a particular item may be copied there or retained in full.

## Decision

**Proposed:** Require the skill to check that collection, copying, retention and destination access are authorised for the specific evidence and workspace. Apply the source's handling and retention requirements, minimise or redact content where required, and do not treat labels or an archive-owner request as overriding those requirements. If the permitted handling is unclear, pause that source and report the decision needed rather than copying it.

As proposed, this ADR did not itself change the skill instructions; owner acceptance was required before implementation.

The owner did not adopt this proposal as written. Its proposed handling policy is superseded by the owner-directed meeting-capture decision in [ADR-0012](0012-local-first-meeting-evidence-capture.md).

## Consequences

Had it been accepted, capture could have been partial where full retention was not authorised. ADR-0012 instead governs the current capture behaviour.
