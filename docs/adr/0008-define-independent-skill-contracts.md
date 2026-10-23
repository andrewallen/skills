# ADR-0008: Define independent skill contracts and interoperability

- Status: Proposed
- Date: 2026-10-20

## Context

The skills have distinct responsibilities and no runtime dependency on one another, as established by [ADR-0003](0003-independent-skills-with-fixed-ownership.md). In practice, one skill may consume records created by another. Requiring the producer skill, its execution order or its private folder layout would make that information unnecessarily coupled and reduce the skills' ability to work with user-supplied or otherwise compatible material.

The skill definitions already describe triggers, operations, target resolution and completion checks, but do not consistently state an interoperable input contract.

## Decision

**Proposed:** Keep each skill independently usable and define its contract in terms of the information it accepts and owns, not the skill that produced it.

Each skill definition should make its purpose and triggers, accepted inputs, owned outputs, boundaries, preconditions, operations, missing-input behaviour, optional authorised handoffs and completion conditions explicit. A skill may consume a compatible record created by another skill, a person or another tool without requiring that producer to be installed or run. Producer and version metadata remain provenance, not a prerequisite for use.

Skills retain exclusive ownership of their governed outputs. Handoffs remain bounded, optional and authorised by the user's request; consuming another skill's output does not imply permission to run that skill or synchronise its records.

This proposal clarifies the independence principle in ADR-0003. It does not change current skill behaviour until accepted and implemented.

## Consequences

Skill authors can test each skill independently and can support equivalent inputs from different producers. Contracts may expose incompatibilities that need explicit adapters or a partial outcome; they must not silently reinterpret missing fields. Existing ownership boundaries and safeguards remain in force.

Acceptance will require reviewing all skill definitions and relevant shared references. No workspace migration is expected unless implementation introduces a separately approved schema change. Current position: part of this scope is already in force through other decisions: producer-neutral source consumption (ADR-0015, retained by ADR-0020 decision 1) and fixed ownership with bounded handoffs (ADR-0003). The contributor guidance in [skill-authoring.md](../skill-authoring.md) asks authors the questions listed above. Not adopted: a required contract section in every skill definition and the review of all skills that would accompany it. This proposal remains Proposed.
