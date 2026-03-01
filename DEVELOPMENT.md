# DEVELOPMENT.md

## Setup

Run from repository root:

```bash
command -v brew >/dev/null 2>&1
brew tap sympoies/tap
```

## Build

Validate formula structure and style:

```bash
ruby -c Formula/nils-cli.rb
HOMEBREW_NO_AUTO_UPDATE=1 brew style Formula/nils-cli.rb

ruby -c Formula/agent-workspace-launcher.rb
HOMEBREW_NO_AUTO_UPDATE=1 brew style Formula/agent-workspace-launcher.rb
```

## Test

Default (CI-aligned) verification:

```bash
brew tap sympoies/tap
brew update-reset "$(brew --repo sympoies/tap)"
HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall nils-cli || HOMEBREW_NO_AUTO_UPDATE=1 brew install nils-cli
HOMEBREW_NO_AUTO_UPDATE=1 brew test nils-cli

HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall agent-workspace-launcher || HOMEBREW_NO_AUTO_UPDATE=1 brew install agent-workspace-launcher
HOMEBREW_NO_AUTO_UPDATE=1 brew test agent-workspace-launcher
```

## Local Development Test (Optional)

Use this only when testing unpublished formula changes during development.

```bash
brew tap sympoies/tap "$(pwd)" --custom-remote
brew update-reset "$(brew --repo sympoies/tap)"
HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall nils-cli || HOMEBREW_NO_AUTO_UPDATE=1 brew install nils-cli
HOMEBREW_NO_AUTO_UPDATE=1 brew test nils-cli

HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall agent-workspace-launcher || HOMEBREW_NO_AUTO_UPDATE=1 brew install agent-workspace-launcher
HOMEBREW_NO_AUTO_UPDATE=1 brew test agent-workspace-launcher
```

## Notes

- CI reference: `.github/workflows/brew-test.yml`
- `brew update-reset "$(brew --repo sympoies/tap)"` ensures local tap checkout is synced.
- Local custom-remote tap reads committed git history; uncommitted changes are not included.
