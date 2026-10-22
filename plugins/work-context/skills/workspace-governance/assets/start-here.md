# Start Here asset

Create `00 Start Here\Start Here.md` when absent during explicitly authorised initialisation or repair.

Start the generated file with:

```yaml
---
document_role: workspace-navigation
template: workspace-start-here@3.0
created_by: workspace-governance@<CURRENT_SKILL_VERSION>
last_governed_by: workspace-governance@<CURRENT_SKILL_VERSION>
---
```

Replace `<CURRENT_SKILL_VERSION>` when creating the file. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill or template version does not by itself require migration.

Use this reusable body and link each root using relative links:

```markdown
# Start Here

This page is a map of the project folders. The project folder name identifies the project; use the files in the relevant folder for its current information.

| Folder | What belongs here |
|---|---|
| [00 Start Here](./) | This stable folder map. |
| [10 Issued Outputs](../10%20Issued%20Outputs/) | Exact versions deliberately issued and their distribution record. |
| [20 Working](../20%20Working/) | Drafts, analysis, synthesis and AI-assisted work. |
| [30 Sources](../30%20Sources/) | Original or received evidence and reference material. |
| [40 Meetings](../40%20Meetings/) | Meeting occurrence evidence and its specialist navigation. |
| [50 Stakeholders](../50%20Stakeholders/) | Evidence-backed person and organisation records. |
| [99 Archive](../99%20Archive/) | Superseded, withdrawn or inactive material retained in the project. |
```

The map covers only the seven stable core roots; do not list optional supplementary folders or files. The project folder name supplies project identity; do not add a project narrative.

Do not include current position or status, file inventories, issued or working file lists, principal sources, systems of record, named meetings, people or organisations, evidence cutoffs, review dates, outstanding gaps, decisions needed or claims that a collection is empty or current. Do not duplicate the Meetings Index, meeting contexts, stakeholder profiles, task records or an agent instruction file.

The generated navigation should remain accurate when arbitrary project files are added, changed or removed, provided the common folder roles themselves do not change.
