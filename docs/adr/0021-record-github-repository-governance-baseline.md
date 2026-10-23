# ADR-0021: Record the GitHub repository governance baseline

- Status: Accepted
- Date: 2026-10-22

## Context

GitHub repository settings are changed outside the Git tree. Governance already requires pull requests and owner authority, but a short statement about branch protection does not explain the enforcement, trade-offs or how to configure a similar repository.

Read-only GitHub API inspection on 22 October 2026 established the settings recorded in the [repository configuration guide](../repository-configuration.md#observed-configuration-on-22-october-2026). Those observations do not establish who changed every setting, its previous value or the original rationale. This decision records the baseline adopted now; it is not a reconstructed audit log.

This is a personal plugin-source repository. Merging to the marketplace's tracked default branch publishes source for clients to retrieve. It needs a reviewable change boundary without implying that GitHub provides independent review, automated validation or permission for an agent to merge.

## Decision

1. Require pull requests for changes to `main`, block branch deletion and non-fast-forward updates, and use an active ruleset with no configured bypass actors. Preserve the ruleset scope when inspecting or changing it; check inherited rules and classic branch protection as well.
2. Use squash-only merging at repository level to keep a PR-sized change as one default-branch commit. Delete merged head branches automatically to reduce retained short-lived branches. Availability of auto-merge does not authorise enabling it or merging any particular PR.
3. Accept zero required approving reviews for this single-owner baseline. GitHub does not thereby enforce the owner's review or authorisation, which remain process requirements in Governance. Do not represent PR-only enforcement as independent review. Reconsider approval counts, code ownership, last-push approval and conversation resolution when collaborators or risk change.
4. Use the accepted [ADR-0022](0022-run-repository-validation-as-a-required-check.md) design for pull-request validation. Until its workflow is merged, reports under the intended name and is configured as a required status check, manual repository validation remains necessary. A clean mergeability result, an empty check list or a ruleset requiring a PR is not proof that validation passed.
5. Retain read-only default `GITHUB_TOKEN` permissions, disallow PR approval through that token's workflow setting, and retain secret scanning and push protection where supported. Other credentials and explicit workflow permissions need separate review; these defaults are not a guarantee about every automation identity. The wider observed Actions permissions and disabled security features are recorded as observations, not a recommended baseline for future automation. New workflows, elevated permissions and dependency-update automation need their own review.
6. Separate intended policy, dated observed configuration and repository-specific choices in a reusable guide. State the rationale for decisions adopted here without inventing historical intent for other settings. Another repository must choose its own review, validation, Actions and security policies rather than copy this baseline blindly.
7. Treat consequential GitHub settings changes as governance changes: document the intended change and authority, inspect the existing state, apply only the approved scope, verify the resulting effective configuration and record the result with its documentation. Documentation alone never configures GitHub or authorises a settings write, merge or bypass.
8. Keep the guide and this decision in repository operating governance, not the packaged workspace Common Architecture, evidence taxonomy or skill templates. No plugin, skill, architecture or template version changes are required for these repository-only documents.

## Consequences

Contributors have an inspectable rationale and a repeatable configuration approach, while live GitHub remains authoritative for active enforcement. The dated observation is not refreshed on a schedule; future intentional configuration changes record their own evidence and update the relevant intent. The guide supplies read-only discovery and an approval-bound setup procedure, not a settings synchroniser.

This lightweight baseline does not guarantee independent review, successful tests, a secure workflow supply chain or detection of every secret. Organisational policies and repository capabilities may impose stronger constraints. A team-maintained or higher-risk repository should select stronger controls and verify that its chosen GitHub plan supports them. The accepted validation workflow and required-status rule are not effective until the post-merge adoption steps are completed and verified.
