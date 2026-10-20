# Current repository architecture

This is a description of the current package, not a new workspace architecture or an implementation of a Proposed ADR. [Governance](../GOVERNANCE.md) controls repository changes; [Common Architecture](../plugins/work-context/Common%20Architecture.md) defines the target workspace's structure, routing and ownership.

## Package boundaries

| Boundary | Current implementation |
|---|---|
| Repository | Installation instructions, contributor guidance, ADRs and validation tooling. It is not a workspace for the skills to govern. |
| Copilot marketplace | `.github/plugin/marketplace.json` names the catalogue and points to `./plugins/work-context`. It does not duplicate the plugin version. |
| Portable plugin | `plugins/work-context/plugin.json` is the package manifest and version source. Common Architecture, skills, references and assets are bundled inside this boundary. Repository docs and scripts are not plugin components. |
| Skill | Each immediate child of `plugins/work-context/skills` has a `SKILL.md`; its `references` and `assets` supply task-specific instructions and templates. No configurable skill path is declared. |
| Runtime and target | The client supplies filesystem access and suitable authorised retrieval tools. The user supplies the target workspace or collection; skills never derive it from their installed location. |

There are no bundled MCP servers, hooks, executables, search services or background synchronisation. See accepted [ADR-0002](adr/0002-package-skills-as-agent-plugin.md) for packaging and [README](../README.md#github-installation-with-copilot-cli) for installation.

## Ownership and standalone operation

All three skills declare the same Common Architecture version and no runtime dependency on another skill. Workspace Governance explicitly loads Common Architecture every run; the specialist skills direct readers to their own bundled references. Read those references as part of the behaviour, not just the skill entry point.

| Skill | Owns | Does not own |
|---|---|---|
| [Workspace Governance](../plugins/work-context/skills/workspace-governance/SKILL.md) | Fixed roots, Start Here, Issued Outputs Index, routing and duplicate review. | Meeting capture, stakeholder profiles or a task system. |
| [Meetings Governance](../plugins/work-context/skills/meetings-governance/SKILL.md) | Discovery, exact occurrence resolution, capture, contexts, Meetings Index and reconciliation. | Stakeholder analysis or unrelated workspace controls. |
| [Stakeholder Governance](../plugins/work-context/skills/stakeholder-governance/SKILL.md) | Canonical person and organisation profiles, optional research maps and evidence-based content review. | Meeting collection, a second archive, CRM or task management. |

Under accepted [ADR-0003](adr/0003-independent-skills-with-fixed-ownership.md), none requires the others to run first. Each resolves its own target, creates only its authorised items and has its own completion checks. A standalone stakeholder pass can use supplied sources without a meeting archive; missing meeting capture is a bounded gap or an authorised handoff, not permission to build an archive. Specialist initialisation does not bootstrap all workspace roots. Ordinary reading, reasoning, drafting and editing need no governance skill.

## Information sharing today

- **Shared rules:** Common Architecture defines folder roles, routing, information/lifecycle distinctions and generated-file provenance. It is not a complete shared vocabulary or schema.
- **Local definitions:** Meeting references define capture, occurrence identity and attribution; stakeholder references define source consumption, profile evidence and research coverage. Assets define the records each skill writes.
- **Consumption:** Stakeholder work uses meeting indexes and contexts to locate primary source passages, carrying their coverage and attribution limits into profiles. A profile does not corroborate a meeting, nor does a context corroborate its transcript. Workspace navigation and issued-output registration do not establish the truth of source claims.
- **Optional handoffs:** Existing archive files and the conversation carry exact source links, scope, changes and gaps. There is no required handoff registry or packet, automatic synchronisation or permission to run another skill. See the current [meeting handoff rules](../plugins/work-context/skills/meetings-governance/references/evidence-rules.md#1-ownership-and-handoff) and [stakeholder source rules](../plugins/work-context/skills/stakeholder-governance/references/sources.md).

The [current information model inventory](current-information-model.md) maps these scattered definitions and gaps. In particular, archive class, baseline impact and the full set of capture-state tokens are not centrally resolved. Do not fill those gaps with invented shared values or silently treat distinct classification axes as one status.

## Implemented decisions versus proposals

The [ADR index](adr/README.md) is the status source. Accepted ADRs document current packaging, ownership, versioning and archive naming; the inventory and this overview do not accept decisions.

| Proposed ADR | Not established by that proposal |
|---|---|
| [0005: Capture safeguards](adr/0005-safeguards-for-meeting-evidence-capture.md) | A change to the existing meeting capture instructions. The current retention rules and the proposed safeguards remain distinct. |
| [0008: Independent contracts](adr/0008-define-independent-skill-contracts.md) | A universal compatible-input contract or producer-neutral record guarantee across the current skills. |
| [0009: Shared information model](adr/0009-establish-a-shared-information-model.md) | A central model, newly controlled vocabularies, record schemas or workspace migrations. |
| [0010: Retrieval semantics](adr/0010-define-evidence-retrieval-semantics.md) | A consolidated shared retrieval reference, ranking algorithm or ingestion service. Some underlying rules already exist in specialist references. |

Implementation of a proposal needs explicit owner acceptance and a separately scoped, versioned change. This repository guidance adds no mandatory workspace roots, record fields or migrations.
