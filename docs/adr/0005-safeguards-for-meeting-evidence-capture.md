# ADR-0005: Apply safeguards to meeting-evidence capture

- Status: Proposed
- Date: 2026-10-14

## Context

The current meeting evidence rules direct the skill to retain all accessible meeting evidence in full, including personal or private remarks and material marked Confidential or OFFICIAL-SENSITIVE. They also state that OneDrive folders are secure by default and that sensitivity markings are not reasons to withhold material (`plugins/work-context/skills/meetings-governance/references/evidence-rules.md`, lines 9–13).

This can conflict with applicable privacy, classification, retention, access-control or source-use requirements. A destination being generally approved does not establish that a particular item may be copied there or retained in full.

## Decision

**Proposed:** Require the skill to check that collection, copying, retention and destination access are authorised for the specific evidence and workspace. Apply the source's handling and retention requirements, minimise or redact content where required, and do not treat labels or an archive-owner request as overriding those requirements. If the permitted handling is unclear, pause that source and report the decision needed rather than copying it.

This ADR does not itself change the current skill instructions. The owner must accept or reject this proposal before the evidence rules and related capture instructions are changed.

## Consequences

If accepted, capture may be partial where full retention is not authorised. The skill will need clear steps for recording a source-specific restriction, preserving only permitted material, and reporting what was not captured. This may reduce completeness, but avoids treating accessibility or a generally approved destination as sufficient authority to retain sensitive content.
