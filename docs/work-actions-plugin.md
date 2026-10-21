# Work Actions plugin

`work-actions` packages the `action-ledger` skill: instructions and manually invoked helpers for a shared human-agent action ledger kept as GitHub issues. This repository is its canonical source ([ADR-0011](adr/0011-maintain-work-actions-plugin-here.md)). An operational ledger repository keeps its own configuration, Project, records and policy; none of that lives here.

## Layout

```text
plugins\work-actions
|-- plugin.json
`-- skills\action-ledger
    |-- SKILL.md
    |-- assets          action.md, project.md, execution-update.md
    |-- references      operating-contract.md, attention-and-refresh.md, helpers.md
    `-- scripts         WorkActions.psm1, Sync-ActionViews.ps1, Sync-ActionProject.ps1, Initialize-WorkActions.ps1
```

Copying only `plugins/work-actions` is sufficient; nothing reaches back into this repository. The skill never treats its installation directory as the target ledger.

## Helper contract

- PowerShell 7.2+ and an authenticated `gh` for github.com must already exist; nothing is installed or downloaded.
- Every entry point requires an absolute `-TargetPath` to a ledger checkout outside the plugin directory and `-Repository owner/name` matching the target's `.github/work-actions.json`. Mismatches fail before any GitHub request.
- Helpers preview by default; `-Apply` permits writes but supplies no authority. Failures are reported, not converted to success.
- Configuration and label definitions are inputs from the target ledger. Never copy another ledger's repository or Project identifiers.

## Install and update

```powershell
copilot plugin marketplace add andrewallen/skills
copilot plugin install work-actions@andrewallen-personal-skills
```

Update with `copilot plugin marketplace update andrewallen-personal-skills` then `copilot plugin update work-actions`. If the plugin was installed as `work-actions@anallen-work-actions`, uninstall it first to avoid duplicate skills. These are instructions; repository changes install nothing.

## Pinning for a ledger

A ledger may vendor only `plugins/work-actions/skills/action-ledger/scripts/*` at an immutable commit of this repository, preserving the relative `skills/action-ledger/scripts` depth (the module resolves its package boundary three directories up) and recording commit and file hashes. Scripts are kept LF by `.gitattributes`.

## Versions

Plugin version is in `plugin.json` (1.0.1: first release from this repository, author and helper-reference wording updated; scripts and skill behaviour unchanged from 1.0.0). Skill `metadata.version` is 1.0.

## Validation

```powershell
pwsh -NoProfile -File .\scripts\test-work-actions-plugin.ps1
pwsh -NoProfile -File .\scripts\validate-repository.ps1
```

The first copies the package alone, fakes `gh`, and checks target safety, preview-by-default, idempotence, no file mutation and honest failures against synthetic fixtures in `scripts\fixtures\work-actions`. It does not prove client discovery, installation, live GitHub behaviour or Project permissions.
