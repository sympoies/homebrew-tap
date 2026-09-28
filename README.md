# Sympoies Homebrew tap

Homebrew packages for Sympoies command-line tools and Symphony Board macOS apps.
The applications and release assets are maintained in their upstream repositories;
this tap provides their Homebrew formulae and casks.

## Packages

| Package | What it installs | Source |
| --- | --- | --- |
| `nils-cli` | CLI tools for API testing, Git, agent workflows, and desktop/media tasks | [sympoies/nils-cli](https://github.com/sympoies/nils-cli) |
| `nils-alfred-cli` | Standalone command-line tools from nils-alfredworkflow; Alfred is not required | [sympoies/nils-alfredworkflow](https://github.com/sympoies/nils-alfredworkflow) |
| `symphony-board` | Mac desktop client that connects to a running Symphony Board server | [sympoies/symphony-board](https://github.com/sympoies/symphony-board) |
| `symphony-board-standalone` | Mac desktop app with a bundled backend | [sympoies/symphony-board](https://github.com/sympoies/symphony-board) |

Both CLI formulae support macOS and Linux on ARM and Intel/AMD systems.
The Symphony Board casks require an Apple Silicon Mac running macOS Big Sur or
later.

## Install

[Install Homebrew](https://brew.sh/) first, then add this tap and install the
package you want:

```bash
brew tap sympoies/tap
```

For `nils-cli`:

```bash
brew install sympoies/tap/nils-cli
```

For `nils-alfred-cli`:

```bash
brew install sympoies/tap/nils-alfred-cli
```

For Symphony Board, install the client if you already run a server:

```bash
brew install --cask sympoies/tap/symphony-board
```

Or install the standalone app if you want the bundled backend:

```bash
brew install --cask sympoies/tap/symphony-board-standalone
```

The cask apps are unsigned and not notarized. If macOS blocks one after
installation, review the app's [release](https://github.com/sympoies/symphony-board/releases)
and follow the quarantine instructions shown by `brew info --cask` for that
package.

## Try a CLI

The formulae install individual commands on `PATH`, rather than a command named
after each formula. For example:

```bash
git-scope --help     # nils-cli
weather-cli --help   # nils-alfred-cli
```

See the upstream [nils-cli](https://github.com/sympoies/nils-cli) and
[nils-alfredworkflow](https://github.com/sympoies/nils-alfredworkflow)
repositories for their current command lists and usage. The `nils-cli` formula
also installs Zsh and Bash completions and optional shell aliases.

## Upgrade

Run the command for the package you installed. For `nils-cli`:

```bash
brew upgrade sympoies/tap/nils-cli
```

For `nils-alfred-cli`:

```bash
brew upgrade sympoies/tap/nils-alfred-cli
```

For the Symphony Board client:

```bash
brew upgrade --cask sympoies/tap/symphony-board
```

For the standalone app:

```bash
brew upgrade --cask sympoies/tap/symphony-board-standalone
```

For tap maintenance and validation, see [DEVELOPMENT.md](DEVELOPMENT.md).
