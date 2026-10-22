# Governance

This is a personal repository. It governs how the `work-context` and `work-actions` plugins and any future plugins are changed and distributed. It does not govern the workspaces the skills operate on; those rules live in the plugin's [Common Architecture](plugins/work-context/Common%20Architecture.md).

## Roles

- **Owner:** `andrewallen` decides scope, approves changes and publishes releases.

## Decisions

- Significant decisions are recorded as Architecture Decision Records in [docs/adr](docs/adr/README.md).
- A decision is significant if it changes plugin structure, skill ownership boundaries, the manifest or marketplace format, distribution, or data-handling rules.
- Superseded ADRs are kept and marked, never deleted.

## Changes

Use a branch and a pull request to `main` for repository changes. The owner reviews and merges; coding agents may prepare changes but must not infer permission to publish or merge.

Before a change is ready for review:

1. Identify the affected skills, shared references, templates and installation instructions. Search the whole repository for references to changed names, paths and rules.
2. Add or update an ADR for a significant decision. A Proposed ADR is not authority to change behaviour; the owner must explicitly accept it. Keep the ADR index and status in sync.
3. Make the change and the relevant version updates together, following the rules below.
4. Validate JSON manifests, local links and cross-file consistency as applicable using the [repository checks](docs/validation.md). Check the diff for whitespace errors, unintended changes and private content. For behavioural changes, record the expected result and check that the instructions produce it without conflicting with existing safeguards.
5. In the pull request, describe the change, affected versions, validation and any migration or compatibility implications. Use the [pull request checklist](.github/pull_request_template.md).

## Versioning

| Version | When to change it |
|---|---|
| Plugin `version` in `plugins/<plugin>/plugin.json` | Whenever the distributed package changes, including bundled skills, references or templates. Use semantic versioning: patch for corrections, minor for compatible additions, major for incompatible changes. |
| Skill `metadata.version` in `SKILL.md` | When that skill's behaviour changes, including changes made through references it consumes. Keep the existing major.minor format: increment minor for compatible changes or corrections, major for incompatible changes. |
| `architecture_version` in Common Architecture | When shared folder structure, routing or ownership rules change. Update its effective date and every skill's `metadata.architecture` reference together. |
| Governed-file `template` version | When the generated file's schema or required structure changes. Keep it separate from skill, architecture and plugin versions. |

Metadata-only updates to an architecture reference do not themselves require a skill version bump. Repository-only documentation or process changes outside a plugin do not require a plugin bump. Evaluate each skill if a shared reference changes its behaviour.

Do not add duplicate plugin versions to the marketplace catalogue; the plugin manifest is the version source. Do not change `created_by` in existing governed files, or migrate user workspaces merely because a version advanced. A folder rename must explain the treatment of existing workspaces and obtain approval before moving established content.

## Publishing and updates

The published source is the repository ref used when registering the marketplace. With `copilot plugin marketplace add andrewallen/skills`, this is the default branch, `main`; a feature-branch push is not publication to that source.

1. Confirm the package and version changes have been reviewed together.
2. Merge to the tracked ref only with owner approval.
3. Check that the remote ref contains the intended plugin version and files. A successful push to a different branch does not satisfy this check.
4. Refresh the catalogue and update the installed plugin in an authorised test installation, then start a new session and check its installed version and affected behaviour. Report an unperformed installation check as a gap, not a successful release check.

See [README update instructions](README.md#updating-an-installed-plugin). Marketplace registration and a version bump do not guarantee automatic installation: that depends on the client's update configuration. GitHub tags and Releases are optional release records, not substitutes for updating the ref the marketplace consumes.

These are contributor checklists, not automated enforcement. Branch protection and CI are separate repository settings and are not enabled by this document.

## Migration and validation boundaries

[ADR-0015](docs/adr/0015-standardise-project-folders-and-navigation.md) defines the physical seven-root baseline; [ADR-0016](docs/adr/0016-migrate-projects-through-approved-plans.md) defines approved transitions. A release does not approve moving an existing project. A permanent legacy path map is not conformity. Scope approval, item preservation, reference risks, concurrency and partial progress must remain explicit.

Declare actual helper prerequisites and update repository checks with packaging changes. Distinguish static consistency/parser validation from skill/helper execution, live migration, client installation and publication. Honour an explicitly static-only validation scope, record the unperformed runtime checks as gaps, and never describe static checks as proof of runtime safety.

## Content rules

- Do not commit workspace evidence, customer documents, generated outputs, credentials or local caches.
- This is public-facing material. Examples must be fictional or safely anonymised and remain functional through explicit placeholders and input contracts.
- Do not include employer or customer proprietary information, identifiable case narratives, private URLs, tenant/item IDs, personal profiles or real project inventories. Review references, screenshots, snippets and added assets as well as prose. Public product/tool names are not inherently proprietary.
- Keep real source identities and evidence in authorised target workspaces; public-safe packaging must not require anonymising or fabricating privately retained evidence.
- Changes to data-handling guidance (for example capture, retention or redaction rules) need an ADR.

## Licensing

No reuse licence is currently configured; all rights are reserved until the owner chooses one (see [ADR-0004](docs/adr/0004-licence-not-yet-chosen.md)).
