# ADR-0027: Parameterise the stakeholder exclusion by owner organisation

- Status: Accepted
- Date: 2026-10-27

## Context

[ADR-0018](0018-ground-stakeholder-profiles-in-project-evidence.md), whose eligibility decision [ADR-0020](0020-deploy-stable-versioned-workspace-signposts.md) retained, excludes Microsoft and Microsoft employees from stakeholder profiles. The rule reflects the owner's current employer. It was hard-coded in the skill description, body, templates and documentation, so it was wrong for anyone else installing the public plugin and would become wrong for the owner if their organisation changed.

## Decision

- Stakeholder Governance excludes the workspace owner's own organisation (the owner organisation) and its employees, in place of a named organisation.
- The skill resolves the owner organisation once per run, before creating or refreshing a profile: from the user's request or the target's own instructions; then the `owner_organisation` field of the workspace's meeting Archive Guide when present; otherwise it asks one focused question. If the owner says there is none, no organisation is excluded. The value used is reported and not written to a new file.
- All other eligibility rules are unchanged: affiliation comes from project evidence, never from a name or title; excluded people's attributed contributions remain source evidence; an existing profile of an excluded entity is flagged, not changed.

This amends the eligibility decision retained from ADR-0018; its other decisions, and ADR-0020, remain in force.

## Consequences

The plugin is portable to other owners and organisations. A workspace whose Archive Guide records Microsoft as the owner organisation behaves as before. A workspace with no recorded owner organisation gains one question per run until the user states it. Reading one field of the meeting Archive Guide is consumption of another owner's record, not a runtime dependency: the skill still runs without it. The person and organisation templates move to version 2.1; existing profiles are not migrated.

The owner accepted this decision on 2026-10-27.
