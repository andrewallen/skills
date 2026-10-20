# Work Context

This repository packages personal agent plugins as Agent Plugins 1.0 packages, distributed through a GitHub Copilot CLI marketplace: `work-context` (three workspace governance skills, below) and `work-actions` (the action-ledger skill and manual helpers; see [Work Actions plugin](docs/work-actions-plugin.md)).

## Documentation

For repository maintenance and skill authoring, read in this order:

| Read | Purpose |
|---|---|
| [Governance](GOVERNANCE.md) | Change authority, versioning, compatibility and publication rules. |
| [Current architecture](docs/architecture.md) | Package boundaries, skill ownership and how information is shared today. |
| [Skill authoring](docs/skill-authoring.md) | Decide what to extend, define boundaries and check completion. |
| [Validation](docs/validation.md) | Run repeatable repository checks and identify what still needs manual review. |
| [ADR index](docs/adr/README.md) | Accepted decisions and proposals; Proposed does not mean implemented. |

The [current information model inventory](docs/current-information-model.md) maps today's terms, records, relationships and unresolved definitions. It is descriptive, not an accepted shared-model specification.

## Layout

```text
.github\plugin\marketplace.json
plugins
├── work-actions
│   ├── plugin.json
│   └── skills
│       └── action-ledger
└── work-context
    ├── plugin.json
    ├── Common Architecture.md
    └── skills
        ├── workspace-governance
        ├── meetings-governance
        └── stakeholder-governance
```

The portable manifest lives at the plugin root. Clients discover each skill from an immediate child of `skills` containing `SKILL.md`. References and templates stay inside the package. There are no bundled MCP servers, hooks or executable components.

The marketplace is a Copilot-specific distribution catalogue, separate from the portable plugin specification. Its source points to `plugins/work-context`, relative to the repository root.

## Included skills

| Skill | Use |
|---|---|
| `workspace-governance` | Create or repair the common workspace, route material, review duplicates and register issued outputs. |
| `meetings-governance` | Capture named meetings or refresh new and changed meeting evidence. |
| `stakeholder-governance` | Create or refresh evidence-backed profiles of relevant people and organisations. |

The skills operate on the target workspace supplied by the user, not on this repository or the installed plugin directory. No parent folder name is required: `Active Work` and `Current Matters` are optional personal organisational choices, not assumptions made by the skills. They can operate independently. Ordinary reading, reasoning, drafting and editing do not require these governance skills.

## GitHub installation with Copilot CLI

```powershell
copilot plugin marketplace add andrewallen/skills
copilot plugin install work-context@andrewallen-personal-skills
```

## Local installation with Copilot CLI

From this repository's root, install the package directly:

```powershell
copilot plugin install ".\plugins\work-context"
```

Or register this repository as a local marketplace and install from it:

```powershell
copilot plugin marketplace add "."
copilot plugin install work-context@andrewallen-personal-skills
```

These commands change your local plugin configuration; they are instructions, not actions performed by repository setup. After installation, start a new session and check `/skills list` for the three skills.

If you previously installed the plugin as `workspace-governance`, install `work-context` and uninstall the old plugin before starting a new session to avoid loading duplicate skills. The individual skill names have not changed.

## Updating an installed plugin

For a GitHub marketplace installation:

```powershell
copilot plugin marketplace update andrewallen-personal-skills
copilot plugin update work-context
copilot plugin list
```

Start a new session and check the installed version and changed behaviour. These commands retrieve the ref the marketplace tracks, normally `main`, not an unpublished feature branch. A custom marketplace does not automatically enable client-side auto-updates.

Path-sourced plugins in a local directory marketplace load from that directory; restart or start a new session after edits. For other installation sources, use the client's plugin update command.

The archive-folder correction is packaged as `work-context` 1.0.1, with Workspace Governance 2.2 and Common Architecture 1.2. Newly initialised workspaces use `99 Archive`; existing legacy structures are preserved unless a migration is explicitly approved.

## Maintenance

- Add future plugins under `plugins` and add their relative source to the marketplace.
- `work-actions` ([documentation](docs/work-actions-plugin.md)) is the second plugin; its helpers are the only executable components, are manual, and are covered by `scripts\test-work-actions-plugin.ps1`.
- Keep component discovery at the fixed `skills` location. Do not add configurable skill paths to `plugin.json`.
- Keep optional dependencies absent: these skills need filesystem access and, for remote evidence retrieval, suitable authorised tools supplied by the client.
- Update a skill's own metadata version when its behaviour changes. Update the plugin version when distributing an updated package. The marketplace does not pin duplicate version numbers.
- Keep governed-file template versions separate from skill and plugin versions.
- Follow [GOVERNANCE.md](GOVERNANCE.md) and record significant decisions in [docs/adr](docs/adr/README.md).
- Do not commit workspace evidence, customer documents, generated outputs, credentials or local caches here.

From the repository root, run the dependency-free checks with PowerShell 7:

```powershell
pwsh -NoProfile -File .\scripts\validate-repository.ps1
pwsh -NoProfile -File .\scripts\test-work-actions-plugin.ps1
git diff --check
``` scope and gaps](docs/validation.md) before treating these checks as review evidence.

No reuse license has been configured. Issued-output registration remains part of the existing workspace skill; packaging has not changed that policy.

## Format references

- [Agent Plugins specification](https://agent-plugins.org/specification)
- [Agent Skills specification](https://agentskills.io/specification)
- [Copilot CLI marketplace format](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
