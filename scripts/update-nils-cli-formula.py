#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
import urllib.request
from pathlib import Path


TARGETS = (
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
)


def normalize_version(value: str) -> str:
    version = value.strip()
    if version.startswith("v"):
        version = version[1:]
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise SystemExit(f"error: invalid version: {value!r}")
    return version


def validate_source_repo(value: str) -> str:
    source_repo = value.strip()
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", source_repo):
        raise SystemExit(f"error: invalid source repo: {value!r}")
    return source_repo


def fetch_sha256(source_repo: str, package: str, version: str, target: str) -> str:
    url = (
        f"https://github.com/{source_repo}/releases/download/v{version}/"
        f"{package}-v{version}-{target}.tar.gz.sha256"
    )
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            body = response.read().decode("utf-8")
    except Exception as exc:
        raise SystemExit(f"error: failed to fetch sha256 sidecar: {url}: {exc}") from exc

    digest = body.split(None, 1)[0] if body.split() else ""
    if not re.fullmatch(r"[0-9a-f]{64}", digest):
        raise SystemExit(f"error: invalid sha256 from {url}: {digest!r}")
    return digest


def update_formula(
    formula_path: Path,
    source_repo: str,
    package: str,
    version: str,
    sha_by_target: dict[str, str],
) -> bool:
    text = formula_path.read_text("utf-8")
    lines = text.splitlines()
    url_pattern = re.compile(
        rf'^(?P<indent>\s*)url\s+"https://github\.com/'
        rf'(?P<origin>[^/"]+/[^/"]+)/releases/download/v[0-9.]+/'
        rf'{re.escape(package)}-v[0-9.]+-(?P<target>[^/"]+)\.tar\.gz"\s*$'
    )
    sha_pattern = re.compile(r'^(?P<indent>\s*)sha256\s+"[0-9a-f]+"\s*$')

    out: list[str] = []
    pending_target: str | None = None
    seen_targets: set[str] = set()

    for line in lines:
        url_match = url_pattern.match(line)
        if url_match:
            target = url_match.group("target")
            if target not in sha_by_target:
                raise SystemExit(f"error: unsupported target in formula URL: {target}")
            seen_targets.add(target)
            pending_target = target
            out.append(
                f'{url_match.group("indent")}url '
                f'"https://github.com/{source_repo}/releases/download/v{version}/'
                f'{package}-v{version}-{target}.tar.gz"'
            )
            continue

        sha_match = sha_pattern.match(line)
        if sha_match and pending_target is not None:
            out.append(f'{sha_match.group("indent")}sha256 "{sha_by_target[pending_target]}"')
            pending_target = None
            continue

        out.append(line)

    missing = sorted(set(sha_by_target) - seen_targets)
    if missing:
        raise SystemExit(f"error: formula is missing target URLs: {', '.join(missing)}")

    new_text = "\n".join(out)
    if text.endswith("\n"):
        new_text += "\n"

    if new_text == text:
        return False

    formula_path.write_text(new_text, "utf-8")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Update the nils-cli Homebrew formula.")
    parser.add_argument("--formula", default="Formula/nils-cli.rb")
    parser.add_argument("--source-repo", default="sympoies/nils-cli")
    parser.add_argument("--package", default="nils-cli")
    parser.add_argument("--version", required=True)
    args = parser.parse_args()

    formula_path = Path(args.formula)
    source_repo = validate_source_repo(args.source_repo)
    version = normalize_version(args.version)

    sha_by_target = {
        target: fetch_sha256(source_repo, args.package, version, target)
        for target in TARGETS
    }
    changed = update_formula(formula_path, source_repo, args.package, version, sha_by_target)

    state = "updated" if changed else "already-current"
    print(f"{state}: {formula_path} -> {source_repo} v{version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
