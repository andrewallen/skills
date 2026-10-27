# ADR-0028: Capture to the meeting folder without a protection check, and flag unexpected destinations

- Status: Accepted
- Date: 2026-10-27

## Context

The meetings evidence rules told the agent that "the workspace's OneDrive folders are secure by default" and not to "assess, question or wait for destination protection before saving". No ADR recorded this data-handling rule, although [Governance](../../GOVERNANCE.md) requires one. The rule assumed every workspace sits in a managed OneDrive, while the skills accept any supplied path, and it asked the agent to suppress a check without giving it any way to surface a concern.

## Decision

- Meetings Governance saves in-scope evidence to the resolved meeting folder without holding capture to assess destination protection. This keeps the local-first capture of [ADR-0012](0012-local-first-meeting-evidence-capture.md).
- When the destination looks unexpected for the workspace, for example outside the expected OneDrive or sync root or different from the storage boundary recorded in the Archive Guide, the agent still saves and adds a **Destination** line to the run report, with the path and the reason, ahead of other results.
- A destination flag is information for the owner, not a blocker, an access request or permission to move content.

## Consequences

Capture stays fast and unblocked, and the owner sees when a workspace is not where it is expected to be. Reports gain one line in that case. The rule no longer assumes OneDrive. Other storage-boundary rules in the capture reference, such as retaining resources only within the authorised boundary, are unchanged.

The owner accepted this decision on 2026-10-27.
