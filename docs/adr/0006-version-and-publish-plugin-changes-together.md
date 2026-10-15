# ADR-0006: Version and publish plugin changes together

- Status: Accepted
- Date: 2026-10-15

## Context

The archive-folder correction was committed without advancing the plugin or skill version. A changed Git tree alone does not identify a new package version to installed clients, and a feature-branch push does not update a marketplace that tracks the default branch.

## Decision

Apply the change, versioning and publication checklists in [GOVERNANCE.md](../../GOVERNANCE.md). Keep the plugin manifest as the package-version source and keep skill, architecture and governed-file template versions independent. Include applicable version changes in the same pull request as the implementation.

Use repository instructions and a pull request template to make these checks visible. Publish through the marketplace's tracked ref, then verify the remote package and an authorised installation. Do not describe a feature-branch push as a published update.

## Consequences

Each package update has an identifiable version and a repeatable review and publication process. Contributors must check indirect effects through shared references. Automatic update behaviour remains client-dependent; these checklists do not configure CI, branch protection or client settings.
