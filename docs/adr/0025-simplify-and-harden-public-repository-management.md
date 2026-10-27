# ADR-0025: Simplify and harden public repository management

- Status: Accepted
- Date: 2026-10-27

## Context

This single-owner repository is a public showcase and installable plugin source. Merging to `main` makes source available to marketplace clients. The owner approved a bounded settings change on 27 October 2026 to reduce unused automation and workflow authority while keeping maintenance lightweight.

This decision extends [ADR-0021](0021-record-github-repository-governance-baseline.md) and completes the settings portion of [ADR-0022](0022-run-repository-validation-as-a-required-check.md). It does not authorise merging this or another pull request.

## Decision

1. Require the existing `Repository validation` check from GitHub Actions for `main`. The check name was confirmed from a successful pull-request run before the ruleset was changed. Preserve the existing PR requirement, zero required approving reviews, deletion/force-push blocks and empty bypass list.
2. Selectively allow `actions/checkout@*` in addition to the owner's actions, as supported by GitHub's selected-actions setting, and require actions to use full-length commit SHAs. Do not enable the broad GitHub-created or Marketplace-verified allowances. Review additional actions before expanding the allowlist. Built-in Copilot cloud/review workflows were not exercised by this change; investigate a concrete policy incompatibility before approving any additional exception.
3. Require approval for all external contributors' fork pull-request workflows. Retain the read-only default workflow token and the prohibition on Actions creating or approving PRs.
4. Disable auto-merge and Copilot scheduled/event-triggered automations. Retain on-demand agent work, its workflow approval policy, firewall settings and validation tools. Keep squash-only merging and automatic head-branch deletion; use the PR title and description as the squash message.
5. Enable Dependabot alerts and security updates. Add weekly grouped GitHub Actions version updates with at most one open version-update PR. Do not add auto-merge or credentials. Security updates remain enabled independently of that version-update PR limit.
6. Preserve Issues and PRs, private vulnerability reporting, secret scanning and push protection. Keep unused publishing/collaboration features disabled. Leave installed-app access unchanged until the owner identifies unused integrations; do not infer usage or uninstall account-wide apps.
7. Record the observed results and outstanding runtime checks in the [configuration guide](../repository-configuration.md). Configuration and documentation are separate surfaces: the Dependabot file takes effect only after an owner-approved merge to the default branch.

## Consequences

The owner deliberately merges each publication, and a named static validation result is required. Zero approving reviews remains a single-owner trade-off, not enforced owner review or independent approval. CI cannot establish that skill instructions are safe or that content is suitable for public release.

Pinned actions need updates; a weekly grouped PR reduces manual tracking without granting publication authority. A required check can block merges during a failure or outage. Recover through an explicitly approved configuration change, not an invented bypass. A settings re-read verifies persistence, not enforcement under a deliberately failing PR; that separate exercise was not performed. No installed plugin, real project, Microsoft 365 source or internal repository is changed.
