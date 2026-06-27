#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
import urllib.request
from dataclasses import dataclass
from pathlib import Path


ARCH_LABEL = "macos-arm64"


@dataclass(frozen=True)
class CaskSpec:
    token: str
    app_name: str
    asset_prefix: str
    desc: str
    caveat_extra: str = ""

    @property
    def filename(self) -> str:
        return f"{self.token}.rb"

    @property
    def zip_app_name(self) -> str:
        return f"{self.app_name}.app"

    def asset_name(self, version: str) -> str:
        return f"{self.asset_prefix}-v{version}-{ARCH_LABEL}-unsigned.zip"


CASKS = (
    CaskSpec(
        token="symphony-board",
        app_name="Symphony Board",
        asset_prefix="Symphony-Board",
        desc="Read-only desktop client for Symphony Board",
        caveat_extra=(
            "\n"
            "    The thin client requires a running Symphony Board server. Configure the server URL in Settings.\n"
        ),
    ),
    CaskSpec(
        token="symphony-board-standalone",
        app_name="Symphony Board Standalone",
        asset_prefix="Symphony-Board-Standalone",
        desc="Self-contained desktop app for Symphony Board",
    ),
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


def parse_sha256_sums(body: str) -> dict[str, str]:
    digests: dict[str, str] = {}
    for line in body.splitlines():
        fields = line.split()
        if len(fields) < 2:
            continue
        digest, filename = fields[0], fields[1].lstrip("*")
        if re.fullmatch(r"[0-9a-f]{64}", digest):
            digests[filename] = digest
    return digests


def fetch_sha256_sums(source_repo: str, version: str) -> dict[str, str]:
    url = (
        f"https://github.com/{source_repo}/releases/download/v{version}/"
        f"SHA256SUMS-v{version}-{ARCH_LABEL}.txt"
    )
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            body = response.read().decode("utf-8")
    except Exception as exc:
        raise SystemExit(f"error: failed to fetch sha256 sums: {url}: {exc}") from exc
    return parse_sha256_sums(body)


def caveats_for(spec: CaskSpec) -> str:
    app_path = f"/Applications/{spec.zip_app_name}"
    return (
        "  caveats <<~EOS\n"
        "    This app is unsigned and not notarized. If macOS blocks launch after install, remove quarantine manually:\n"
        "\n"
        f"      xattr -dr com.apple.quarantine \"{app_path}\"\n"
        f"      open \"{app_path}\"\n"
        f"{spec.caveat_extra}"
        "  EOS\n"
    )


def zap_for(spec: CaskSpec) -> str:
    identifier = "com.sympoies.symphony-board"
    if spec.token.endswith("-standalone"):
        identifier = f"{identifier}.standalone"

    return f'''  zap trash: [
    "~/Library/Application Support/{identifier}",
    "~/Library/Preferences/{identifier}.plist",
    "~/Library/Saved Application State/{identifier}.savedState",
  ]
'''


def render_cask(source_repo: str, version: str, spec: CaskSpec, digest: str) -> str:
    asset_name = spec.asset_name(version)
    return f'''# frozen_string_literal: true

cask "{spec.token}" do
  version "{version}"
  sha256 "{digest}"

  url "https://github.com/{source_repo}/releases/download/v#{{version}}/{asset_name.replace(version, "#{version}")}"
  name "{spec.app_name}"
  desc "{spec.desc}"
  homepage "https://github.com/{source_repo}"

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "{spec.zip_app_name}"

{zap_for(spec)}
{caveats_for(spec)}end
'''


def write_casks(cask_dir: Path, source_repo: str, version: str, sha_by_asset: dict[str, str]) -> list[Path]:
    changed: list[Path] = []
    cask_dir.mkdir(parents=True, exist_ok=True)

    for spec in CASKS:
        asset_name = spec.asset_name(version)
        digest = sha_by_asset.get(asset_name)
        if digest is None:
            raise SystemExit(f"error: missing sha256 for {asset_name}")

        path = cask_dir / spec.filename
        new_text = render_cask(source_repo, version, spec, digest)
        current = path.read_text("utf-8") if path.exists() else ""
        if current != new_text:
            path.write_text(new_text, "utf-8")
            changed.append(path)

    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description="Create or update Symphony Board Homebrew casks.")
    parser.add_argument("--cask-dir", default="Casks")
    parser.add_argument("--source-repo", default="sympoies/symphony-board")
    parser.add_argument("--version", required=True)
    parser.add_argument(
        "--sha256-sums",
        help="Read a local SHA256SUMS-vX.Y.Z-macos-arm64.txt file instead of fetching from GitHub.",
    )
    args = parser.parse_args()

    cask_dir = Path(args.cask_dir)
    source_repo = validate_source_repo(args.source_repo)
    version = normalize_version(args.version)

    if args.sha256_sums:
        sha_by_asset = parse_sha256_sums(Path(args.sha256_sums).read_text("utf-8"))
    else:
        sha_by_asset = fetch_sha256_sums(source_repo, version)

    changed = write_casks(cask_dir, source_repo, version, sha_by_asset)
    state = "updated" if changed else "already-current"
    paths = ", ".join(str(path) for path in changed) if changed else str(cask_dir)
    print(f"{state}: {paths} -> {source_repo} v{version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
