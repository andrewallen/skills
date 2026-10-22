# Andrew Allen's agent skills

**Practical agent skills, built in the flow of work.**

I'm Andrew Allen. This is my evolving collection of plugins, skills and supporting resources for the workflows I am building around my own work: keeping project material usable, preserving meeting context, and coordinating actions between people and agents.

If you arrived here from a talk or presentation, start with a workflow. You can see the problem it addresses, an example request, the intended result and the boundaries that keep it useful. Then follow the links into the skill itself and the decisions behind it.

**[Explore the plugins](#explore-the-plugins) | [See the workflows](docs/workflows.md) | [How I build them](docs/how-i-build.md) | [Installation](#github-installation-with-copilot-cli)**

## Explore the plugins

### Work Context

**Keep project evidence and context usable.** Organise a workspace, capture meeting evidence and maintain evidence-backed profiles of relevant people and organisations.

- [Workspace Governance](docs/work-context-plugin.md#workspace-governance): initialise the seven-folder baseline, assess unfamiliar projects and plan approved physical migration.
- [Meetings Governance](docs/work-context-plugin.md#meetings-governance): turn meeting sources into retained evidence and an anchored context you can revisit.
- [Stakeholder Governance](docs/work-context-plugin.md#stakeholder-governance): refresh profiles from dated, attributed evidence rather than assumptions.

[Explore Work Context](docs/work-context-plugin.md) | [Inspect its skills](plugins/work-context/skills)

### Work Actions

**Coordinate actions between people and agents.** Keep capture, clarification, execution, review and human acceptance on one GitHub issue ledger.

- [Action Ledger](docs/work-actions-plugin.md#action-ledger): make the next action, human accountability, execution boundary and handoff explicit.

[Explore Work Actions](docs/work-actions-plugin.md) | [Inspect the skill](plugins/work-actions/skills/action-ledger/SKILL.md)

The plugins are separate installation units; choose either or both. They do not automatically run one another.

## See a workflow before reading the instructions

- [From meeting evidence to reusable context](docs/workflows.md#from-meeting-evidence-to-reusable-context): find the source behind a point without rereading every transcript.
- [From new evidence to an updated stakeholder profile](docs/workflows.md#from-new-evidence-to-an-updated-stakeholder-profile): update what changed without rebuilding the archive.
- [From a captured action to a human-agent handoff](docs/workflows.md#from-a-captured-action-to-a-human-agent-handoff): separate recording work, authorising execution and accepting the result.

These are fictional illustrations of the intended workflows, not customer records, live execution results or performance claims.

For existing projects, start with the [migration workflow](docs/workflows.md#from-an-existing-project-to-the-standard-structure). It produces an approval-ready plan before moves; installing or updating the plugin does not migrate anything. The public package contains no real project evidence.

## What is in this collection?

A **plugin** is an installable bundle. A **skill** describes when an agent should help, what it can do and where it must stop. **References** hold detailed procedures; **templates** describe the records a skill creates.

The human overviews live in [the documentation](docs/README.md). The actual agent instructions, references and templates live under [plugins](plugins). This repository packages those resources; your project workspace or action ledger is a separate, explicitly supplied target.

This is a personal, evolving collection, not a promise of universal client compatibility or a managed service. The overviews explain prerequisites and limitations; the skill definitions are the source for current behaviour.

## GitHub installation with Copilot CLI

Register the marketplace once:

```powershell
copilot plugin marketplace add andrewallen/skills
```

Install either plugin, or both:

```powershell
copilot plugin install work-context@andrewallen-personal-skills
copilot plugin install work-actions@andrewallen-personal-skills
```

Start a new session and check `/skills list`. Installation provides instructions and bundled resources, not credentials, source access or permission to act.

Read the [installation guide](docs/installation.md) for prerequisites, a safe first request, older installation names and compatibility limits.

## Local installation with Copilot CLI

For a checkout-based installation, use the [local installation instructions](docs/installation.md#local-installation). The installed plugin directory is never the target workspace.

## Updating an installed plugin

Follow the [update instructions](docs/installation.md#updating-an-installed-plugin). Marketplace installations normally retrieve `main`, not unpublished work on a feature branch. An update is not permission to migrate existing workspace content.

## Behind the skills

[How I build these workflows](docs/how-i-build.md) explains the approach. For the technical detail, use the [maintainer reading path](docs/README.md#maintaining-and-extending): governance, architecture, skill authoring, validation and ADRs.

The repo is the primary place to explore the collection; there is no separate documentation site.

## Licensing

No reuse licence is configured. Public visibility does not grant general permission to copy, adapt or redistribute the content. See the [current licensing decision](docs/adr/0004-licence-not-yet-chosen.md).
