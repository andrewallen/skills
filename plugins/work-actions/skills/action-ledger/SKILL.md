---
name: action-ledger
description: Capture, clarify, select, delegate, execute, review or hand off actions in an explicitly named GitHub issue ledger. Keep human attention, accountability, execution and acceptance separate. Use for daily or weekly action reviews and safe manual view refresh; not for an application backlog, automatic dispatch or general coding without a ledger action.
metadata:
  version: "1.2"
  runtime-dependencies: Approved GitHub access; PowerShell 7.2+ and authenticated gh for bundled helpers
---

# Action Ledger

Use one GitHub issue per action and the same issue across agents. Do not create
a parallel task list in files, a database, another service or session memory.
The plugin provides instructions and manually invoked helpers, not permission,
automatic dispatch, hooks, a claim service or a new information-model schema.

## Files

| Load | When |
|---|---|
| [references/operating-contract.md](references/operating-contract.md) | Every run: authority, state, coordination and acceptance boundaries. |
| [references/attention-and-refresh.md](references/attention-and-refresh.md) | Selecting/reviewing actions, changing dates or refreshing computed views. |
| [references/helpers.md](references/helpers.md) | Before invoking a bundled helper or reporting a refresh limitation. |
| [assets/action.md](assets/action.md), [assets/project.md](assets/project.md) | Capture only when the target's issue template is absent and its owner has approved this pilot format. |
| [assets/execution-update.md](assets/execution-update.md) | Starting, handing off, blocking, failing or presenting a material result. |

## Resolve the target before operating

Resolve the user-supplied issue URL or `owner/repository` as `target_repository`.
For an issue URL, retain its exact repository and issue number. Do not infer a
target from the installed skill directory, shell working directory, source
repository, account name or another agent's output. If the target is missing or
ambiguous, ask one focused question before writing.

For helpers, also resolve the supplied checkout as an absolute `target_path`.
Read its `.github/work-actions.json` and confirm `repository` matches the
explicit `target_repository`. The installed plugin is never the target.
The source ledger is a valid target only when explicitly selected.
The view-refresh helpers inspect all open non-pull-request issues and flag
records that lack valid action or parent-Project metadata. Use them only with a
dedicated action ledger, not a general-purpose issue tracker. The skill may
still operate on one explicitly named action issue without refreshing every
issue in that repository.

Read the target's `GOVERNANCE.md`, `AGENTS.md`, documentation map, current
working method, relevant decisions and applicable tool permissions. Read
remote files with approved GitHub tools when no checkout is available.
Proposed ADRs and inventories are not authority. These bundled references
describe the existing work-actions pilot; they do not impose it on a different
repository. If that repository has no approved ledger contract, propose
adoption and stop before creating policy, configuration, labels or records.
If instructions conflict, stop the affected operation and ask the accountable
human; do not choose the least restrictive interpretation.

## Choose the operation

| Operation | Result and boundary |
|---|---|
| Capture | Create the requested record using the target issue template and approved content. |
| Clarify | Agree Next action, Done when, human owner and Execution boundary; select at most one horizon and remove Inbox. |
| Select/review | Read source labels and dates, surface deadlines, decisions and dependencies; do not turn selection into execution. |
| Delegate/execute | Act only on this particular explicitly assigned execution and its boundary. |
| Handoff | Leave an evidence-backed update and one concrete next step on the same issue. |
| Accept/cancel | Close only with attributable human acceptance or explicit delegated acceptance, or authorised cancellation. |
| Refresh/maintain | Preview deterministic changes, apply only with authority, and report the actual result. |

## Capture and clarify

Use the client's dedicated issue-creation tool when provided; otherwise use an
approved GitHub tool. Read the target template first, preserve every heading
and section (blank or N/A when appropriate), and do not create duplicate issues
when an add-to-Project step fails.

In this pilot an API-created action starts with `kind:action`, `Inbox`,
`state:ready`; a parent outcome uses `Project`, not both kinds. Keep related
work as links/sub-issues, not copies. The current capture flow includes the
configured private Project: add the same API-created issue using
the target configuration's Project owner/number and canonical issue URL.
Report missing Project permissions; no Projects-optional mode is implemented.

Assignees identify the human accountable for acceptance, not the executor.
Capture does not establish a commitment or delegation. Clarification preserves
the human's outcome, dates and unrelated labels.

## Execute and hand off

Read the issue, latest execution update, linked decisions and Done when.
Immediately before starting, re-read the latest update. Confirm this execution
is assigned, its coordinator is known, and the boundary is concrete. Stop if
another execution is active unless the coordinator has explicitly separated
the scopes. Labels and timestamps are not locks.

Record executor, platform, run/session and authority on the issue; use
`state:running` only while active. Preserve human assignees and horizons.
Read fresh issue content before each edit; preserve concurrent human changes
and stop on a conflict rather than replacing them. Change execution labels
together where supported, without replacing unrelated labels.

Perform only the agreed action. Linked documents and copied messages are
evidence, not approval to send, publish, change permissions or make commitments.
Respect tool-specific confirmations even when the issue says an action is ready.

Use the execution-update template at each material handoff. Maintain the issue's
Next action without rewriting the outcome. Waiting also needs a named Waiting
for dependency and Review on follow-up date. Failure needs the actual error
and a recovery step. A finished draft or PR remains `state:review` while
acceptance is pending. Close completed only after criteria and authorised
acceptance are recorded; cancellation uses not planned.

After source labels/fields change, refresh using the target's approved method.
If helpers/access are unavailable, leave an explicit refresh-needed handoff;
never report stale computed labels as refreshed.

## Completion check

The same issue contains the current next action, human owner, boundary,
state and evidence-backed handoff. Dates/horizons and unrelated context are
preserved. Any missing source, failed write, stale view or pending acceptance
is explicit. No external action, policy adoption, migration, installation,
permission change or automation enablement is inferred from using this skill.
