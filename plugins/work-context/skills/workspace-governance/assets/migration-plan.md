# Migration plan asset

Use a human review table first:

| Current path | Action | Destination | Observed identity/version | Reason | Risk/dependency | Approval |
|---|---|---|---|---|---|---|

Record target boundary, exclusions, all seven core roots, meaningful collections, reference repairs, protected items, unresolved lifecycle questions, retired containers and expected verification. Map old paths only for transition and recovery, not permanent alternatives.

For an independent ordinary-local-file batch, use this helper format. Values below are placeholders, not executable evidence:

```json
{
  "schema": "workspace-migration@1.0",
  "targetRoot": "C:\\Projects\\Example",
  "operations": [
    {
      "source": "Drafts\\Options.md",
      "destination": "20 Working\\Options.md",
      "sha256": "<observed-64-character-sha256>",
      "lastWriteTimeUtc": "<observed-ISO-8601-UTC-timestamp>"
    }
  ],
  "unresolved": [],
  "retiredRoots": ["Drafts"]
}
```

Paths within operations and retired roots are relative to the exact target. Each operation is one independent file move, not a directory, glob, dependency group or link rewrite. Unresolved entries are explanatory strings. Retired roots must be resolved through approved cleanup before full conformity; the helper never deletes them.

The plan digest is computed from the exact JSON bytes. Approval names that digest and the specific authority for writes. Changes to a plan require new approval. Helper journals bind schema, plan hash, target and prepared/completed operation indexes. They are operational records, not evidence that the project meets all semantic or cloud requirements.
