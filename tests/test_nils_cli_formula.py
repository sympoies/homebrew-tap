from __future__ import annotations

import importlib.util
import io
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "update_nils_cli_formula", ROOT / "scripts/update-nils-cli-formula.py"
)
UPDATER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(UPDATER)
SUPPORTED = {
    "aarch64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
}


class NilsCliFormulaTests(unittest.TestCase):
    def test_updates_from_old_and_new_release_asset_sets_without_intel_fetch(self):
        for legacy in (False, True):
            with self.subTest(legacy=legacy), tempfile.TemporaryDirectory() as tmp:
                formula = Path(tmp) / "nils-cli.rb"
                formula.write_text((ROOT / "Formula/nils-cli.rb").read_text())
                assets = {target: "a" * 64 for target in SUPPORTED}
                if legacy:
                    assets["x86_64-apple-darwin"] = "b" * 64
                requested = []

                def fetch(repo, package, version, target):
                    requested.append(target)
                    return assets[target]

                args = ["update-formula", "--formula", str(formula), "--version", "1.2.3"]
                with patch.object(sys, "argv", args), patch.object(
                    UPDATER, "fetch_sha256", side_effect=fetch
                ), patch("sys.stdout", new_callable=io.StringIO):
                    self.assertEqual(UPDATER.main(), 0)
                text = formula.read_text()
                self.assertEqual(set(requested), SUPPORTED)
                self.assertEqual(len(requested), 3)
                self.assertNotIn("x86_64-apple-darwin", text)
                self.assertEqual(text.count("/releases/download/v1.2.3/"), 3)
                self.assertIn("  on_macos do\n    if Hardware::CPU.arm?", text)
                self.assertIn("  on_linux do", text)
                self.assertFalse(UPDATER.update_formula(
                    formula, "sympoies/nils-cli", "nils-cli", "1.2.3",
                    {target: "a" * 64 for target in SUPPORTED},
                ))

    def test_missing_supported_target_still_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            formula = Path(tmp) / "nils-cli.rb"
            text = (ROOT / "Formula/nils-cli.rb").read_text()
            text = text.replace("aarch64-unknown-linux-gnu", "unsupported-target")
            formula.write_text(text)
            with self.assertRaises(SystemExit):
                UPDATER.update_formula(formula, "sympoies/nils-cli", "nils-cli", "1.2.3",
                                       {target: "a" * 64 for target in SUPPORTED})
            self.assertEqual(formula.read_text(), text)


if __name__ == "__main__":
    unittest.main()
