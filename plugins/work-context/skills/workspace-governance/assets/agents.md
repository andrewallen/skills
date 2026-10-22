# AGENTS.md asset

Create `AGENTS.md` at the workspace root when absent during explicitly authorised initialisation or repair.

Start the generated file with:

```yaml
---
document_role: workspace-agent-guidance
template: workspace-agent-guidance@1.0
created_by: workspace-governance@<CURRENT_SKILL_VERSION>
last_governed_by: workspace-governance@<CURRENT_SKILL_VERSION>
---
```

Replace `<CURRENT_SKILL_VERSION>` when creating the file. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill or template version does not by itself require migration.

The body contains only stable, project-neutral guidance:

- Open `00 Start Here\Start Here.md` to navigate the standard workspace roots.
- Inspect the relevant current project files and their source records before answering questions about project status or facts; do not treat this file or Start Here as a project summary.
- Keep original or received evidence distinct from drafts, synthesis and exact issued outputs. Folder placement, filenames and AI assistance do not establish truth, approval or issue.
- Respect applicable workspace instructions, source access limits and existing provenance. Do not infer permission to move, rename, overwrite, archive, delete, share or change access.
- Use a specialist index to locate its owner's records; do not create a competing index or silently maintain another skill's files.

Do not copy installed skill procedures, list project files or people, state project status, prescribe a refresh cadence or imply that every AI client automatically discovers this file. Preserve any existing root instructions; do not replace or merge them without explicit authorisation.
