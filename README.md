# Sympoies Homebrew tap

## Formula overview

| Formula | Description | Source git repo |
| --- | --- | --- |
| `nils-cli` | Rust workspace of focused CLI binaries for API testing, Git operations, agent workflow evidence, provider automation, planning, and desktop/media utilities. | [sympoies/nils-cli](https://github.com/sympoies/nils-cli) |
| `nils-alfred-cli` | Standalone CLI bundle extracted from nils-alfredworkflow for terminal use without Alfred. | [sympoies/nils-alfredworkflow](https://github.com/sympoies/nils-alfredworkflow) |

## nils-cli

A Rust workspace of focused CLI binaries. Each binary is independently installable from a single Homebrew formula — shared crates keep JSON contracts, terminal UX, and cross-CLI behavior consistent.

Source git repo: [sympoies/nils-cli](https://github.com/sympoies/nils-cli)

### Install

```bash
brew tap sympoies/tap
brew install nils-cli
```

### CLI surface map

Aligned with the upstream surface map, limited to the binaries this formula ships. Use this table to choose the right binary; every entry below is shipped by the formula and installed onto `PATH`.

| Area | Binaries | Use when |
| --- | --- | --- |
| API testing | `api-rest`, `api-gql`, `api-grpc`, `api-websocket`, `api-test` | Run protocol-specific API checks or orchestrate a mixed API test suite. |
| Git tooling | `git-scope`, `git-cli`, `git-summary`, `git-lock` | Inspect changes, run Git helper flows, summarize commits, or manage repo-local commit locks. |
| Forge automation | `forge-cli` | Drive PR/MR + Issue lifecycle and repository label catalog maintenance on GitHub (`gh`) or GitLab (`glab`) through a single provider-neutral surface — create / view / edit / comment / ready / merge / close, label list / audit / ensure, CI wait-checks, and the `pr deliver` macro. |
| Agent policy and evidence | `agent-runtime`, `agent-docs`, `agent-out`, `agent-scope-lock`, `agent-run`, `test-first-evidence`, `web-evidence`, `browser-session`, `canary-check`, `docs-impact`, `heuristic-inbox`, `model-cross-check`, `repo-retro`, `review-evidence`, `review-specialists`, `skill-usage` | Render/install/audit runtime-kit surfaces, resolve agent policy docs, run project commands through explicit env handling, allocate artifact paths, enforce edit scope, generate repo retrospectives, merge specialist review evidence, or persist deterministic workflow evidence. |
| Planning and delivery | `plan-tooling`, `plan-issue`, `plan-issue-local`, `plan-archive`, `semantic-commit` | Validate/split implementation plans, orchestrate issue delivery, rehearse local plan flows, archive closed plan folders, or create semantic commits. |
| Provider lanes | `codex-cli`, `gemini-cli` | Provider-specific diagnostics, auth checks, and workflow adapters. |
| Desktop, media, and local utilities | `macos-agent`, `screen-record`, `image-processing`, `fzf-cli`, `memo-cli` | Automate local desktop tasks, capture media, batch-convert images, use interactive shell helpers, or record/search local memos. |
| Development-only / internal | `cli-template` | Internal scaffolding to validate packaging and new-crate patterns — excluded from user-facing completion obligations. |

### Per-binary one-liners

#### API testing stack

- `api-rest` — REST request runner from JSON request specs, with history + Markdown reports.
- `api-gql` — GraphQL operation runner for `.graphql` files (variables, history, reports, schema).
- `api-grpc` — gRPC request runner from JSON specs, with history + Markdown reports.
- `api-websocket` — Deterministic WebSocket request runner with history + Markdown reports.
- `api-test` — Suite runner that orchestrates REST/GraphQL/gRPC/WebSocket cases and emits JSON (and optional JUnit).

#### Git tooling

- `git-scope` — Git change inspector (tracked/staged/unstaged/untracked/commit) with tree + optional file printing.
- `git-cli` — Git tools dispatcher (utils/reset/commit/branch/ci/open).
- `git-summary` — Per-author contribution summaries over a date range (adds/dels/net/commits).
- `git-lock` — Label-based commit locks per repo (lock/list/diff/unlock/tag).

#### Forge automation

- `forge-cli` — Provider-neutral CLI for remote forge operations; wraps `gh` and `glab` behind one PR/MR + Issue lifecycle and repository label catalog surface.

#### Agent policy and evidence

- `agent-runtime` — Render / install / doctor / audit-drift for graysurf/agent-runtime-kit, plus runtime-state maintenance, skill listing, and PR/MR body rendering.
- `agent-docs` — Deterministic policy-document resolver for agent workflows (`resolve`, `contexts`, `add`, `baseline`).
- `agent-out` — Generate and audit canonical `AGENT_HOME/out` artifact paths.
- `agent-scope-lock` — Create and validate deterministic agent edit-scope locks.
- `agent-run` — Run project build/test/validation commands through a normalized, direnv-aware project environment (`exec`, `doctor`, `env`).
- `test-first-evidence` — Record test-first evidence and waivers for agent workflows.
- `web-evidence` — Capture redacted static HTTP evidence for agent workflows.
- `browser-session` — Record browser QA goals, steps, artifacts, and verification status.
- `canary-check` — Run a local command as a canary and persist redacted run evidence.
- `docs-impact` — Scan Git changes and classify whether implementation work needs documentation updates.
- `heuristic-inbox` — Manage curated HEURISTIC_SYSTEM error-inbox and operation-record case folders.
- `model-cross-check` — Persist primary/checker model observations and verification status without invoking providers.
- `repo-retro` — Generate source-grounded repository retrospectives from Git history and optional evidence inputs.
- `review-evidence` — Persist review findings, validation commands, artifacts, and verification status.
- `review-specialists` — Deterministic primitive for code-review-specialists workflows (`validate`, `merge`, `render`, `bundle`, `scope`); never runs reviewers or posts comments.
- `skill-usage` — Record skill invocation intent, linked evidence, validation, failures, and outcome.

#### Planning and delivery

- `plan-tooling` — Plan Format v1 tooling (`to-json`, `validate`, `batches`, `split-prs`, `scaffold`, `completion`).
- `plan-issue`, `plan-issue-local` — Plan-issue orchestration for build/start/status/ready/accept/close workflows plus completion export.
- `plan-archive` — Migrate closed plan folders into the agent-plan-archive repo and scan/validate candidates (`discover`, `migrate`, `refresh`, `validate-*`); dry-run by default.
- `semantic-commit` — Helper CLI for generating staged context and creating semantic commits.

#### Provider lanes

- `codex-cli` — Provider-specific CLI for OpenAI / Codex workflows (auth, diagnostics, execution wrappers, Starship).
- `gemini-cli` — Provider-specific CLI lane for Gemini workflows.

#### Desktop, media, and local utilities

- `macos-agent` — macOS desktop automation primitives (app/window discovery, input actions, screenshot, wait helpers).
- `screen-record` — macOS ScreenCaptureKit + Linux (X11) recorder for a single window or display with optional audio.
- `image-processing` — Batch image transformation (resize/crop/optimize) with JSON / Markdown reports.
- `fzf-cli` — Interactive `fzf` toolbox for files, Git, processes, ports, and shell history.
- `memo-cli` — Capture-first memo workflow with agent enrichment loop (`add`, `list`, `search`, `report`, `fetch`, `apply`).

#### Development-only / internal

- `cli-template` — Minimal example CLI used to validate packaging and new-crate patterns.

### Shell completions and aliases

The formula installs Zsh and Bash completion files for every CLI listed above, plus an opt-in aliases file for each shell.

#### Zsh

Completions are dropped into `$(brew --prefix)/share/zsh/site-functions/` and load automatically once `compinit` runs. To opt into the aliases file (`gs*` / `cx* `/ `fx*` shortcuts), add this to `~/.zshrc`:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh" ]]; then
  source "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh"
fi
```

#### Bash

1) Enable Homebrew bash-completion (macOS / Linuxbrew):

```bash
brew install bash-completion@2
```

Then add this to your `~/.bashrc` (or `~/.bash_profile`):

```bash
# Homebrew bash completion
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
  [[ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi
```

2) (Optional) Enable the `nils-cli` Bash aliases:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash" ]]; then
  source "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash"
fi
```

## nils-alfred-cli

`nils-alfred-cli` is generated from
[sympoies/nils-alfredworkflow](https://github.com/sympoies/nils-alfredworkflow)
release assets after upstream `v*` tags publish standalone CLI tarballs.

### Install

```bash
brew tap sympoies/tap
brew install sympoies/tap/nils-alfred-cli
```

### Included binaries

The upstream release manifest controls the installed binary list. Current
bundle policy includes standalone-ready public/local/product CLIs such as
`weather-cli`, `google-cli`, `memo-workflow-cli`, `workflow-cli`,
`workflow-readme-cli`, `steam-cli`, `market-cli`, `epoch-cli`,
`timezone-cli`, `randomer-cli`, `wiki-cli`, `quote-cli`, `bilibili-cli`, and
`bangumi-cli`.

The first generated formula appears after an upstream release dispatches
`nils-alfred-cli-release`; until then this tap may only contain the update
workflow.

## Install (script)

The install script supports macOS and Linux. It will install Homebrew (Linuxbrew on Linux) if missing.

From a cloned repo:

```bash
bash scripts/install.sh
```

One-liner (review before running):

```bash
curl -fsSL https://raw.githubusercontent.com/sympoies/homebrew-tap/main/scripts/install.sh | bash
```

## Upgrade

```bash
brew upgrade nils-cli
```

## CI

- macOS workflow: `.github/workflows/ci-macos.yml`
- Linux workflow: `.github/workflows/ci-linux.yml`
- Shared workflow: `.github/workflows/brew-test.yml`
