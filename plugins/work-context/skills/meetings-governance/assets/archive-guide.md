# Archive Guide template

Create `Archive Guide.md` from this when absent. The guide may start `provisional`. Derive a short initial set of working principles from the confirmed outcome and refine them through calibration; do not invent detail. Give each principle a stable kebab-case ID plus description, and use those IDs in contexts and the index; do not substitute ad hoc topic labels. Single-quote Windows paths.

```markdown
---
document_role: meeting-archive-guide
template: meeting-archive-guide@1.1
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
workspace_code: "<WORKSPACE_CODE>"
archive_owner: "<PERSON OR not specified>"
owner_organisation: "<ORGANISATION>"
owner_timezone: "<TIMEZONE>"
approved_at: "<TIMESTAMP OR provisional>"
current_work_system: "<SYSTEM OR not specified>"
meetings_root: '<RESOLVED PATH>'
issued_outputs_root: '<RESOLVED PATH>'
working_material_root: '<RESOLVED PATH>'
source_material_root: '<RESOLVED PATH>'
people_organisations_root: '<RESOLVED PATH>'
media_recordings_root: '<RESOLVED PATH>'
governance_root: '<RESOLVED PATH>'
archive_root: '<RESOLVED PATH>'
initial_discovery_range: "<RANGE OR targeted-intake-only>"
inventory_status: provisional
---

# <WORKSPACE> Meeting Archive

## Purpose and intended outcome

<Confirmed workspace outcome and why meeting evidence is retained.>

## What belongs

<Clear inclusion rules.>

## Adjacent subjects

<Subjects requiring an explicit material connection.>

## What does not belong by default

<Clear exclusion rules.>

## Working principles

<Stable kebab-case ID: description.>

## Meeting classes

<The class and baseline-impact tables from the skill.>

## Evidence and retention rules

<Exact occurrence, provenance, sensitivity and class-specific retention. Include the compact Captured / Extracted / Synthesised / Inferred / Proposed legend, stating that information type is distinct from archive class, capture status and approval.>

## Storage and protection

<Approved boundary, resource roots and known limitations.>

## Current-work authority

<Where current actions/status live, or that none is specified.>

## Human calibration

<Approved examples added during onboarding and later reviews.>

## Scope history

<Dated entries: baseline version, what changed in scope or principles, why, approved by. Retired principle IDs are listed here, never reused.>
```

Replace `<CURRENT_SKILL_VERSION>` when creating the guide. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill version does not by itself require migration.
