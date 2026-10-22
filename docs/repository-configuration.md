# GitHub repository configuration

[Governance](../GOVERNANCE.md) | [ADR-0021](adr/0021-record-github-repository-governance-baseline.md) | [Repository validation](validation.md)

This guide records the intended operating baseline for this personal repository and how to adapt the approach elsewhere. It is not a configuration export, an enforcement mechanism or a claim that every setting was changed by the same person or session. GitHub is authoritative for live settings; the ADR records decisions and rationale.

## Intended baseline and choices

| Area | Intent for this repository | Choose again for another repository |
|---|---|---|
| Protected branch | Active ruleset covering `main`: require a PR, block deletion and non-fast-forward updates, no configured bypass actors. | Resolve the actual protected branches, inherited organisation rules and any narrowly justified bypass authority. |
| Review authority | Owner review and authorisation remain process requirements; zero required approving reviews suits the single-owner baseline. | Decide whether independent approvals, code owners, stale-review dismissal, last-push approval and resolved conversations are required. PR-only is not independent review. |
| Merge history | Repository-level squash-only merging and automatic deletion of merged head branches keep PR changes and short-lived branches manageable. | Choose a history strategy and branch-retention policy appropriate to release or long-lived branches. |
| Merge automation | Available auto-merge is a capability, not authority to enable it or accept a result. | Decide whether to allow it, which gates it must wait for and who may enable it. |
| Validation | Run the documented repository checks manually; do not claim a required CI gate exists. | For required CI, first establish reliable workflows, check names and trigger coverage, then require the chosen checks. |
| Workflow authority | Read-only default `GITHUB_TOKEN`; PR approval through that token's workflow setting disabled. | Review each workflow's actual permissions, third-party actions, other credentials and trust boundary before granting more authority. |
| Secret protection | Retain supported secret scanning and push protection. | Check availability, organisation requirements, alert handling and the limits of enabled detectors; this does not replace content review. |

The broader action allowlist, action pinning, dependency-update settings, enabled collaboration features and squash-message defaults below are observations, not universal recommendations. They have no established historical rationale in this record.

## Observed configuration on 22 October 2026

Source: authenticated, read-only GitHub REST inspection of `andrewallen/skills`, plus the default-branch `.github` file listing. No settings writes, test pushes or test PRs were performed. This bounded snapshot records public repository configuration, not credentials, alert contents or a private operational inventory.

| Surface | Observation |
|---|---|
| Repository | Public; default branch `main`. |
| Ruleset identity and scope | Repository-owned `Protect main`; active branch target; includes `refs/heads/main`; no exclusions or bypass actors. |
| Effective branch rules | `pull_request`, `deletion` and `non_fast_forward`; no required-status-check rule returned. |
| Review parameters | Required approving reviews: `0`. Required-reviewer list empty. Code-owner review, stale-review dismissal, last-push approval and review-thread resolution: disabled. |
| Additional PR parameter | `require_extra_approval_for_unattributed_changes: true` was returned; it does not establish a general independent-review requirement. |
| Merge methods at repository level | Squash enabled; merge commits and rebase disabled. |
| Merge methods in the PR rule | `merge`, `squash`, `rebase`. In combination with repository settings, only squash is available; the rule alone does not express a squash-only restriction. |
| Merge convenience settings | Auto-merge enabled as an available feature; automatic head-branch deletion enabled; update-branch feature disabled. |
| Squash message defaults | Title: `COMMIT_OR_PR_TITLE`; body: `COMMIT_MESSAGES`. |
| Classic branch protection | The authenticated request for `main` returned HTTP 404, `Branch not protected`; active ruleset and effective-rule reads succeeded independently. This response did not mean that `main` had no protection. |
| Actions | Enabled; all actions allowed; SHA pinning not required. |
| Workflow token defaults | `default_workflow_permissions: read`; `can_approve_pull_request_reviews: false`. Individual workflow grants still need inspection. |
| Workflow inventory | Actions API returned zero workflows; default-branch `.github` listing had no workflow directory. No repository CI or required status checks were observed. |
| Security settings returned | Secret scanning and push protection enabled. Dependabot security updates, non-provider secret patterns and validity checks disabled. This is not an inventory of every possible GitHub security control. |
| Collaboration settings | Issues enabled; Projects and wiki disabled; web commit sign-off not required. |

No previous-value comparison, change actor or original reason is established for each setting. Rule IDs and response metadata are intentionally not embedded in the reusable procedure. This snapshot is historical evidence, not a promise of current configuration; do not refresh it periodically or infer drift solely because it is old.

## Read-only inspection

Prerequisites: GitHub CLI, an authenticated account permitted to read the target's settings, and PowerShell for these examples. Some settings require repository administration access to inspect; organisation policies, plan and visibility affect availability. Do not request broader credentials than the authorised operation needs, or include token values in captured evidence.

Replace `owner/example-repository` with the exact authorised target. Run the commands individually and check the result and `$LASTEXITCODE` after each. Stop and report an unsuccessful request for that surface; do not interpret 403, 404, missing fields or `null` as a disabled feature or permission to try an alternate write.

```powershell
$repo = 'owner/example-repository'
gh api --method GET "repos/$repo" --jq '{default_branch,visibility,allow_squash_merge,allow_merge_commit,allow_rebase_merge,allow_auto_merge,delete_branch_on_merge,allow_update_branch,squash_merge_commit_title,squash_merge_commit_message,security_and_analysis}'
gh api --method GET "repos/$repo/rulesets" --paginate
gh api --method GET "repos/$repo/actions/permissions"
gh api --method GET "repos/$repo/actions/permissions/workflow"
gh api --method GET "repos/$repo/actions/workflows" --paginate
```

Use the branch observed in the successful repository response, not an assumed `main`. Discover ruleset identifiers from that target's list; never reuse identifiers from this repository. Inspect each applicable ruleset's full conditions, enforcement, parameters, source and bypass actors, including inherited rules when visible:

```powershell
$branch = 'observed-branch-name'
$encodedBranch = [uri]::EscapeDataString($branch)
$rulesetId = 'identifier-returned-by-target-discovery'
gh api --method GET "repos/$repo/rulesets/$rulesetId"
gh api --method GET "repos/$repo/rules/branches/$encodedBranch" --paginate
gh api --method GET "repos/$repo/branches/$encodedBranch/protection"
```

The classic-protection request may return 404 even when a ruleset protects the branch, as the snapshot demonstrates. On another target it may also reflect access or visibility limitations. Read the response body and corroborate with the target identity, rulesets, effective branch rules and, if authorised, the GitHub UI; never turn one 404 into a global absence claim.

For security or inherited settings not exposed to the account, report the visibility gap. Do not treat this partial inspection as an organisation-wide audit. Settings reads do not exercise enforcement, Actions permissions at runtime or security detection.

## Apply the approach to another repository

1. **Identify scope and authority.** Confirm the target, owner, visibility, protected branches, release process, collaborators, GitHub capabilities and existing organisational policy. A request to document or assess is not authority to reconfigure.
2. **Inspect before proposing.** Use the read-only procedure and review workflow files, existing governance and classic protection. Distinguish intended policy, actual repository/ruleset settings and the combined effective rules.
3. **Choose the baseline.** Record the chosen review count, check requirements, merge strategy, bypass authority, workflow permissions and security controls. For a shared or higher-risk repository, consider independent approvals and reliable CI instead of carrying over this repository's zero-approval/manual-validation trade-off.
4. **Approve an exact change set.** Show before/after values, target branches, rationale, access requirements, expected consequences and a recovery approach. Include any settings that are deliberately unchanged. Resolve conflicts with organisational requirements; do not weaken a rule or invent a bypass to make the change possible.
5. **Apply only the authorised changes.** In GitHub Settings, use General for merge/branch-cleanup choices, Rules > Rulesets for branch enforcement, Actions > General for workflow permissions, and the applicable security settings for supported protections. UI labels and available features vary. API writes are an alternative only when the exact target, operation and payload have been reviewed; there is no blind apply script or portable ruleset export here. Do not replace unrelated rule parameters or bypass lists.
6. **Verify and record.** Re-read each changed surface and the effective branch rules. Compare observed values with the approved change set, report partial outcomes, and preserve a bounded verification result alongside the documentation change. Stop dependent changes on unexpected drift. Do not revert unapproved settings or concurrent changes by inference.

To exercise behavior beyond inspection, use a separately authorised disposable repository or an explicitly approved, non-destructive test PR. Confirm the chosen review/check/merge gates there and distinguish that evidence from settings inspection. Do not test protections by deleting or force-pushing the real default branch. A test-PR merge needs its own authority; updating configuration does not authorise merging unrelated work.

## Maintenance and validation boundary

Update intended policy and its ADR when deliberately changing the approach; record new observations when intentionally configuring or investigating a target. No recurring snapshot refresh, background synchronisation or configuration-as-code service is introduced.

Run the [repository checks](validation.md) for documentation links and ADR consistency. They do not query GitHub or prove live enforcement. Record settings reads separately from runtime tests, test-PR outcomes and applied changes. A missing required status check or empty PR check list must never be reported as passed validation.

This documentation implementation changed no GitHub settings, package behaviour or user workspace files. No plugin, skill, Common Architecture or template version bump is needed. Adoption by another repository, live configuration changes and runtime enforcement tests remain separate authorised work.
