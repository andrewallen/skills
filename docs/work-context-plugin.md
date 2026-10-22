# Work Context

**Keep project evidence and context usable.**

[Collection](../README.md#explore-the-plugins) | [Workflow walkthroughs](workflows.md) | [Installation](installation.md)

Work Context bundles three independently usable skills for the material around a project: where it belongs, what happened in meetings, and what the evidence says about relevant people and organisations. It is not a task system or a requirement for ordinary reading, drafting and editing.

## Skills

### Workspace Governance

Use this when a project needs a consistent folder structure, a structural assessment or repair, clearer routing, duplicate review or registration of an issued output.

**Reads:** an explicitly supplied workspace and its existing controls. **Produces:** the authorised structure or control updates, or a proposal for changes that need approval.

Example request:

> Use Workspace Governance to assess `C:\Work\ExampleProject`. Explain structural gaps and ambiguous routing. Do not move, rename or delete anything.

Assessment reports recommendations. Initialisation is a separate request; reorganisation of established material needs approval. This skill does not collect meetings or create stakeholder profiles.

[Read the skill](../plugins/work-context/skills/workspace-governance/SKILL.md) | [Common Architecture](../plugins/work-context/Common%20Architecture.md) | [Templates](../plugins/work-context/skills/workspace-governance/assets)

### Meetings Governance

Use this to capture named meetings, refresh new or changed evidence, establish an archive over an agreed range, or repair incomplete records.

**Reads:** resolved meeting occurrences and their in-scope sources. **Produces:** locally retained evidence where possible, an anchored context per occurrence, and meeting controls and index updates.

Example request:

> Use Meetings Governance to capture the supplied Example Project meeting in `C:\Work\ExampleProject`. Preserve the source material and create an anchored context. Report what was retrieved, reviewed and retained, including anything that could not be captured locally.

The context helps you locate topics, attributed points and historical follow-ups; it does not replace primary evidence or establish current action ownership. When local saving fails, authorised online review may inform synthesis, but remains explicitly distinct from local retention.

[Read the skill](../plugins/work-context/skills/meetings-governance/SKILL.md) | [Capture rules](../plugins/work-context/skills/meetings-governance/references/capture.md) | [Context template](../plugins/work-context/skills/meetings-governance/assets/context-record.md)

### Stakeholder Governance

Use this to create or refresh evidence-backed profiles of relevant people and organisations, or review a draft against their recorded positions.

**Reads:** supplied evidence, existing profiles and relevant primary passages linked from an archive when one exists. **Produces:** supported profile updates or an explicit evidence gap, with attribution, dates and source links.

Example request:

> Use Stakeholder Governance to refresh only the Example Partner organisation profile from the supplied new evidence. Preserve prior dated positions and disagreements. Do not infer endorsement or collect meeting evidence.

A meeting archive is not a prerequisite. Missing meeting collection is a bounded gap or an explicitly authorised handoff, not permission to build another archive. A profile does not simulate personal or organisational approval.

[Read the skill](../plugins/work-context/skills/stakeholder-governance/SKILL.md) | [Source coverage rules](../plugins/work-context/skills/stakeholder-governance/references/sources.md) | [Profile templates](../plugins/work-context/skills/stakeholder-governance/assets)

## Prerequisites and limits

The client must support skills and provide filesystem access for workspace operations. Remote capture or research also needs suitable authorised retrieval tools supplied by the client; this plugin does not bundle them or grant access.

Always supply the target. The repository and installed plugin directory are not project workspaces. No parent folder name is required, and the skills can operate independently without a bootstrap run from another skill.

New common workspaces use `99 Archive`; legacy structures and existing evidence are preserved unless an appropriate update or migration is explicitly approved. Owner notes and historical provenance must not be silently rewritten.

The documented installation path is Copilot CLI. Portable packaging is not proof that every operation works in every client.

## Install and start

Follow [GitHub installation](../README.md#github-installation-with-copilot-cli) or the [local installation guide](installation.md#local-installation), selecting `work-context`. A structural assessment of an explicitly named workspace is a useful read-only first request.

## Source and design

The [plugin manifest](../plugins/work-context/plugin.json) and each skill's metadata are the version sources. The [current architecture](architecture.md) explains ownership; the [meeting-context walkthrough](workflows.md#from-meeting-evidence-to-reusable-context) shows why the source and derived record remain distinct.
