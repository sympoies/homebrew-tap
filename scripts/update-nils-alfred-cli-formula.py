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


def parse_sha256(values: list[str]) -> dict[str, str]:
    parsed: dict[str, str] = {}
    for value in values:
        target, sep, digest = value.partition("=")
        if sep != "=":
            raise SystemExit(f"error: --sha256 must use target=digest: {value!r}")
        target = target.strip()
        digest = digest.strip()
        if target not in TARGETS:
            raise SystemExit(f"error: unsupported target in --sha256: {target!r}")
        if not re.fullmatch(r"[0-9a-f]{64}", digest):
            raise SystemExit(f"error: invalid sha256 for {target}: {digest!r}")
        parsed[target] = digest

    if parsed and set(parsed) != set(TARGETS):
        missing = ", ".join(sorted(set(TARGETS) - set(parsed)))
        raise SystemExit(f"error: --sha256 must provide all targets; missing: {missing}")
    return parsed


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


def render_url_block(
    source_repo: str,
    package: str,
    version: str,
    target: str,
    digest: str,
    indent: str,
) -> str:
    return (
        f'{indent}url "https://github.com/{source_repo}/releases/download/v{version}/'
        f'{package}-v{version}-{target}.tar.gz"\n'
        f'{indent}sha256 "{digest}"'
    )


def render_formula(
    source_repo: str,
    package: str,
    version: str,
    sha_by_target: dict[str, str],
) -> str:
    return f'''class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/{source_repo}"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
{render_url_block(source_repo, package, version, "aarch64-apple-darwin", sha_by_target["aarch64-apple-darwin"], "      ")}
    else
{render_url_block(source_repo, package, version, "x86_64-apple-darwin", sha_by_target["x86_64-apple-darwin"], "      ")}
    end
  end

  on_linux do
    if Hardware::CPU.arm?
{render_url_block(source_repo, package, version, "aarch64-unknown-linux-gnu", sha_by_target["aarch64-unknown-linux-gnu"], "      ")}
    else
{render_url_block(source_repo, package, version, "x86_64-unknown-linux-gnu", sha_by_target["x86_64-unknown-linux-gnu"], "      ")}
    end
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install "README.md"
    pkgshare.install "MANIFEST.tsv"
    pkgshare.install "docs"
    pkgshare.install "THIRD_PARTY_LICENSES.md"
    pkgshare.install "THIRD_PARTY_NOTICES.md"
  end

  test do
    system "{{bin}}/weather-cli", "--help"
    system "{{bin}}/workflow-readme-cli", "--help"
    system "{{bin}}/memo-workflow-cli", "--help"
  end
end
'''


def write_formula(formula_path: Path, text: str) -> bool:
    current = formula_path.read_text("utf-8") if formula_path.exists() else ""
    if current == text:
        return False
    formula_path.parent.mkdir(parents=True, exist_ok=True)
    formula_path.write_text(text, "utf-8")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Create or update the nils-alfred-cli Homebrew formula.")
    parser.add_argument("--formula", default="Formula/nils-alfred-cli.rb")
    parser.add_argument("--source-repo", default="sympoies/nils-alfredworkflow")
    parser.add_argument("--package", default="nils-alfred-cli")
    parser.add_argument("--version", required=True)
    parser.add_argument(
        "--sha256",
        action="append",
        default=[],
        help="Use an explicit target=digest instead of fetching release sidecars. Must be provided for all targets.",
    )
    args = parser.parse_args()

    formula_path = Path(args.formula)
    source_repo = validate_source_repo(args.source_repo)
    version = normalize_version(args.version)
    sha_by_target = parse_sha256(args.sha256)
    if not sha_by_target:
        sha_by_target = {
            target: fetch_sha256(source_repo, args.package, version, target)
            for target in TARGETS
        }

    formula = render_formula(source_repo, args.package, version, sha_by_target)
    changed = write_formula(formula_path, formula)

    state = "updated" if changed else "already-current"
    print(f"{state}: {formula_path} -> {source_repo} v{version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
