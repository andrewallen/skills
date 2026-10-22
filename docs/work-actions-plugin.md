# Work Actions

**Coordinate actions between people and agents.**

[Collection](../README.md#explore-the-plugins) | [Workflow walkthrough](workflows.md#from-a-captured-action-to-a-human-agent-handoff) | [Installation](installation.md)

Work Actions keeps an action's next step, human accountability, execution boundary and review on one GitHub issue. It packages the `action-ledger` skill and manually invoked helpers, not an automatic agent dispatcher or a replacement for an application backlog.

## Skills

### Action Ledger

Use this to capture or clarify an action, review what needs attention, execute a specifically delegated action, or leave a bounded handoff for another person or agent.

**Reads:** an explicitly named GitHub issue ledger, its approved operating contract and the relevant issue history. **Produces:** authorised issue updates and evidence-backed handoffs on the same issue, or an explicit block.

Example request:

> Use Action Ledger to review the open actions in `<owner>/<ledger>`. Surface deadlines, decisions and dependencies, and identify what needs clarification. Do not start executions, close issues or change labels.

Recording an action does not authorise its execution. A finished draft or pull request does not establish human acceptance. The same issue carries the work across handoffs; a second task list is not created.

[Read the skill](../plugins/work-actions/skills/action-ledger/SKILL.md) | [Operating contract](../plugins/work-actions/skills/action-ledger/references/operating-contract.md) | [Attention and review rules](../plugins/work-actions/skills/action-ledger/references/attention-and-refresh.md) | [Templates](../plugins/work-actions/skills/action-ledger/assets)

## Prerequisites and limits

The client needs approved GitHub access. Bundled helpers additionally require PowerShell 7.2+ and authenticated `gh` for github.com. The target ledger must have its own approved configuration and operating policy; installation does not adopt that policy on another repository's behalf.

The current pilot requires its configured GitHub Project for the capture flow. Project access and permissions are prerequisites, not something the plugin supplies. Missing authority or a conflicting execution blocks the affected operation.

This repository is the canonical plugin source ([ADR-0011](adr/0011-maintain-work-actions-plugin-here.md)). An operational ledger keeps its own configuration, Project identifiers, records and policy outside this repository.

## Install and start

Follow [GitHub installation](../README.md#github-installation-with-copilot-cli) or the [local installation guide](installation.md#local-installation), selecting `work-actions`. Start with the read-only review request above against a ledger you are authorised to access.

If installed as `work-actions@anallen-work-actions`, uninstall that older installation before installing `work-actions@andrewallen-personal-skills` to avoid duplicate skills. See [older installation names](installation.md#older-installation-names).

## Source and design

The [plugin manifest](../plugins/work-actions/plugin.json) and [skill metadata](../plugins/work-actions/skills/action-ledger/SKILL.md) are the version sources. The [handoff walkthrough](workflows.md#from-a-captured-action-to-a-human-agent-handoff) illustrates the separation between capture, delegation and acceptance.

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

Use the [shared installation and update guide](installation.md). These are instructions; repository changes install nothing.

## Pinning for a ledger

A ledger may vendor only `plugins/work-actions/skills/action-ledger/scripts/*` at an immutable commit of this repository, preserving the relative `skills/action-ledger/scripts` depth (the module resolves its package boundary three directories up) and recording commit and file hashes. Scripts are kept LF by `.gitattributes`.

## Versions

Read the [plugin manifest](../plugins/work-actions/plugin.json) and [skill metadata](../plugins/work-actions/skills/action-ledger/SKILL.md) for current versions. Existing ledger records are not migrated by installing or updating the plugin.

## Validation

```powershell
pwsh -NoProfile -File .\scripts\test-work-actions-plugin.ps1
pwsh -NoProfile -File .\scripts\validate-repository.ps1
```

The first copies the package alone, fakes `gh`, and checks target safety, preview-by-default, idempotence, no file mutation and honest failures against synthetic fixtures in `scripts\fixtures\work-actions`. It does not prove client discovery, installation, live GitHub behaviour or Project permissions.
