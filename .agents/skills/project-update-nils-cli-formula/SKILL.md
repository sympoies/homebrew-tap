---
name: project-update-nils-cli-formula
description: Recover a missed or failed nils-cli formula update in this tap through the sympoies-infra release broker; the tap workflow is not dispatched by hand.
---

# Homebrew Tap Update Nils Cli Formula

The `nils-cli` formula is updated by `.github/workflows/update-nils-cli-formula.yml`.

- Normal path: the nils-cli release sends a `nils-cli-release`
  `repository_dispatch` to this tap and the workflow rewrites
  `Formula/nils-cli.rb`, runs `brew test`, commits the bump, and creates the
  tap release. Nothing to do by hand.
- Recovery path (missed or failed tap update for an existing public tag): the
  private release broker is the supported owner. Use the
  `project-release-nils-cli` skill in `serenvia/sympoies-infra` with
  `--mode deploy-only --version X.Y.Z`; its bounded exact-run tap recovery
  dispatches this workflow.

## Why not dispatch by hand

The workflow's manual `workflow_dispatch` requires `expected_workflow_sha`, the
exact tap `main` commit inspected by the broker. The workflow compares it with
`GITHUB_SHA` before checkout so a branch race stops before formula generation or
any repository write. Do not run `gh workflow run update-nils-cli-formula.yml`
with a self-chosen SHA; that bypasses the broker's inspection and the guard it
exists to enforce.

## Changing the workflow

Follow `DEVELOPMENT.md` (formula style, `brew test`) and keep the
`expected_workflow_sha` guard intact.
