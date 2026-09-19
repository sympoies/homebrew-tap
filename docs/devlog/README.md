# Development log

A time-ordered narrative of notable work on the Sympoies Homebrew tap: what
changed, why it mattered, the evidence, and links worth keeping for future
debugging. It complements, rather than duplicates, the repository's other
records:

- Commit messages say what changed. The devlog preserves the non-obvious
  context, validation results, and external references that a diff cannot.
- `README.md` and `DEVELOPMENT.md` describe the current packaging contract.
  The devlog is an append-only historical narrative; update the canonical
  current document first when behavior or guidance changes.
- Upstream releases and generated bumps retain delivery detail. The devlog
  summarizes changes to the tap's durable package and automation boundaries.

## When to add an entry

Add one after non-trivial development work produces a durable outcome worth
future lookup: a new formula or cask family, an update-workflow contract, a
validated packaging milestone, a security decision, or an incident-relevant
finding. Skip routine generated version bumps and same-turn fixes with no
future debugging or decision value.

## Conventions

- One file per month: `docs/devlog/YYYY-MM.md`, with the newest entry on top.
- Write in English, like the rest of the repository.
- Keep current docs current. The devlog records history; it does not own the
  current formula, cask, workflow, release, or installation contract.
- This is a public repository. Never record secrets, private skill contents,
  personal identifiers, internal hostnames, private deployment topology,
  machine-local paths, or credentials. Use public references and neutral
  descriptions.
- Search past entries with `devlog search <term> [--month YYYY-MM]`. The
  `devlog` binary ships with `nils-cli`; without it, search the month files
  directly.
- When an entry is committed separately, use
  `docs(devlog): <YYYY-MM> - <subject>`.

### Entry template

```md
## YYYY-MM-DD - <short title>

### Result

- What shipped or changed.

### Why / context

- The non-obvious reasoning or compatibility context.

### Evidence

- Commands run and concrete observations.

### Links

- Commits, issues, pull requests, external references, and relevant docs.

### Follow-ups

- Optional.
```

`Result`, `Why / context`, and `Evidence` are required. `Links` and
`Follow-ups` are optional: omit the whole section rather than leaving a
placeholder in it.

## Months

- [2026-09](2026-09.md)
- [2026-08](2026-08.md)
- [2026-06](2026-06.md)
- [2026-05](2026-05.md)
- [2026-02](2026-02.md)
