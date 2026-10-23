# Security policy

This is a personal collection of agent plugins and skills, not a managed service. The owner handles reports on a best-effort basis; there is no service level, bounty or guaranteed response time.

## Supported versions

Only the latest published version on `main` is supported, and fixes are not backported. Each plugin's version is in its `plugin.json`. See [updating an installed plugin](docs/installation.md#updating-an-installed-plugin) for how a published fix reaches an installation.

## Report a vulnerability

Use GitHub's private vulnerability reporting: open this repository's **Security** tab and choose **Report a vulnerability**, or go to <https://github.com/andrewallen/skills/security/advisories/new>.

- Do not report a vulnerability in a public issue or pull request.
- If private reporting is unavailable, open a public issue that asks for a private channel and does not describe the vulnerability.
- Use synthetic or redacted examples. Do not include real workspace content, credentials, tokens or private information about people or organisations.
- If you find a secret or private data committed here, say where it is without reproducing it.
- Allow time for assessment and a fix before disclosing details publicly.

## In scope

- The PowerShell helpers under `plugins/` and the checks under `scripts/`, where they could write, delete or run something unintended, or bypass their preview and approval steps.
- Skill instructions, references and templates that could lead an agent to an unsafe action, expose sensitive information or cross a stated approval boundary.
- Plugin manifests and the marketplace catalogue, where a change could redirect an installation to unintended content.
- Credentials, private data or other sensitive material committed to this repository.

## Out of scope

- A user's own workspace, action ledger or project content. The plugins act only on targets that the user supplies, and this repository holds none.
- The GitHub platform, Copilot clients, MCP servers (including WorkIQ) and other third-party tools or services used with these plugins. Report those to their owners.
