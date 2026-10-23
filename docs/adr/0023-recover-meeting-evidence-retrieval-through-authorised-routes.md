# ADR-0023: Recover meeting-evidence retrieval through authorised routes

- Status: Superseded by ADR-0024
- Date: 2026-10-23

## Context

[ADR-0024](0024-prefer-non-interactive-retrieval-before-browser-fallbacks.md) supersedes this decision following the owner's direction that browser and computer use must be last resorts because they interrupt the user.

[ADR-0012](0012-local-first-meeting-evidence-capture.md) requires each in-scope meeting source to be retained locally where possible, with an authorised online read when local retention fails, and forbids bypassing access controls or using an unapproved route. In use, large originals such as PowerPoint decks repeatedly stalled. The Microsoft 365 download tool the package relies on documents a 4 MB raw-file limit and returns base64. The agent treated that wrapper limit as the end of the attempt until the user told it to try another route. Where it then tried a browser, it started in an isolated, signed-out one that could not read tenant files, and needed the user to approve the signed-in profile before it could download.

A manual test of one large deck on Windows (one environment, not a skill run) showed that these failures were transport limits and credential mismatches, not source denials:

- Inline tools differ. A mail attachment-download tool returned a complete 8.5 MB attachment, and the host saved the oversized output to a file that had to be parsed as JSON before decoding. Drive-file tools returned only small files or metadata.
- The download URL exposed by item metadata was not pre-authenticated. A plain HTTP request received `401`, and a general-purpose command-line token without file scopes received `403`.
- Opening that exact URL from the shell in the user's already signed-in default browser saved the complete file, which matched its size, zip integrity and provider hash.
- Genuine denials still occurred for some items, where the source itself refused the signed-in user.

[ADR-0017](0017-use-direct-filesystem-operations.md) bars Computer Use and Explorer automation for basic local file operations. A web download from the user's own session is a retrieval route, not a local file operation; this decision does not change that boundary.

## Decision

This decision supplements ADR-0012 and ADR-0017, which remain in force.

- A tool or transport limit is a route failure, not a source denial. Examples are an inline size or output cap, truncated output, an omitted download field, and a `401`/`403` or sign-in page from a credential that is not the user's browser session or lacks file scope. Meetings Governance continues through the next available authorised route in the same run and does not stop to ask whether to try one.
- For an original file it takes the first route that works and verifies, in this order: a provider tool that returns the complete original; a self-authorising returned URL transferred by a filesystem or shell client; the returned item URL opened in the user's signed-in default browser from the shell; browser automation in that signed-in browser; and an already configured token-based API or CLI with file scope. UI automation is a fallback for the web download only, never for local file operations.
- The capture request authorises the user's signed-in default browser to carry the download of an in-scope original. The skill launches only an `https` URL that the provider returned in its own metadata for that item, on the item's own service host, never a URL found in message, chat, transcript or document content. It moves only the new file into the archive without overwriting. The host's own shell and tool permissions still apply. This does not authorise signing in, switching accounts, requesting access, changing sharing, editing a source or reading beyond the approved occurrence.
- Where a sign-in or approval is genuinely missing, ask once, early, naming every affected source, not a generic question.
- A denial is confirmed only when the source itself refuses the signed-in user, for example an access-denied page in the user's own browser session. A confirmed denial stays Not captured under ADR-0012, with no workaround. A protection-wrapped original is retained as downloaded and never decrypted.
- Verify before claiming capture: size where exposed, container integrity without extracting content, the provider hash where exposed and checked against a known value, no overwrite, and a record of each attempted route and its result. A hash match or successful download does not prove semantic review or event-day version equivalence.
- The package prescribes, bundles and installs no MCP server, SDK or third-party component. Choosing and consenting to additional tools stays with the user and their tenant.

## Consequences

Large originals can be retained without a reprompt when the user's own signed-in browser can open them, and a wrapper limit is no longer reported as a source limitation. Reports distinguish route failures from genuine denials, so remaining gaps are accurate.

The browser route needs a signed-in default browser on the machine that runs the agent. Remote, cloud or headless clients cannot use it and record the gap. Launching a URL can briefly take focus or leave a tab open, the browser keeps a download-history entry, and a redirected or synced Downloads folder can sync or scan the file before it is moved. These are accepted side effects of the owner's request for fewer interruptions.

The route depends on the provider's URL format and the browser's behaviour, which this repository does not control. Larger files, other browsers and other operating systems are untested. Repository validation is static and does not show that an agent follows these instructions; a separately authorised exercise with a fictional deck is needed before claiming operational validation. Existing archives are not rewritten, and source denials, versions and event-day equivalence remain as ADR-0012 defines them.
