#!/usr/bin/env bash
set -euo pipefail

WORKFLOW="update-nils-cli-formula.yml"

usage() {
  cat <<'USAGE'
Usage:
  project-release-nils-cli.sh --version <X.Y.Z|vX.Y.Z> [options]

Release `nils-cli` by dispatching this tap's GitHub Actions release workflow
(.github/workflows/update-nils-cli-formula.yml). The workflow rewrites
Formula/nils-cli.rb from the published release artifacts, runs `brew test` on
macOS + Linux, commits the bump via the GitHub Contents API (web-flow signed,
so it satisfies the `required_signatures` ruleset on main), and creates the
`nils-cli-v<version>` tap release.

Options:
  --version <X.Y.Z>     Required. nils-cli version to publish (leading `v` optional).
  --source-repo <O/R>   Source repo holding the release artifacts
                        (default: workflow default, sympoies/nils-cli).
  --ref <ref>           Branch/ref to run the workflow on (default: main).
  --watch               After dispatching, stream the run to completion.
  --dry-run             Print the `gh` command without dispatching.
  -h, --help            Show this help.

Notes:
  - The normal release path is automatic: the nils-cli release pipeline sends a
    `repository_dispatch` (nils-cli-release) to this tap. Use this skill only to
    manually (re)publish a specific version.
  - Run inside the homebrew-tap work tree; `gh` resolves the repo from the
    remote. Requires `gh` authenticated with Actions (workflow) write scope.

Exit codes:
  0  success
  1  failure
  2  usage error
USAGE
}

version=""
source_repo=""
ref="main"
watch="false"
dry_run="false"

while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    --version)
      [[ $# -ge 2 ]] || { echo "error: --version requires a value" >&2; exit 2; }
      version="$2"
      shift 2
      ;;
    --source-repo)
      [[ $# -ge 2 ]] || { echo "error: --source-repo requires a value" >&2; exit 2; }
      source_repo="$2"
      shift 2
      ;;
    --ref)
      [[ $# -ge 2 ]] || { echo "error: --ref requires a value" >&2; exit 2; }
      ref="$2"
      shift 2
      ;;
    --watch)
      watch="true"
      shift
      ;;
    --dry-run)
      dry_run="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: ${1:-}" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$version" ]]; then
  echo "error: --version is required" >&2
  usage >&2
  exit 2
fi

version="${version#v}"
if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: invalid version (expected X.Y.Z): $version" >&2
  exit 2
fi

if [[ -n "$source_repo" ]] && ! [[ "$source_repo" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  echo "error: invalid --source-repo (expected OWNER/REPO): $source_repo" >&2
  exit 2
fi

cmd=(gh workflow run "$WORKFLOW" --ref "$ref" -f "version=$version")
if [[ -n "$source_repo" ]]; then
  cmd+=(-f "source_repo=$source_repo")
fi

if [[ "$dry_run" == "true" ]]; then
  printf '%q ' "${cmd[@]}"
  printf '\n'
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh is required" >&2
  exit 1
fi

if [[ ! -f ".github/workflows/${WORKFLOW}" ]]; then
  echo "error: run inside the homebrew-tap work tree (.github/workflows/${WORKFLOW} not found)" >&2
  exit 1
fi

"${cmd[@]}"
echo "ok: dispatched ${WORKFLOW} for nils-cli v${version} (ref ${ref})"

if [[ "$watch" == "true" ]]; then
  # Give the dispatched run a moment to register before resolving its id.
  sleep 4
  run_id="$(gh run list --workflow "$WORKFLOW" --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)"
  if [[ -n "$run_id" ]]; then
    echo "ok: watching run ${run_id}"
    gh run watch "$run_id" --exit-status
  else
    echo "warn: could not resolve dispatched run id; check 'gh run list --workflow ${WORKFLOW}'" >&2
  fi
fi
