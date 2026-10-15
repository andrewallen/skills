# ADR-0002: Package skills as an Agent Plugins 1.0 plugin with a Copilot marketplace

- Status: Accepted
- Date: 2026-10-14

## Context

Three related skills need to be installed together and updated as one unit. The repository was originally a single skill and was renamed to `work-context` (commit `216db5a`).

## Decision

- Ship one plugin, `plugins/work-context`, with a portable `plugin.json` at its root.
- Discover skills only from immediate children of `skills` that contain `SKILL.md`; do not add configurable skill paths.
- Keep references and templates inside the package.
- Distribute through a Copilot CLI marketplace at `.github/plugin/marketplace.json`, which points at the plugin's relative source and does not pin versions.
- Include no MCP servers, hooks or executable components.

## Consequences

Installation is a single command, and the plugin stays portable across clients. Reinstalling is required after local edits to a cached installation. Users of the earlier `workspace-governance` plugin must uninstall it to avoid duplicate skills.
