#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_root="$(cd "${script_dir}/.." && pwd)"
entrypoint="${skill_root}/scripts/project-release-nils-cli.sh"

if [[ ! -f "${skill_root}/SKILL.md" ]]; then
  echo "error: missing SKILL.md" >&2
  exit 1
fi
if [[ ! -f "$entrypoint" ]]; then
  echo "error: missing scripts/project-release-nils-cli.sh" >&2
  exit 1
fi
if [[ ! -x "$entrypoint" ]]; then
  echo "error: entrypoint is not executable: $entrypoint" >&2
  exit 1
fi

# Help references the dispatch workflow.
help_out="$(bash "$entrypoint" --help)"
if [[ "$help_out" != *"update-nils-cli-formula.yml"* ]]; then
  echo "error: help output missing workflow reference" >&2
  exit 1
fi

# Missing --version is a usage error (exit 2).
set +e
bash "$entrypoint" >/dev/null 2>&1
status=$?
set -e
if [[ "$status" -ne 2 ]]; then
  echo "error: expected missing --version to fail with exit 2; got $status" >&2
  exit 1
fi

# Invalid --version is a usage error (exit 2).
set +e
bash "$entrypoint" --version not-a-version >/dev/null 2>&1
status=$?
set -e
if [[ "$status" -ne 2 ]]; then
  echo "error: expected invalid --version to fail with exit 2; got $status" >&2
  exit 1
fi

# Dry-run prints the gh command without dispatching.
dry_out="$(bash "$entrypoint" --version v9.9.9 --dry-run)"
if [[ "$dry_out" != *"gh workflow run"* \
   || "$dry_out" != *"update-nils-cli-formula.yml"* \
   || "$dry_out" != *"version=9.9.9"* ]]; then
  echo "error: dry-run output missing expected gh command: $dry_out" >&2
  exit 1
fi

echo "ok: project skill smoke checks passed"
