# Workflows in practice

[Collection](../README.md) | [Work Context](work-context-plugin.md) | [Work Actions](work-actions-plugin.md)

These walkthroughs explain the intended behaviour through fictional scenarios. Requests and result excerpts are illustrative, not executed runs, complete record templates or evidence of a live deployment. Names, paths and issue numbers are placeholders.

- [From meeting evidence to reusable context](#from-meeting-evidence-to-reusable-context)
- [From new evidence to an updated stakeholder profile](#from-new-evidence-to-an-updated-stakeholder-profile)
- [From a captured action to a human-agent handoff](#from-a-captured-action-to-a-human-agent-handoff)
- [From an existing project to the standard structure](#from-an-existing-project-to-the-standard-structure)

## From an existing project to the standard structure

### The friction

A fictional Example Project has drafts, source documents and meeting evidence in inconsistent locations. Its users want the same short baseline as other projects, without losing versions or shared links.

### The request

> Use Workspace Governance to inventory `C:\Projects\Example` and prepare a migration plan into the standard seven folders. Preserve coherent collections and source identities. Report uncertainty and do not move anything until the plan is approved.

### What the agent does

It identifies the target boundary, existing instructions, useful collections, exact destinations, dependencies and excluded or unresolved items. The plan covers the seven roots, minimal controls, approved navigation repairs and treatment of retired containers. It does not infer issue from a filename.

After approval of that exact scope, routine independent moves proceed without repeated questions. The optional helper can preview/apply/resume an ordinary-local-file batch; shared/cloud items use an appropriate authorised platform route. A local move does not prove shared links survived. Empty old folders require approved cleanup, not silent deletion.

### An illustrative result

```text
Drafts\Options.md -> 20 Working\Options.md
Reference\Guide.pdf -> 30 Sources\Guide.pdf
Shared presentation -> deferred: platform move/link checks outstanding
Overall outcome -> partial until deferred items and retired roots are resolved
```

These are fictional plan rows, not an executed migration or proof of helper behaviour.

### What stays human

The owner approves the plan, consequential exceptions and tool-specific actions. Scope changes require new authority. Evidence, provenance and owner notes are preserved. The final outcome is physical conformity, not a permanent map of legacy folders.

### The design choice

[Short standard folders](adr/0015-standardise-project-folders-and-navigation.md) support browsing and direct sharing. [Approved resumable migration](adr/0016-migrate-projects-through-approved-plans.md) makes progress traceable without claiming that static checks prove runtime safety.

## From meeting evidence to reusable context

### The friction

A project's meeting history is available, but answering "where was that concern raised?" means reading long transcripts again. A short summary alone makes it hard to check wording, attribution or what was left out.

### The request

> Use Meetings Governance to capture the supplied Example Project meeting in `C:\Work\ExampleProject`. Create an anchored context with a topic map and attributed points. Retain in-scope evidence locally where possible and report source coverage explicitly.

### What the agent does

It resolves the exact occurrence, attempts local retention of its in-scope sources, and reads the evidence behind the context. The context links to companions and source passages, records attribution limitations and distinguishes retrieval, semantic review and retention.

If local saving fails but normal authorised online reading works, the source may still inform synthesis. If reading also fails, the context records a gap rather than inventing the missing account.

### An illustrative result

```text
Topic map: 00:00-05:20 - delivery options
Recorded point: Participant A raised a sequencing concern - transcript 03:10
Historical follow-up: circulate an options note; no completion evidenced
Coverage: transcript retained and reviewed; linked deck reviewed online,
          not retained locally because the save failed
```

This is a navigation excerpt, not a transcript quotation. A real record requires real source anchors, identities and observed limitations.

### What stays human

The owner controls project scope and keeps their own notes. A follow-up mention is historical evidence, not a new assignment or proof of completion. Exact wording and contested claims still lead back to primary evidence.

### The design choice

[Local-first capture with authorised online review](adr/0012-local-first-meeting-evidence-capture.md) prevents a save failure from being confused with an unreadable source. [Per-source coverage](adr/0014-record-meeting-evidence-coverage-per-source.md) makes the difference visible without a single ambiguous meeting status.

[Explore Meetings Governance](work-context-plugin.md#meetings-governance) | [Inspect the context template](../plugins/work-context/skills/meetings-governance/assets/context-record.md)

## From new evidence to an updated stakeholder profile

### The friction

A person or organisation has a profile, but new evidence has arrived. Rewriting the whole profile can erase earlier positions, flatten disagreement or mistake one person's remarks for an organisation's formal view.

### The request

> Use Stakeholder Governance to refresh only the Example Partner organisation profile from the supplied new evidence. Preserve dated prior positions, cite the source passages and show what remains uncertain. Do not infer endorsement.

### What the agent does

It resolves the entity, reads the affected profile and the relevant primary passages, and updates only supported sections. An existing meeting index and context help locate passages; they are not independent corroboration of the underlying source.

A meeting archive is optional: supplied evidence can support a standalone profile pass. Missing meeting collection remains a bounded gap or an explicitly authorised handoff, not permission for the profile skill to collect meetings.

### An illustrative result

```text
Earlier position: retained with its original date and source
New contribution: a participant raised a delivery constraint
Organisation position: not established by that participant's remark alone
Implication: a question for follow-up, labelled as proposed rather than agreed
```

### What stays human

The owner decides the relevant entities and research scope. The profile records evidenced positions; it does not predict approval, assign motives or create a personality model.

### The design choice

[Independent ownership](adr/0003-independent-skills-with-fixed-ownership.md) avoids a second meeting archive. The [minimal shared evidence model](adr/0013-minimal-shared-evidence-model.md) keeps source links, attribution, dates and coverage useful across records without forcing every skill into the same schema.

[Explore Stakeholder Governance](work-context-plugin.md#stakeholder-governance) | [Inspect the organisation profile template](../plugins/work-context/skills/stakeholder-governance/assets/organisation-profile.md)

## From a captured action to a human-agent handoff

### The friction

A task exists in a conversation, but its owner, next step and acceptance criteria are unclear. Another agent could start the same work, or a finished draft could be mistaken for an accepted result.

### The request

> Use Action Ledger to clarify issue 17 in `<owner>/<ledger>` with me. Establish the next action, done criteria, human owner and execution boundary. Do not start execution or close the issue.

### What the agent does

It checks the explicitly named ledger's approved contract and issue history, clarifies missing details with the human and records authorised changes on that same issue. Execution happens only after a separate, specific delegation with a concrete boundary.

Before starting an authorised execution, it checks the latest handoff and whether another execution is active. A subsequent result or blocker is recorded on the same issue, with evidence and a next step.

### An illustrative result

```text
Next action: draft an options note
Done when: the agreed options and their tradeoffs are documented
Human owner: explicitly confirmed during clarification
Execution boundary: draft only; no sending or publication
Later handoff, after authorised execution: draft linked; human review pending
```

### What stays human

Capture is not delegation. Selection is not execution. A draft ready for review is not accepted completion. Sending, publishing and changing permissions remain subject to the relevant authority and tool confirmations.

The meeting workflow can surface a historical follow-up, but does not automatically create or delegate an action here. That is an explicit human-authorised handoff.

### The design choice

The [operating contract](../plugins/work-actions/skills/action-ledger/references/operating-contract.md) separates human accountability, execution and acceptance. The plugin provides instructions and manual helpers, not locks or automatic dispatch.

[Explore Action Ledger](work-actions-plugin.md#action-ledger) | [Inspect the handoff template](../plugins/work-actions/skills/action-ledger/assets/execution-update.md)
