# ADR-0015: Standardise project folders and navigation

- Status: Superseded by ADR-0020
- Date: 2026-10-22

## Context

Projects need consistent physical organisation that supports human browsing, direct document sharing and selective AI reasoning. A folder tree alone cannot establish authorship, authority or lifecycle. Excessive names, format layers and mandatory subfolders make navigation and paths harder.

## Decision

Use seven fixed roots: `00 Start Here`, `10 Issued Outputs`, `20 Working`, `30 Sources`, `40 Meetings`, `50 Stakeholders`, `99 Archive`. All are present after full initialisation or migration. Additional folders are unnumbered, short and purposeful; they must not compete with core roles. Governance is an optional unnumbered control area. Media follows its purpose.

Preserve meaningful subcollections, keep paths shallow and avoid repeating project names. New meeting records use short occurrence folders with role-named companions; audience and format do not require extra layers. Existing content changes only under approved migration.

Created or materially updated project outputs visibly communicate purpose, lifecycle, dates, provenance and material limitations in their native format. Received originals remain faithful. AI involvement, authority, approval and issue are distinct. Navigation is source-linked and concise, not a second archive or independent corroboration.

Skills consume suitable supplied evidence without requiring its producer, while retaining domain requirements and ownership. This accepts only that bounded interoperability and source-grounding scope, not the whole proposals in ADR-0008 or ADR-0010.

## Consequences

Common Architecture advances to 2.0; affected skills and templates change with the package. Existing projects are not silently migrated. The accepted `99 Archive` name in ADR-0007 and independent ownership in ADR-0003 remain valid. New roots replace previous active defaults, not historical records. ADR-0020 supersedes this decision's navigation requirements and changes navigation policy only (its decision 8). The rest remains in force: ADR-0020 decision 1 retains the seven fixed roots, their routing roles and bounded producer-neutral source consumption, and Common Architecture carries the folder, path and output-metadata rules, with static signposts as the stated exception to the visible-metadata rule.
