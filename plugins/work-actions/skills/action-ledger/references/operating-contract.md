# Current pilot operating contract

This is a portable summary of the existing ledger procedure, not adoption of
the source repository's Proposed information model or ADRs. Read the target
policy every run. Target governance and accepted decisions supply authority;
an issue may narrow a boundary, never expand tool permissions or safety rules.

## Independent dimensions

| Dimension | Current representation |
|---|---|
| Identity | Canonical GitHub issue URL; titles may change |
| Kind | `kind:action` for an action, `Project` for a parent outcome, never both |
| Human accountability | Human issue assignee |
| Capture | `Inbox`, removed after clarification |
| Horizon | At most one of `1-Now`, `2-Next`, `3-Soon`, `4-Later`, `5-Someday` |
| Execution | At most one of the five states below |
| Dates | Optional top-level `### Due date` and `### Review on`, `YYYY-MM-DD` |
| Executor | Identity/platform and stable run/session in execution updates |
| Acceptance | Attributable decision against Done when, not an agent stopping |

| State | Meaning |
|---|---|
| `state:ready` | Available for selection, not permission to execute |
| `state:running` | An explicitly assigned execution is active |
| `6-Waiting` | Paused on a named dependency/decision; retain horizon, maintain Waiting for and Review on |
| `state:review` | A result/proposal needs human acceptance |
| `state:failed` | Execution stopped unsuccessfully; leave actual error and recovery step |

## Coordination and authority

Use one human or explicitly delegated coordinator per action. An assignee,
ready/Now label, timestamp, comment, Project view or session badge grants no
independent authority. Re-reading then writing `state:running` is not an
exclusive claim, lease or lock. Parallel work requires explicitly separated
scopes and recorded assignments, not competing claims.

The action owner controls outcome, horizon, constraints and acceptance.
The executor needs a bounded Next action, Done when, owner and Execution
boundary before starting. Record the start and material handoffs, not routine
progress streams or transcripts. Keep human accountability separate from the
executor. A PR, successful tool call or idle session is not acceptance.

Do not send, publish, change access, subscribe, enable automation or make
commitments without applicable authorization and required tool confirmation.
No helper dispatches agents, writes source fields or closes actions. Setup
and Project maintenance require separate explicit authority.

## Evidence, data and edits

Read fresh content before editing, preserve unrelated fields/labels and
concurrent human edits, and stop when a conflict cannot be reconciled safely.
Report observed results separately from interpretation, proposals and
uncertainty. A repeated agent assertion is not independent corroboration.
Missing or inaccessible evidence is not proof of absence.

Use approved content and minimal source links. A private destination does not
authorize copying email, transcripts, customer documents or third-party work.
Never store credentials, private caches or operational transcripts in the
package. Keep fictional walkthroughs explicitly fictional.

Use [the handoff template](../assets/execution-update.md). Keep results open
in review until human or explicitly delegated acceptance is recorded against
criteria. Use completed for accepted outcomes, not planned for authorized
cancellation. Do not retrofit undocumented approval into historical records.
