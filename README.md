# sympoies Homebrew tap

## Formula overview

| Formula | Description | Source git repo |
| --- | --- | --- |
| `nils-cli` | Rust workspace of focused CLI binaries for Git operations, API test orchestration, and workflow automation. | [sympoies/nils-cli](https://github.com/sympoies/nils-cli) |
| `agent-workspace-launcher` | Host-native workspace lifecycle CLI for repository-focused development. | [graysurf/agent-workspace-launcher](https://github.com/graysurf/agent-workspace-launcher) |

## nils-cli

A Rust workspace of focused CLI binaries for Git operations, API test orchestration, and workflow automation.
Source git repo: [sympoies/nils-cli](https://github.com/sympoies/nils-cli)

### Included CLIs

#### API testing stack

- `api-rest`: REST request runner from file-based JSON specs, with history + Markdown reports.
- `api-gql`: GraphQL operation runner for `.graphql` files (variables, history, reports, schema).
- `api-grpc`: gRPC request runner from JSON specs, with history + Markdown reports.
- `api-websocket`: Deterministic WebSocket request runner with history + Markdown reports.
- `api-test`: Suite runner that orchestrates REST/GraphQL/gRPC/WebSocket cases and outputs JSON (and optional JUnit).

#### Git tooling

- `git-scope`: Git change inspector (tracked/staged/unstaged/untracked/commit) with tree + optional file printing.
- `git-cli`: Git tools dispatcher (utils/reset/commit/branch/ci/open).
- `git-summary`: Per-author contribution summaries over a date range (adds/dels/net/commits).
- `git-lock`: Label-based commit locks per repo (lock/list/diff/unlock/tag).

#### Agent and workflow tooling

- `agent-docs`: Deterministic policy-document resolver for agent workflows (`resolve`, `contexts`, `add`, `baseline`).
- `codex-cli`: Provider-specific CLI for OpenAI/Codex workflows (auth, diagnostics, execution wrappers, Starship).
- `gemini-cli`: Provider-specific CLI lane for Gemini workflows.
- `semantic-commit`: Helper CLI for generating staged context and creating semantic commits.
- `plan-tooling`: Plan Format v1 tooling CLI (`to-json`, `validate`, `batches`, `split-prs`, `scaffold`, `completion`).
- `plan-issue`, `plan-issue-local`: Plan issue orchestration CLIs for build/start/status/ready/accept/close workflows plus completion export.

#### Automation and utility CLIs

- `macos-agent`: macOS desktop automation primitives for app/window discovery, input actions, screenshot, and wait helpers.
- `fzf-cli`: Interactive `fzf` toolbox for files, Git, processes, ports, and shell history.
- `memo-cli`: Capture-first memo workflow CLI with agent enrichment loop (`add`, `list`, `search`, `report`, `fetch`, `apply`).
- `image-processing`: Batch image transformation CLI (resize/crop/optimize) with JSON/report outputs.
- `screen-record`: macOS ScreenCaptureKit + Linux (X11) recorder for a single window or display with optional audio.

## Install

```bash
brew tap sympoies/tap
brew install nils-cli
```

## agent-workspace-launcher

Host-native workspace lifecycle CLI for repository-focused development.
Source git repo: [graysurf/agent-workspace-launcher](https://github.com/graysurf/agent-workspace-launcher)

Main subcommands:

- `auth`
- `create`
- `ls`
- `rm`
- `exec`
- `reset`
- `tunnel`

Install:

```bash
brew tap sympoies/tap
brew install agent-workspace-launcher
```

Optional zsh wrapper source:

```bash
source "$(brew --prefix agent-workspace-launcher)/share/agent-workspace-launcher/awl.zsh"
```

## Zsh aliases (optional)

`nils-cli` ships an opt-in Zsh aliases file (designed to avoid clobbering user-defined aliases/functions).

After `brew install nils-cli`, add this to your `~/.zshrc`:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh" ]]; then
  source "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh"
fi
```

## Bash completion + aliases (optional)

`nils-cli` ships Bash completion scripts for each CLI, plus an opt-in Bash aliases file (for `gs*`/`cx*`/`fx*`).

1) Enable Homebrew bash-completion (macOS/Linuxbrew):

```bash
brew install bash-completion@2
```

Then add this to your `~/.bashrc` (or `~/.bash_profile`, depending on your setup):

```bash
# Homebrew bash completion
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
  [[ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi
```

2) (Optional) Enable `nils-cli` Bash aliases:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash" ]]; then
  source "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash"
fi
```

## Install (Script)

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
brew upgrade agent-workspace-launcher
```

## CI

- macOS workflow: `.github/workflows/ci-macos.yml`
- Linux workflow: `.github/workflows/ci-linux.yml`
- Shared workflow: `.github/workflows/brew-test.yml`
