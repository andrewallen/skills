# Work Context

**Keep project evidence and context usable.**

[Collection](../README.md#explore-the-plugins) | [Workflow walkthroughs](workflows.md) | [Installation](installation.md)

Work Context bundles three independently usable skills for the material around a project: where it belongs, what happened in meetings, and what the evidence says about relevant people and organisations. It is not a task system or a requirement for ordinary reading, drafting and editing.

## Skills

### Workspace Governance

Use this when a project needs the common seven-folder structure, an assessment or repair, an approved physical migration, clearer routing, duplicate review or registration of an issued output.

**Reads:** an explicitly supplied workspace and its existing controls. **Produces:** the authorised structure or control updates, or a proposal for changes that need approval.

Example request:

> Use Workspace Governance to assess `C:\Work\ExampleProject`. Explain structural gaps and ambiguous routing. Do not move, rename or delete anything.

Assessment reports recommendations. Initialisation is a separate request; reorganisation of established material needs approval. This skill does not collect meetings or create stakeholder profiles.

### Common project structure

```text
00 Start Here
10 Issued Outputs
20 Working
30 Sources
40 Meetings
50 Stakeholders
99 Archive
```

All seven roots are present after full initialisation or migration. Supplementary folders are unnumbered, short and purposeful. Keep useful collections within their appropriate home; avoid automatic year, audience or format nesting. Meeting recordings stay with their occurrence; other media follows its purpose.

Use Start Here for orientation, meeting contexts and profiles to locate relevant material, and primary passages to ground material claims. Directly shared documents should communicate their own purpose, status, date and provenance. Source placement is not a truth guarantee; AI assistance is not approval.

### Migrate an existing project

> Use Workspace Governance to assess `C:\Projects\Example` and prepare a migration plan into the standard structure. Account for every scoped item, shared-link risks and references. Do not move anything until I approve the plan.

The destination is a consistent physical layout, not a permanent map of old folders. Approved migration preserves meaningful collections, evidence and identities, records progress and can resume. Unresolved content or legacy roots means partial migration, not compliance.

All three skills use direct filesystem tools or shell commands for basic file operations, never Computer Use or Explorer automation. For a simple reorganisation, approve a short before/after mapping once. Prefer a folder rename/move; when needed, create destinations, move contents without overwriting, verify and remove only approved old folders confirmed empty, including hidden entries.

The optional [local helper](../plugins/work-context/skills/workspace-governance/references/migration.md#local-helper-boundary) requires PowerShell 7.2+ and handles independent ordinary-local-file batches only; it is not required for folder operations. A OneDrive path alone does not require a different tool. Use an authorised provider API/tool only where filesystem operations cannot meet provider or preservation requirements. Neither hydration, a local move nor static checks prove preservation of cloud identity, history or shared links.

[Read the skill](../plugins/work-context/skills/workspace-governance/SKILL.md) | [Common Architecture](../plugins/work-context/Common%20Architecture.md) | [Templates](../plugins/work-context/skills/workspace-governance/assets)

### Meetings Governance

Use this to capture named meetings, refresh new or changed evidence, establish an archive over an agreed range, or repair incomplete records.

**Reads:** resolved meeting occurrences and their in-scope sources. **Produces:** locally retained evidence where possible, an anchored context per occurrence, and meeting controls and index updates.

Example request:

> Use Meetings Governance to capture the supplied Example Project meeting in `C:\Work\ExampleProject`. Preserve the source material and create an anchored context. Report what was retrieved, reviewed and retained, including anything that could not be captured locally.

The context helps you locate topics, attributed points and historical follow-ups; it does not replace primary evidence or establish current action ownership. When local saving fails, authorised online review may inform synthesis, but remains explicitly distinct from local retention.

[Read the skill](../plugins/work-context/skills/meetings-governance/SKILL.md) | [Capture rules](../plugins/work-context/skills/meetings-governance/references/capture.md) | [Context template](../plugins/work-context/skills/meetings-governance/assets/context-record.md)

### Stakeholder Governance

Use this to create or refresh evidence-backed profiles of relevant people and organisations from the project's own files, or review a draft against their recorded positions. Microsoft and Microsoft employees are not profiled.

**Reads:** the project's own files, including the relevant content of documents and presentations, existing profiles and relevant primary passages linked from an archive when one exists. **Produces:** supported profile updates, compact provisional profiles where evidence is thin, or an explicit evidence gap, with attribution, dates and source links.

Example request:

> Use Stakeholder Governance to refresh only the Example Partner organisation profile from the supplied new evidence. Preserve prior dated positions and disagreements. Do not infer endorsement or collect meeting evidence.

A meeting archive is not a prerequisite. Missing meeting collection is a bounded gap or an explicitly authorised handoff, not permission to build another archive. A profile does not simulate personal or organisational approval.

A profile review is not described as complete while relevant available content remains unread; unread or inaccessible sources are named. Live Microsoft 365, directory or public research happens only when you separately authorise it for a stated question.

[Read the skill](../plugins/work-context/skills/stakeholder-governance/SKILL.md) | [Source coverage rules](../plugins/work-context/skills/stakeholder-governance/references/sources.md) | [Profile templates](../plugins/work-context/skills/stakeholder-governance/assets)

## Prerequisites and limits

The client must support skills and provide direct filesystem or shell access for workspace operations. Live Microsoft 365 capture, or research you have separately authorised, needs **WorkIQ MCP**, or equivalent authorised tools for the required Outlook, Teams, directory, SharePoint and OneDrive sources. Local-only work with the project's own files does not require WorkIQ.

The client supplies and authenticates those tools separately; this plugin does not bundle MCP servers or grant source access. Check exact reads, pagination and download capabilities for the requested operation rather than assuming that search access supplies them. Missing capabilities are explicit coverage gaps, not empty search results. See [dependencies by operation](installation.md#dependencies-by-operation).

Always supply the target. The repository and installed plugin directory are not project workspaces. No parent folder name is required, and the skills can operate independently without a bootstrap run from another skill.

Legacy evidence can be read without migration. New governed writes use the baseline; writing into a legacy alternative requires an approved transition first. An update alone never authorises moving existing content. Owner notes and historical provenance must not be silently rewritten.

Documentation examples are fictional. Supply real paths and source identities only in your authorised target; do not contribute project evidence, employer/customer proprietary material or private links to this public repository.

The documented installation path is Copilot CLI. Portable packaging is not proof that every operation works in every client.

## Install and start

Follow [GitHub installation](../README.md#github-installation-with-copilot-cli) or the [local installation guide](installation.md#local-installation), selecting `work-context`. A structural assessment of an explicitly named workspace is a useful read-only first request.

## Source and design

The [plugin manifest](../plugins/work-context/plugin.json) and each skill's metadata are the version sources. The [current architecture](architecture.md) explains ownership; the [meeting-context walkthrough](workflows.md#from-meeting-evidence-to-reusable-context) shows why the source and derived record remain distinct.
