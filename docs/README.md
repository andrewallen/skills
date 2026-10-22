# Explore the collection

[Back to the collection](../README.md)

Start with the work you want to understand, not the file layout.

## Explore and use

- [Work Context](work-context-plugin.md): workspace structure, meeting evidence and profiles of people and organisations.
- [Work Actions](work-actions-plugin.md): a shared human-agent action ledger on GitHub issues.
- [Workflow walkthroughs](workflows.md): fictional requests and illustrative results, with the human boundaries made explicit.
- [How I build these workflows](how-i-build.md): the approach behind the collection and links to the decisions that shape it.
- [Installation and updates](installation.md): prerequisites, local installation, verification and compatibility.

Each plugin overview links to its skills, references and templates. Those packaged files define agent behaviour; the overviews explain it for people.

## Maintaining and extending

Read these in order when changing the repository:

1. [Governance](../GOVERNANCE.md): authority, versioning, compatibility and publication.
2. [Current architecture](architecture.md): package boundaries, skill ownership and information sharing.
3. [Skill authoring](skill-authoring.md): extend a skill, add one or establish a separate plugin.
4. [Validation](validation.md): repository checks, behavioural scenarios and known validation gaps.
5. [ADR index](adr/README.md): accepted decisions and proposals; Proposed does not mean implemented.

The [current information model inventory](current-information-model.md) describes existing terms, relationships and open definitions. The accepted [minimal shared evidence model](adr/0013-minimal-shared-evidence-model.md) provides conceptual consistency without a universal schema.

## Keep discovery useful as the collection grows

For a new plugin, add a human overview alongside these pages and link it from the root README and this index. Follow the existing overview structure: purpose, skills, example requests and results, prerequisites and limits, installation, and source links. Add a workflow illustration when it explains something the overview cannot.

Keep identifiers and installation names aligned with the manifests, and link to versions rather than copying them into catalogue prose. Do not invent maturity badges, compatibility guarantees or success stories. Examples must be fictional or safely anonymised documentation illustrations, never operational workspace evidence.

Repository-only documentation does not require a plugin version bump. Changes to packaged behaviour, references or templates do; follow Governance and review inherited behaviour as well as the entry point.

## Package layout

```text
.github\plugin\marketplace.json
plugins
|-- work-actions
|   |-- plugin.json
|   `-- skills\action-ledger
`-- work-context
    |-- plugin.json
    |-- Common Architecture.md
    `-- skills
        |-- workspace-governance
        |-- meetings-governance
        `-- stakeholder-governance
docs
|-- human overviews and walkthroughs
`-- adr
scripts
`-- repository and isolated helper checks
```

The [marketplace catalogue](../.github/plugin/marketplace.json) lists both plugins using repository-relative sources. It is a Copilot-specific discovery layer, separate from the portable Agent Plugins format. Each plugin's root manifest is its package-version source, and clients discover skills from immediate children of `skills` containing `SKILL.md`.

Work Context has no bundled executables. Work Actions includes manual, preview-by-default PowerShell helpers. Neither plugin bundles an MCP server or automatic dispatch.

## Format references

- [Agent Plugins specification](https://agent-plugins.org/specification)
- [Agent Skills specification](https://agentskills.io/specification)
- [Copilot CLI marketplace format](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
