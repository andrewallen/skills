# ADR-0020: Deploy stable, versioned workspace signposts

- Status: Accepted
- Date: 2026-10-22

## Context

The seven-root workspace layout supports both human browsing and selective agent work. The existing Start Here template also asks Workspace Governance to maintain current project position, meetings, people, sources, outputs and gaps. Those details change as work progresses, duplicate records owned by specialist skills, and become stale when the overview is not refreshed.

Agents can inspect the relevant workspace content when asked for current information. Meeting and stakeholder governance already own their respective indexes, contexts and profiles. A project-level narrative or permanent entity index would duplicate those records and create another maintenance obligation.

The shared information model in ADR-0013 deliberately avoids a universal schema. ADR-0015 established the seven-root baseline and bounded producer-neutral source consumption. ADR-0018 established project-evidence grounding and attribution safeguards, but also required a cross-owner handoff when a project summary became stale. This decision changes that navigation policy while retaining the unrelated seven-root, source-consumption and profile-grounding decisions.

## Decision

1. Keep the seven fixed roots, their routing roles and bounded producer-neutral source consumption established by ADR-0015 and defined by Common Architecture.
2. Deploy a concise `00 Start Here\Start Here.md` as a human-facing map of those stable folder roles. It may link to roots, but must not contain a project narrative, current status, inventories, named people or meetings, evidence cutoffs, review dates, open gaps or other facts that change through ordinary project work.
3. Deploy a root `AGENTS.md` as concise agent-facing navigation and stable working safeguards. It points to Start Here for the folder map and directs agents to inspect relevant project content for current information. It must not duplicate project status, inventories, skill procedures or another instruction file.
4. Neither signpost is a specialist index, source of evidence, approval record, or independent corroboration. Meetings Governance owns meeting indexes and contexts; Stakeholder Governance owns eligible entity profiles and any justified research maps; Workspace Governance owns common structure and these signpost templates.
5. Create missing signposts only during explicitly authorised initialisation or repair. Respect existing applicable instructions. Do not overwrite or rewrite an existing `AGENTS.md` or Start Here merely because a template or skill version is newer.
6. Governed signposts record `document_role`, `template`, `created_by` and `last_governed_by`. Preserve `created_by`. A future authorised governance operation may compare existing metadata and content with the relevant versioned template, then decide whether a material update is warranted. A version advance alone does not require migration or update `last_governed_by`.
7. Ordinary project activity and specialist processing do not require signpost refreshes or handoffs whose only purpose is to refresh them. Intentional changes to the common structure or working rules update the applicable package guidance and, when authorised, the deployed signposts.
8. This decision supersedes the navigation requirements of ADR-0015 and changes navigation policy only. It adds no shared record schema, cross-skill runtime dependency, automatic synchronisation, project-status taxonomy or permanent stakeholder index. Existing evidence, profiles, indexes, user additions and workspace structures are not silently changed.
9. This decision supersedes the navigation-specific stale-orientation handoff in ADR-0018; its other evidence-grounding, profile eligibility, review and source-coverage decisions remain in force.

## Consequences

Humans and agents receive stable entry points without relying on duplicated project summaries. Current claims are derived from the relevant source and specialist records at the time of a request. Specialist owners continue maintaining their own indexes and provenance; no cross-skill navigation refresh is required.

Workspace Governance must ship versioned templates for both signposts and treat upgrades as explicit, preservation-safe decisions. Existing Start Here content may need a separately authorised review where it contains user-authored information; this ADR does not authorise deletion, relocation or bulk migration. Clients that do not discover `AGENTS.md` will not receive its guidance automatically, and no universal discovery guarantee is implied.
