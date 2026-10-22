# Current repository architecture

This is a description of the current package, not a new workspace architecture or an implementation of a Proposed ADR. [Governance](../GOVERNANCE.md) controls repository changes; [Common Architecture](../plugins/work-context/Common%20Architecture.md) defines the target workspace's structure, routing and ownership.

For the human introduction, use the [collection and documentation map](README.md), [Work Context overview](work-context-plugin.md) or [Work Actions overview](work-actions-plugin.md). Those pages explain the package; they do not replace its skill instructions.

## Package boundaries

| Boundary | Current implementation |
|---|---|
| Repository | Installation instructions, contributor guidance, ADRs and validation tooling. It is not a workspace for the skills to govern. |
| Copilot marketplace | `.github/plugin/marketplace.json` names the catalogue and points to `./plugins/work-context`. It does not duplicate the plugin version. |
| Portable plugin | `plugins/work-context/plugin.json` is the package manifest and version source. Common Architecture, skills, references and assets are bundled inside this boundary. Repository docs and scripts are not plugin components. |
| Skill | Each immediate child of `plugins/work-context/skills` has a `SKILL.md`; its `references` and `assets` supply task-specific instructions and templates. No configurable skill path is declared. |
| Runtime and target | The client supplies filesystem access and suitable authorised retrieval tools. The user supplies the target workspace or collection; skills never derive it from their installed location. |

There are no bundled MCP servers, hooks, search services or background synchronisation in `work-context`. The separate `work-actions` plugin ([documentation](work-actions-plugin.md), [ADR-0011](adr/0011-maintain-work-actions-plugin-here.md)) bundles manual, preview-by-default PowerShell helpers and is otherwise outside this description of `work-context`. See accepted [ADR-0002](adr/0002-package-skills-as-agent-plugin.md) for packaging and [README](../README.md#github-installation-with-copilot-cli) for installation.

## Ownership and standalone operation

All three skills declare the same Common Architecture version and no runtime dependency on another skill. All three skills explicitly load Common Architecture every run; specialists also load their own bundled references. Read those references as part of the behaviour, not just the skill entry point.

| Skill | Owns | Does not own |
|---|---|---|
| [Workspace Governance](../plugins/work-context/skills/workspace-governance/SKILL.md) | Seven fixed roots, Start Here, Issued Outputs Index, routing, approved migration and duplicate review. | Meeting capture, stakeholder profiles or a task system. |
| [Meetings Governance](../plugins/work-context/skills/meetings-governance/SKILL.md) | Discovery, exact occurrence resolution, capture, contexts, Meetings Index and reconciliation. | Stakeholder analysis or unrelated workspace controls. |
| [Stakeholder Governance](../plugins/work-context/skills/stakeholder-governance/SKILL.md) | Canonical profiles of relevant people and organisations other than Microsoft and its employees, optional research maps and evidence-based content review. | Meeting collection, a second archive, CRM or task management. |

Under accepted [ADR-0003](adr/0003-independent-skills-with-fixed-ownership.md), none requires the others to run first. Each resolves its own target, creates only its authorised items and has its own completion checks. A standalone stakeholder pass can use supplied sources without a meeting archive; missing meeting capture is a bounded gap or an authorised handoff, not permission to build an archive. Specialist initialisation does not bootstrap all workspace roots. Ordinary reading, reasoning, drafting and editing need no governance skill.

## Information sharing today

- **Shared rules:** Common Architecture defines folder roles, routing, information/lifecycle distinctions and generated-file provenance. Accepted [ADR-0013](adr/0013-minimal-shared-evidence-model.md) adds a small repository-wide conceptual core for evidence identity, provenance, attribution, time, coverage and relationships; it does not impose a common schema.
- **Local definitions:** Meeting references define capture, occurrence identity and attribution; stakeholder references define source consumption, profile evidence and research coverage. Assets define the records each skill writes.
- **Consumption:** Stakeholder work reads the project's own documents for relevant content and uses meeting indexes and contexts to locate primary source passages, carrying their coverage and attribution limits into profiles. A profile does not corroborate a meeting, nor does a context corroborate its transcript. Workspace navigation and issued-output registration do not establish the truth of source claims. Accepted [ADR-0018](adr/0018-ground-stakeholder-profiles-in-project-evidence.md) keeps profiling within the project's files unless research is separately authorised.
- **Optional handoffs:** Existing archive files and the conversation carry exact source links, scope, changes and gaps. There is no required handoff registry or packet, automatic synchronisation or permission to run another skill. See the current [meeting handoff rules](../plugins/work-context/skills/meetings-governance/references/evidence-rules.md#1-ownership-and-handoff) and [stakeholder source rules](../plugins/work-context/skills/stakeholder-governance/references/sources.md).

The [current information model inventory](current-information-model.md) maps these scattered definitions and gaps. Meeting class and baseline-impact fields are not part of the current context template. Meeting contexts report retrieval, review and retention per source; they do not use an aggregate capture-status field. Archive inventory status remains a separate archive-level measure.

## Implemented decisions versus proposals

The [ADR index](adr/README.md) is the status source. Accepted ADRs document current packaging, ownership, versioning, archive naming, meeting-evidence capture and the minimal shared evidence model; the inventory and this overview do not accept decisions. Accepted [ADR-0012](adr/0012-local-first-meeting-evidence-capture.md) establishes local-first capture, platform labels as metadata only, and authorized online review when local retention fails. Accepted [ADR-0013](adr/0013-minimal-shared-evidence-model.md) supersedes the broader proposal in ADR-0009.

| Proposed ADR | Not established by that proposal |
|---|---|
| [0008: Independent contracts](adr/0008-define-independent-skill-contracts.md) | A universal compatible-input contract or producer-neutral record guarantee across the current skills. |
| [0010: Retrieval semantics](adr/0010-define-evidence-retrieval-semantics.md) | A consolidated shared retrieval reference, ranking algorithm or ingestion service. Some underlying rules already exist in specialist references. |

Implementation of a proposal needs explicit owner acceptance and a separately scoped, versioned change. The accepted baseline decisions below, rather than this descriptive overview, establish the new requirements.

## Standard layout and physical migration

Accepted [ADR-0015](adr/0015-standardise-project-folders-and-navigation.md) and [ADR-0017](adr/0017-use-direct-filesystem-operations.md) establish the baseline and transition contract. Common Architecture is the authoritative seven-root definition. Supplementary folders are short and unnumbered; legacy locations are not permanent compliant alternatives.

All three skills use direct filesystem tools or shell commands, not Computer Use, for basic file operations. A short approved before/after mapping is sufficient for a simple reorganisation. Prefer direct folder renames/moves; create destinations, move contents, verify and remove approved emptied old folders where needed. Sync-client paths alone do not mandate cloud operations; use an authorised provider API/tool when filesystem operations cannot meet provider or preservation requirements.

Workspace Governance also bundles an optional local PowerShell helper for independent file moves. It is preview-by-default, binds application to an approved plan digest and records resumable progress. Its JSON and journal requirements apply only when using it. It does not classify sources, move directories, delete legacy containers, bootstrap controls, edit links or migrate cloud storage. Private plans and journals belong in the authorised target/session, not the public package.

The accepted scope includes compatible supplied evidence without producer requirements and source-grounded navigation, not a universal record schema or full acceptance of ADR-0008/ADR-0010. A complete migration requires the baseline, reconciled inventory, approved reference repairs and resolved retired roots. Static checks do not prove runtime behaviour, link preservation or safe concurrent editing.
