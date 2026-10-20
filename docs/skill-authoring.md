# Skill authoring

Read [Governance](../GOVERNANCE.md) and [current architecture](architecture.md) first. This guide explains how to work within today's package and ownership boundaries; it neither changes the existing skills nor implements the Proposed contracts or shared model.

## Extend, add a skill or add a plugin

| Choice | Use when | Review boundary |
|---|---|---|
| Extend an existing skill | The request is another operation within that skill's existing responsibility and owned records. | Check its references, assets and completion rules together. Do not widen its ownership by convenience. |
| Add a skill to `work-context` | The responsibility is distinct, independently useful and belongs in the same installation and release unit. | Establish non-overlapping ownership and update affected discovery and documentation references. Ownership or structure changes need an ADR. |
| Add a plugin under `plugins` | A capability needs a separate installation/release boundary rather than another operation in this package. | Record the significant packaging decision, add a portable manifest and catalogue source, and document installation. A new plugin is not a way to bypass shared ownership rules. |

Prefer extending an existing owner over creating a competing writer. A shared rule belongs in Common Architecture only if it genuinely governs all affected skills; specialist retrieval detail belongs in the owner's references. Do not consolidate unresolved terms into a new shared contract until the relevant decision is accepted.

## Package shape

Follow an [existing skill](../plugins/work-context/skills/workspace-governance/SKILL.md):

```text
plugins\<plugin>\
    plugin.json
    skills\
        <skill-name>\
            SKILL.md
            references\
            assets\
```

`SKILL.md` is the entry point, with YAML frontmatter for `name`, a useful trigger-oriented `description` and the current metadata conventions: skill `version`, `architecture` reference and `runtime-dependencies`. The directory and skill name agree. Current skills use `runtime-dependencies: none` to express independence; they still need client capabilities for the operation. Only add references or assets when needed, keep them inside the package and link them relative to the file using them. Skills are discovered at the fixed `skills` location, not by adding paths to `plugin.json`.

Keep the entry point readable: purpose and non-goals, files to load and when, target resolution, operations, ownership limits and completion. Put detailed procedures in `references` and reusable output structures in `assets`. A change to a consumed reference can change behaviour even if `SKILL.md` is untouched.

## Input, output and standalone boundaries

For the operation being authored or changed, make the following clear without inventing a new cross-skill schema:

| Question | Apply the existing rules |
|---|---|
| What starts it? | State the trigger, normal operation and bounded requested scope. Avoid running governance for ordinary reading or drafting. |
| What does it read? | Name the supplied path, source material and existing controls it actually needs. Resolve the target from user input, never the installed package. Keep source identity, attribution and coverage limitations. |
| What can it write? | Identify its owned records and the creation/repair scope the request authorises. Consume another owner's records without repairing or duplicating them. |
| What if input is absent or ambiguous? | Distinguish an authorised blank target from an uncertain target, insufficient evidence or a failed read. Follow the skill's focused clarification or partial-outcome rules; do not invent evidence or report failure as absence. |
| Can it finish alone? | Do not require another skill to bootstrap the workspace or run first. Use the currently supported standalone path; report gaps when that path cannot satisfy the requested result. |
| What can be handed off? | Pass the exact gap, bounded scope and source links. Another skill runs only if authorised; otherwise report the next step. No automatic synchronisation or second system of record. |

The current skills do not promise acceptance of every equivalent record from every producer. [ADR-0008](adr/0008-define-independent-skill-contracts.md) proposes a more explicit interoperability contract; this guide does not add that guarantee.

## Completion and review

Define an observable outcome for each operation: requested records exist once, links resolve, claims have appropriate sources, partial results and blocks are explicit, and unrelated owners' files remain unchanged. Check repeat-run behaviour: the current skills should not create duplicate files when inputs are unchanged; Workspace Governance bootstrap/repair should make no changes on repetition.

Preserve established evidence, owner notes, stable identities and `created_by`. Update `last_governed_by` only after a material update or validation. Keep governed-file template versions distinct from skill, architecture and plugin versions. Do not move, rename, archive, overwrite or delete existing material without the required approval; a new version is not migration authority.

Run the [repository checks](validation.md), then use a small anonymised scenario outside this packaging repository when behaviour changes. Check the changed operation, its missing-input path, standalone operation, ownership boundary and repetition rather than building a new test system by default. Record the expected and observed result, including gaps.

Finish with the [pull request checklist](../.github/pull_request_template.md): search all references to changed names, paths and rules; evaluate inherited behaviour; bundle applicable version changes; keep ADR statuses accurate; and explain compatibility or migration implications. Repository-only guidance and tooling outside the plugin need no package bump. Neither authoring nor validation implies permission to commit, push, merge, publish or move user files.
