# Attention and manual refresh

The fixtures use `Europe/London`; operational dates use the target ledger's
configured `timeZone` system ID, including its daylight-saving transitions.
Due date is a real deadline; Review on is resurfacing/follow-up. Never move a
deadline just to hide overdue work. Dates are blank, `_No response_`, or a
valid `YYYY-MM-DD`, with no prose or duplicate sections. Only top-level form
sections count, not dates in fences or blockquotes.

Attention date is the earlier of Due date and Review on. A past review date
keeps resurfacing until deliberately updated. Day 0 is today; seven days
means days 0-6 and thirty days means days 0-29.

All views exclude closed issues. Action views exclude parent outcomes and
invalid metadata.

| View | Rule |
|---|---|
| Capture | `Inbox` |
| Do - Now | `1-Now` OR Inbox OR attention date today/overdue |
| Plan - Next | (`2-Next` OR attention date tomorrow) AND NOT `1-Now` |
| Review - Soon | (`3-Soon` OR attention date days 2-6) AND NOT `1-Now`/`2-Next` |
| Review - Later | (`4-Later` OR attention date days 7-29) AND NOT `1-Now`/`2-Next`/`3-Soon` |
| Someday | (`5-Someday` OR no attention date) AND NOT `1-Now`/`2-Next`/`3-Soon`/`4-Later`/`6-Waiting` |
| Blocked / Waiting | `6-Waiting` |
| Projects | `Project` parent outcomes only |

Overlap is intentional: Next due today is in Now and Next; overdue Waiting is
in Now and Waiting; undated Inbox is also in Someday. Exclusions use chosen
horizon labels, not membership of other views. `6-Waiting` is not a horizon.

**During the day:** capture, select work, review decisions/failures and record
acceptance on the issue. **Daily:** clarify Inbox, inspect real deadlines,
choose Now/Next and follow up Waiting; run a full refresh to recalculate date
boundaries. **Weekly:** review Soon/Later/Someday and each parent outcome,
confirm actual next actions, and revisit dependencies. Do not automatically
start everything that appears in Now or ready.

Only the reconciler owns the configured `view:*` labels and
`automation:needs-fix`. Change source fields/labels, then use
[the helper instructions](helpers.md). Invalid metadata gets a visible flag
and explanatory comment; repeated identical errors do not spam comments.
Fix source data and refresh; old notices remain history.

The packaged helpers are manually invoked; no scheduled runner or automatic
refresh is part of this plugin. Do not enable automation, alter runners or
permissions to clear a check. Source labels/comments update immediately;
computed views can be stale.
Rechecks detect some concurrent edits but cannot eliminate the final read/write
gap. Report conflicts and rerun only once the target is stable.
