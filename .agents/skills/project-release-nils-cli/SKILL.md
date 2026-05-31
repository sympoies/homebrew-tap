---
name: project-release-nils-cli
description: Release Homebrew formula nils-cli by dispatching the tap's GitHub Actions release workflow.
---

# Homebrew Tap Release Nils Cli

Manually publish a `nils-cli` version to this Homebrew tap by dispatching the
release workflow `.github/workflows/update-nils-cli-formula.yml`.

> The normal release path is automatic: the `nils-cli` release pipeline sends a
> `repository_dispatch` (`nils-cli-release`) to this tap, which runs the same
> workflow. Use this skill only to manually (re)publish a specific version — for
> example a backfill, or a re-run after a transient failure.

## Contract

Prereqs:

- Run inside this `homebrew-tap` git work tree (`gh` resolves the repo from the
  remote).
- `gh` available on `PATH` and authenticated with Actions (workflow) write scope.

Inputs:

- Required:
  - `--version <X.Y.Z|vX.Y.Z>` — `nils-cli` version to publish (leading `v`
    optional).
- Optional:
  - `--source-repo <OWNER/REPO>` — source repo holding the release artifacts
    (default: workflow default, `sympoies/nils-cli`).
  - `--ref <ref>` — branch/ref to run the workflow on (default: `main`).
  - `--watch` — stream the dispatched run to completion after triggering.
  - `--dry-run` — print the `gh` command without dispatching.

Outputs:

- Dispatches `update-nils-cli-formula.yml`, which rewrites `Formula/nils-cli.rb`
  from the published release artifacts, runs `brew test` on macOS + Linux,
  commits the bump via the GitHub Contents API (web-flow signed, satisfying the
  `required_signatures` ruleset on `main`), and creates the `nils-cli-v<version>`
  tap release.

Exit codes:

- `0`: success
- `1`: failure (missing `gh`, run outside the tap work tree, or dispatch failure)
- `2`: usage error (missing/invalid `--version` or `--source-repo`)

Failure modes:

- Missing `gh`, or running outside the tap work tree.
- Invalid `--version` / `--source-repo`.
- Source release artifacts not yet published — the dispatched workflow fails
  while fetching the `.sha256` sidecars; re-run once the release is ready.

## Scripts (only entrypoints)

- `<PROJECT_ROOT>/.agents/skills/project-release-nils-cli/scripts/project-release-nils-cli.sh`

## Workflow

1. Run the wrapper entrypoint with `--version` (optionally `--source-repo`,
   `--ref`, `--watch`).
2. The wrapper runs `gh workflow run update-nils-cli-formula.yml --ref <ref>
   -f version=<X.Y.Z> [-f source_repo=<OWNER/REPO>]`.
3. GitHub Actions updates the formula, runs `brew test`, commits the bump, and
   publishes the tap release.
