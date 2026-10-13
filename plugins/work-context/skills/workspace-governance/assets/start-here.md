# Start Here asset

Create `00 Start Here\Start Here.md` when absent.

Start the generated file with:

```yaml
---
document_role: workspace-start-here
template: workspace-start-here@1.1
created_by: workspace-governance@<CURRENT_SKILL_VERSION>
last_governed_by: workspace-governance@<CURRENT_SKILL_VERSION>
---
```

Replace `<CURRENT_SKILL_VERSION>` when creating the file. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill version does not by itself require migration.

Required sections:

1. Purpose and intended outcome.
2. Scope, adjacent scope and exclusions.
3. Current position, separating facts, proposals, decisions and approvals.
4. Links to every fixed root.
5. Current issued outputs.
6. Current working material.
7. Principal source material and gaps.
8. Systems of record.
9. Key meetings.
10. Key people and organisations.
11. Known gaps and decisions needed.

Keep it concise and navigational. Do not reproduce meeting indexes, entity profiles, task systems or detailed operating packs.
