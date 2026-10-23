# Installation and updates

[Collection](../README.md) | [Work Context](work-context-plugin.md) | [Work Actions](work-actions-plugin.md)

The documented client is GitHub Copilot CLI. The packages use Agent Plugins 1.0, but packaging portability does not establish equivalent behaviour or tool availability in every client. These commands are instructions, not actions performed by opening this repository.

## Before installing

Choose the plugin for the work you want to do. Work Context provides three workspace/evidence skills; Work Actions provides Action Ledger and manual helpers. Neither requires the other.

Work Context needs direct filesystem or shell access for workspace operations and suitable authorised client tools for remote retrieval. The current package documents Windows path conventions; Linux and macOS runtime behaviour is not verified. Basic file operations do not use Computer Use. Its optional ordinary-local-file migration helper additionally requires PowerShell 7.2+, but not `gh`; it previews by default and does not migrate directories or cloud storage. Folder operations do not require this helper.

Work Actions needs approved GitHub access; its helpers additionally require PowerShell 7.2+ and authenticated `gh` for github.com, plus an explicitly named, configured ledger checkout. The current action-ledger pilot's capture flow also requires its configured GitHub Project and appropriate permissions.

Installation does not supply credentials, adopt a ledger policy, grant access, run a helper or authorise a workspace migration.

## Dependencies by operation

| Operation | Required client capability or dependency |
|---|---|
| Local workspace assessment, folder operations, reading supplied evidence and writing controls/profiles | Direct filesystem tools or shell access, plus any local readers for the document formats in scope. No MCP server is required for local-only work; Computer Use is not a substitute. Content that cannot be read is reported as a gap, not skipped. |
| Meetings Governance: live Microsoft 365 calendar/meeting discovery and retrieval of Teams transcripts/chats, tied Outlook email and shared resources | **WorkIQ MCP**, or equivalent authorised Microsoft 365 tools exposing the required sources and exact reads. The signed-in account must have access to the requested records. |
| Stakeholder Governance: separately authorised live Microsoft 365 email, Teams, directory, SharePoint or OneDrive research for a stated question | **WorkIQ MCP**, or equivalent authorised tools for the scoped sources. Not part of ordinary profile creation or refresh, which use the project's own files; this does not authorise parallel meeting capture. |
| Workspace migration requiring cloud identity, history or shared-link guarantees beyond supported filesystem operations | An authorised provider tool/API supporting the specific move and preservation requirements. Do not assume WorkIQ search/read access includes cloud move capabilities. |
| Workspace Governance's optional independent-local-file helper | PowerShell 7.2+; no `gh`. Not required for ordinary folder operations. |
| Action Ledger and its bundled helpers | Approved GitHub access; PowerShell 7.2+ and authenticated `gh` for the helpers, plus the explicitly configured ledger and any required GitHub Project permissions. |
| Supplementary public-source research | Authorised web search/fetch tools when that research is requested; no private source data sent to public services. |

Configure WorkIQ MCP or other source tools separately in the client and authenticate through its supported setup. This repository does not bundle MCP servers, install them, supply credentials or grant tenant permissions. A listed skill or connected server does not prove that a particular transcript, attachment, full history or download is available.

Before remote work, check the available tools and their source-specific capabilities. Search summaries alone are not exact source retrieval. If a required capability or permission is missing, name the affected source and limitation, continue independent authorised local work, and report partial coverage. Do not claim `none found` or full capture when access was unavailable.

## GitHub installation

Use the [marketplace registration and plugin commands in the README](../README.md#github-installation-with-copilot-cli). Register once, then install only the plugin or plugins you want.

Start a new session. Check `/skills list` for `workspace-governance`, `meetings-governance` and `stakeholder-governance` if you installed Work Context, or `action-ledger` if you installed Work Actions.

For a read-only first request, use the workspace assessment in the [Work Context overview](work-context-plugin.md#workspace-governance) or the ledger review in the [Work Actions overview](work-actions-plugin.md#action-ledger). Replace example targets with an explicit target you are authorised to access.

If a skill is absent, check `copilot plugin list` and the installed plugin identity before trying an operation. A listed skill does not prove remote-source access or successful execution.

## Local installation

From this repository's root, install either package directly:

```powershell
copilot plugin install ".\plugins\work-context"
copilot plugin install ".\plugins\work-actions"
```

Alternatively, register the checkout as a local marketplace:

```powershell
copilot plugin marketplace add "."
copilot plugin install work-context@andrewallen-personal-skills
copilot plugin install work-actions@andrewallen-personal-skills
```

Choose one installation route to avoid loading duplicate copies. Path-sourced plugins in a local directory marketplace load from that directory; restart or start a new session after edits. For other sources, use the client's plugin update command.

The installed package is not the target. Supply a separate project workspace or an approved ledger repository when using a skill.

## Updating an installed plugin

For a GitHub marketplace installation, refresh the catalogue and update the plugins you have installed:

```powershell
copilot plugin marketplace update andrewallen-personal-skills
copilot plugin update work-context
copilot plugin update work-actions
copilot plugin list
```

Omit the update command for a plugin you have not installed. Start a new session and check the installed version and affected behaviour.

Marketplace installations retrieve the tracked ref, normally `main`, not unpublished feature-branch changes. A custom marketplace does not automatically enable client-side auto-updates. See [Governance](../GOVERNANCE.md#publishing-and-updates) for publication and post-merge installation checks.

Plugin versions live in the [Work Context manifest](../plugins/work-context/plugin.json) and [Work Actions manifest](../plugins/work-actions/plugin.json). Skill versions are in their own metadata; governed-file template versions are separate. Updating any of them does not authorise changing existing user files.

## Older installation names

If Work Context was previously installed as `workspace-governance`, install `work-context` and uninstall the old plugin before starting a new session. The individual skill names are unchanged.

If Work Actions was installed from an earlier marketplace, uninstall that installation before installing `work-actions@andrewallen-personal-skills`; `copilot plugin list` shows what is installed. The plugin's source moved; ledger records do not need migration.

These are deliberate local configuration changes, not automatic cleanup performed by this repository.

## Existing workspaces

New common workspaces use `99 Archive`. The correction was introduced in Work Context 1.0.1 with Workspace Governance 2.2 and Common Architecture 1.2; those are historical introduction versions, not the current package version.

Legacy folder structures, record identities, source evidence and provenance are preserved unless an appropriate change is explicitly approved. Ordinary reading, reasoning, drafting and editing do not require a governance skill.

The current baseline and approved physical migration are defined by [ADR-0020](adr/0020-deploy-stable-versioned-workspace-signposts.md) and [ADR-0017](adr/0017-use-direct-filesystem-operations.md). Legacy evidence remains readable, but legacy folder locations are not permanent compliant writing destinations. A simple migration needs an approved before/after mapping, not a mandatory helper plan file; do not rename folders just because the package version changed.

Repository consistency and parser checks do not establish helper execution, client compatibility or shared-link preservation. Verify those separately through an authorised exercise before claiming operational validation.
