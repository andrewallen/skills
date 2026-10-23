# Migration plan asset

For a simple reorganisation, put a short before/after mapping in the conversation. This table is available for larger plans, not a required file or schema:

| Current path | Action | Destination | Observed identity/version | Reason | Risk/dependency | Approval |
|---|---|---|---|---|---|---|

Record target boundary, exclusions, all seven core roots, meaningful collections, reference repairs, protected items, unresolved lifecycle questions, retired containers and expected verification. Map old paths only for transition and recovery, not permanent alternatives.

Name the approved empty old folders to remove after contents have moved and been verified. Direct filesystem rename/move or create/move/empty-folder cleanup needs no helper JSON, digest or journal. Use the following format only when choosing the optional helper for an independent ordinary-local-file batch. Values below are placeholders, not executable evidence:

```json
{
  "schema": "workspace-migration@1.0",
  "targetRoot": "C:\\Projects\\Example",
  "operations": [
    {
      "source": "Drafts\\Options.md",
      "destination": "20 Working\\Options.md",
      "sha256": "<observed-64-character-sha256>",
      "lastWriteTimeUtc": "<observed-ISO-8601-UTC-timestamp-with-seven-fractional-digits>"
    }
  ],
  "unresolved": [],
  "retiredRoots": ["Drafts"]
}
```

Paths within operations and retired roots are relative to the exact target. Each operation is one independent file move, not a directory, glob, dependency group or link rewrite. Unresolved entries are explanatory strings. Retired roots must be resolved through approved cleanup before full conformity; the helper never deletes them.

For helper execution, the plan digest is computed from the exact JSON bytes. Approval names that digest and the specific authority for writes. Changes to approved scope require new approval. The helper compares `LastWriteTimeUtc.Ticks` exactly as well as the file SHA-256; record the observed UTC value with seven fractional digits (`DateTime` round-trip format) so tick precision is preserved. A filesystem that rounds modification times can cause a safe false refusal. Helper journals bind schema, plan hash, target and prepared/completed operation indexes. They are operational records, not evidence that the project meets all semantic or cloud requirements.
