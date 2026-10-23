# ADR-0022: Run repository validation as a required check

- Status: Accepted
- Date: 2026-10-23

## Context

The repository's cross-file invariants (manifests and catalogue, versions, links, the ADR index, governed-template provenance, the seven-root baseline and PowerShell parsing) are enforced by `scripts/validate-repository.ps1`. The `work-actions` and workspace-migration helper tests are separate scripts. Until CI is deployed, contributors must remember to run them, and nothing in GitHub shows whether they ran, passed or were skipped.

[ADR-0021](0021-record-github-repository-governance-baseline.md) accepted that gap for now. Decision 4 keeps manual validation explicit "until CI and required checks are separately designed and configured", and decision 5 requires new workflows and elevated permissions to be reviewed on their own. This record is that design for the validation gate. The [dated observation](../repository-configuration.md#observed-configuration-on-22-october-2026) returned no workflows and no required-status-check rule, and a read-only check on 23 October 2026 found the same.

Three facts constrain the design. The checks are bounded: the migration helper test runs only against disposable synthetic directories, and the `work-actions` test uses synthetic fixtures with a faked `gh`. Their behaviour on Linux and macOS is unverified. The repository is public, so a pull request may come from a fork or an agent, and it runs its own copy of the scripts and workflow that judge it.

## Decision

Add a read-only GitHub Actions workflow that runs the repository's documented checks on every pull request to `main`, then require its result through the existing ruleset. The owner accepted this design on 23 October 2026. Acceptance authorises implementation, not a settings write or merge.

1. Run the repository validator, both isolated helper tests and a whitespace check of the pull request's changes against its base. A plain `git diff --check` on a clean checkout inspects nothing, so the workflow must make the base available. Add no check that the validation guide does not already document.
2. Trigger it with `pull_request`, never `pull_request_target`. Grant only `contents: read`, provide no secrets, do not persist checkout credentials, set a timeout and cancel superseded runs with a concurrency group. The workflow does not comment, label, approve, merge, tag, release or publish.
3. Use only GitHub-owned actions, each pinned to a full commit SHA with its version in a comment. Use a Windows runner until the validator and helpers are verified on another platform. The validator uses multi-segment path construction, but no Linux or macOS run is part of this design. Confirm at implementation that the runner provides PowerShell 7.2 or later and Git; this record does not establish that.
4. Give the job one stable name, which becomes the required-check context, and add no path filter or condition that can skip it. A required check that never reports blocks every merge.
5. Adopt in order: merge the workflow; confirm that it reports under the intended name on a pull request; only then add a required-status-check rule to the ruleset for `main`. Follow the settings-change procedure in [Governance](../../GOVERNANCE.md#github-repository-configuration): document the intended change, inspect the current ruleset, change only the approved scope and verify the effective rules. Demonstrate a failing result on an explicitly approved, non-destructive test pull request that is never merged, as the [configuration guide](../repository-configuration.md) describes.
6. Update the validation guide, the configuration guide's validation row and Governance's statement that the checks are contributor duties. Record a new dated observation when the rule is configured and leave the 22 October snapshot as history. ADR-0021 decision 4 is conditional and may lapse on its own terms, while the rest of that ADR stays in force. The status vocabulary has no partial form, so record the deployment state in the configuration guide rather than changing that ADR's status.

Alternatives not chosen: keeping manual validation (no supply-chain surface, but nothing on GitHub shows whether the checks ran); a local Git hook or pre-commit tool (helps one machine, can be skipped and gives a pull request no check); a workflow that is not required (visibility without a gate, so a failed or missing result can still merge; it is the interim state during adoption, not the end state); a Linux or macOS matrix (only after the validator is made portable and verified there); and a third-party CI service (adds credentials and another trust boundary for a read-only script).

The workflow is implemented in `.github/workflows/repository-validation.yml`. Acceptance does not itself make that file run on GitHub: it must first be merged, its check name confirmed on a pull request, and the required-status rule separately applied and verified. It does not select bypass actors, dependency-update automation, code-owner rules or a cross-platform matrix.

## Consequences

Once merged, every pull request to `main`, whoever or whatever prepared it, receives the same static checks. Until the workflow reports and the ruleset requires its stable check name, manual validation remains necessary and a merge is not gated on these checks.

The check is not review. It does not exercise agent skills or a real workspace migration, install or update the plugins, detect private or proprietary content, or judge whether prose is consistent. The migration-helper test uses disposable temporary directories; the Work Actions test uses synthetic fixtures and a faked `gh`. These bounds do not replace the owner's review or the pull request checklist. Because a pull request runs its own copy of the validator and workflow, a change to either can weaken the check that judges it. Changes under `scripts/` and `.github/` need particular care in review; the zero-approval baseline does not enforce that review.

With no bypass actors, a broken workflow or a GitHub Actions outage would block merges until the owner edits the ruleset under the settings-change procedure. The workflow adds a small supply-chain surface, which the read-only token, the absence of secrets and the GitHub-owned-actions rule are meant to bound. The repository's Actions settings currently allow all actions and do not require SHA pinning, so those rules would rest on review unless the owner separately tightens the settings, and pinned SHAs need manual refreshing while dependency-update automation is not enabled.
