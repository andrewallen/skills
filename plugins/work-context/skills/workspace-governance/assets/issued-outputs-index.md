# Issued Outputs Index asset

Create `10 Issued Outputs\Issued Outputs Index.md` when absent.

Use:

```markdown
---
document_role: issued-outputs-index
template: issued-outputs-index@1.1
created_by: workspace-governance@<CURRENT_SKILL_VERSION>
last_governed_by: workspace-governance@<CURRENT_SKILL_VERSION>
---

# Issued Outputs Index

## Canonical outputs

| Output ID | Title | Canonical file | Version or SHA-256 | Owner | Status | Working source | Handling | Superseded by | Notes |
|---|---|---|---|---|---|---|---|---|---|

## Distribution history

| Output ID | Audience | Relationship | Issued date | Channel or occasion | Evidence or source | Notes |
|---|---|---|---|---|---|---|
```

Replace `<CURRENT_SKILL_VERSION>` when creating the file. Preserve `created_by`. Update `last_governed_by` only after a material update or validation. A later skill version does not by itself require migration.

Append distribution rows instead of copying identical files by audience. Use only the common lifecycle vocabulary and distinguish approval from issue.
