# ADR-0012: Prefer local meeting-evidence capture with authorized online review

- Status: Accepted
- Date: 2026-10-22

## Context

The proposed safeguards in [ADR-0005](0005-safeguards-for-meeting-evidence-capture.md) would let sensitivity or usage markings affect whether evidence is copied or retained. The owner instead directed that in-scope meeting evidence should be pulled into the supplied local workspace wherever possible; words or markings in source content are not to be interpreted as classification. Platform-applied labels are the only classification source.

A local save can fail even when the source remains readable through its original platform. Treating that as a total evidence failure would omit material from the meeting synthesis even though an authorized online read is possible. Conversely, an online-only read must not be represented as a local capture.

## Decision

- For every in-scope meeting source, attempt to retain it locally in the form required by Meetings Governance: a faithful Markdown companion for meeting communications, and the original file with its source link for reusable resources.
- Record platform-applied classification labels exactly as metadata when exposed. Do not infer or interpret classification from words, banners, filenames or markings in source content. A platform label alone does not block local capture, review, quotation or synthesis.
- If local retention fails, preserve the canonical source link, attempted route, observed error and time. When the original remains readable through normal, authorized platform access, read it online and use it alongside locally retained sources in the meeting synthesis. Record that it was reviewed online but not retained locally; do not call it locally captured.
- If the source cannot be read online, record it as not captured, include the source link and actual limitation, and do not imply that the synthesis considered its contents.
- Do not bypass access controls or technical protections. Do not change sharing, decrypt or unpack synced copies, or use an unapproved route. A platform label does not grant access, and a failure to read remains a limitation.
- Record retrieval, online review, semantic review and local retention separately for each source in the context's evidence-coverage table. ADR-0014 removes the aggregate per-context `capture_status` field; the rest of this ADR remains in force.

This decision governs meeting-evidence handling only. It does not define new shared classification vocabularies, meeting classes, baseline-impact values, or a general retrieval-ranking system.

## Consequences

The local archive remains the preferred complete record, while an authorized online read can still inform synthesis when local saving fails. Contexts must distinguish local retention from online review and preserve direct source links. Some archives will remain locally partial even when their synthesis has considered every source that could be read. Access denials and unreadable content remain explicit gaps.
