# ADR-0024: Prefer non-interactive retrieval before browser fallbacks

- Status: Accepted
- Date: 2026-10-23

## Context

[ADR-0023](0023-recover-meeting-evidence-retrieval-through-authorised-routes.md) established automatic recovery from tool and transport limits but placed browser downloads before configured file-scoped APIs/CLIs. The owner explicitly directed that browser and computer use be last resorts because they interfere with the user. Launching a download URL from the shell can also take focus and is not a non-interactive transfer.

## Decision

This decision supersedes ADR-0023, retains its capture and access boundaries, and supplements [ADR-0012](0012-local-first-meeting-evidence-capture.md) and [ADR-0017](0017-use-direct-filesystem-operations.md).

- Continue through available authorised alternatives in the same run without a generic reprompt. A wrapper size/output cap or a credential mismatch is a route failure, not a source denial.
- Discover available source-specific tools, including mail attachment and SharePoint/OneDrive tools, through the client's configured on-demand registry where available. Inspect their actual schemas and limits. Loading an already-authorised toolset is distinct from installing a server, changing persistent configuration or acquiring access.
- Use the first route that returns and verifies the exact original, in this order: a provider download tool; a self-authorising returned URL transferred by a filesystem/shell HTTP client; an already configured file-scoped API or CLI; the returned URL opened in the signed-in default browser; then browser automation. Exhaust applicable non-interactive routes, or record a concrete failure/capability reason for each, before either browser route. Never repeat a known capped or unsuitable route merely to demonstrate failure.
- Browser Use and Computer Use are last resorts for the web download only, never basic local file operations. Prefer browser-specific tooling for browser-only work and background-safe interaction where supported. Yield to active user input; never force focus or use shell workarounds to evade an automation tool's interruption or refusal. Defer a source blocked by user activity and continue independent work.
- The capture request permits a last-resort browser download only within the approved occurrence and storage boundary. Launch only an exact `https` download URL returned in the provider's own metadata for that item on its own service host, never a URL taken from message, chat, transcript or document content. Move only the new file into the archive without overwriting. Host/tool approvals still apply. Do not sign in, switch accounts, request access, change sharing or edit sources by implication.
- Ask once for genuinely missing authority or approval as soon as its necessity is established after authorised alternatives, naming the affected sources. Do not ask whether to try an already-permitted route.
- Stop on a confirmed source denial from an authenticated file-scoped tool for the exact item or the user's signed-in session; do not open a browser merely to reconfirm that denial. Retain an already downloaded protection-wrapped file as-is, never decrypt it.
- Verify size, container integrity and provider hash where exposed and supported, record attempted routes and outcomes, preserve version limitations and distinguish local retention from semantic review. Preserve the no-overwrite, credential-handling and scope safeguards in ADR-0023. A successful transfer does not establish event-day equivalence.
- No MCP server, SDK, third-party component, permission grant or credential is bundled or installed. Tool selection and consent remain with the user and their tenant.

## Consequences

The skill can use dedicated provider alternatives without waiting to be prompted and does not interrupt the user while a suitable non-interactive route remains. An extra metadata/search tool does not necessarily transport large originals: the capability and size checks still apply.

Browser downloads remain possible when non-interactive routes are exhausted, with the focus, tab, history and synced-download side effects described in ADR-0023. If the browser is unavailable or user activity prevents safe interaction, the source remains an explicit gap rather than provoking a foreground workaround.

This changes route preference, not existing archive contents or source permissions. It requires no workspace migration. Static repository checks and an instruction trace do not prove live agent behaviour; end-to-end retrieval and installation/new-session checks remain separate validation gaps.
