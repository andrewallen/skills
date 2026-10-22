# Meetings Index template

Create `Meetings Index.md` from this when absent. The index is the only archive inventory; do not create a separate manifest.

`inventory_status` is `provisional` after targeted intake or incomplete onboarding, and `complete-through-<date>` only when the confirmed initial range and source surfaces were exhausted.

```markdown
---
document_role: meetings-index
template: meetings-index@3.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
inventory_status: provisional
---

# Meetings Index

Historical meeting evidence for <WORKSPACE>.

This index is derived navigation. Source companions hold the captured evidence; context files provide synthesis, attributed extracts and labelled interpretation.

**Last completed archive reconciliation:** <TIMESTAMP OR not yet completed>
**Current pass:** <INTENT; actual execution time; scoped outcome>
**Effective review window:** <RANGE>
**Inventory status:** provisional
**Sources checked:** <SOURCE SURFACES>
**Discovery disposition:** <WHAT WAS ADDED, DEFERRED OR EXCLUDED>
**Remaining work:** <NONE OR concise source-specific next steps/blockers>

## Main meeting archive

| Date/time | ID | Meeting | Audience | Matched principles | Evidence | Context |
| --- | --- | --- | --- | --- | --- | --- |

## Calibrated candidates and supplementary records

| Meeting | Treatment | Reason | Preserved context |
| --- | --- | --- | --- |

**0 main meetings; 0 candidate, supplementary and excluded records.**
```

Replace `<CURRENT_SKILL_VERSION>` when creating the index. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill version does not by itself require migration.

Legacy indexes may retain their existing `Class` column and values. Preserve them; leave the legacy `Class` cell empty for new entries, and do not remove the column without owner approval.

Resume queue, kept under **Remaining work** while a pass is in flight:

| Item / exact source IDs | Done: retrieved locally / retrieved online / reviewed / retained locally | Resume: query and exact cursor/range, or none | Next step / blocker |
| --- | --- | --- | --- |

Canonical context link (relative to the index):

```markdown
[Context](2026-09-02%20-%20Descriptor/Context.md)
```
