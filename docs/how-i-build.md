# How I build these workflows

[Collection](../README.md) | [Workflow walkthroughs](workflows.md) | [Technical documentation](README.md#maintaining-and-extending)

I build these skills in the flow of work: taking recurring friction and making the useful parts of a workflow explicit enough for an agent to follow. This collection is a place to explore those patterns and the decisions behind them, not just download a set of prompts.

## Start with the work

The organising question is "what needs to become easier to do or revisit?" For this collection, that includes finding the source behind a meeting point, keeping project material navigable and carrying an action between people and agents without losing its boundary.

The [walkthroughs](workflows.md) show those problems through fictional examples. They are explanations of the design, not claims about measured time savings or live customer results.

## Give each skill a clear job

A skill needs to say when to use it, what to read, what it owns and where to stop. Adding more instructions is not useful if two skills then compete to maintain the same record.

Here, workspace structure, meeting capture, stakeholder profiles and action execution have distinct owners. They can exchange source links and bounded handoffs without becoming a mandatory pipeline. See [independent skill ownership](adr/0003-independent-skills-with-fixed-ownership.md).

## Keep evidence different from interpretation

A source, a selected passage, a summary, an inference and a recommendation are different things. Useful context points back to its sources and retains attribution, time and coverage limitations.

The [minimal shared evidence model](adr/0013-minimal-shared-evidence-model.md) establishes that conceptual core without imposing a universal schema. The meeting workflow also distinguishes [what was retrieved, reviewed and retained](adr/0014-record-meeting-evidence-coverage-per-source.md).

## Make the human boundary visible

An agent's ability to do something is not permission to do it. Capturing a follow-up does not assign it; producing a draft does not authorise sending it; approval and distribution are not the same event.

Those distinctions belong in the workflow itself, not only in a disclaimer at the end. They are visible in the [action handoff example](workflows.md#from-a-captured-action-to-a-human-agent-handoff) and in each skill's completion checks.

## Improve deliberately

Significant decisions are recorded in [ADRs](adr/README.md); a proposal is not an implemented promise. Changes to packaged behaviour are versioned with the affected plugin, skill and template, while existing user records are not automatically migrated.

[Repository checks](validation.md) check packaging, links and PowerShell syntax without executing helpers. They cannot prove that an agent follows the workflow. When a change is explicitly static-only, runtime behaviour remains a documented gap; no private project needs to be ingested to validate the public package.

When authorised, behavioural review uses a bounded, anonymised scenario outside this repository, including missing evidence, ownership limits and repeat-run behaviour. A check not performed remains a gap.

## Explore the implementation

For the human view, start with [Work Context](work-context-plugin.md) or [Work Actions](work-actions-plugin.md). For the implementation, follow their links into `SKILL.md`, detailed references and templates.

For maintenance, read [Governance](../GOVERNANCE.md) and the [authoring guide](skill-authoring.md). The collection's original content is licensed under the [MIT License](../LICENSE); this explanation does not introduce a contribution policy.
