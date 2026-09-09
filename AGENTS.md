# Repository policy

## Scope

This repository owns the public Homebrew formulae and casks published through
`sympoies/tap`. Product implementation and release artifacts remain in their
upstream application repositories.

## Boundaries

- Keep formula and cask definitions reproducible from immutable public release
  artifacts and their published checksums.
- Do not commit credentials, signing material, provider payloads, local
  Homebrew state, generated bottles, or release artifacts.
- Keep update workflows least-authority and race-safe. Manual recovery must
  retain its expected-commit guard; generated updates must remain attributable
  to the owning upstream release.
- Do not move application build, test, release, or deployment logic into this
  tap. This repository validates packaging and installation only.

## Working agreement

- Read [`DEVELOPMENT.md`](DEVELOPMENT.md) for setup, formula/cask validation,
  installation tests, and workflow-specific maintenance notes.
- Inspect the affected definition, generator, tests, and provider workflow
  together. Preserve existing package names, artifact identities, and install
  surfaces unless a coordinated upstream release changes them.
- Run the focused syntax/style checks and affected repository tests before
  delivery. Installation acceptance remains platform-specific.
- Deliver tracked changes through the governed managed-worktree and PR flow.
- Keep committed repository content in English.
