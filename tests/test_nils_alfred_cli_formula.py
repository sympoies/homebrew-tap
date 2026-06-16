from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load_formula_updater():
    script = ROOT / "scripts" / "update-nils-alfred-cli-formula.py"
    spec = importlib.util.spec_from_file_location("update_nils_alfred_cli_formula", script)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"failed to load {script}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class NilsAlfredCliFormulaTests(unittest.TestCase):
    def test_generated_formula_uses_ruby_bin_interpolation(self) -> None:
        module = load_formula_updater()
        digest = "a" * 64
        sha_by_target = {target: digest for target in module.TARGETS}

        formula = module.render_formula(
            "sympoies/nils-alfredworkflow",
            "nils-alfred-cli",
            "1.2.3",
            sha_by_target,
        )

        self.assertIn('system "#{bin}/weather-cli", "--help"', formula)
        self.assertIn('system "#{bin}/workflow-readme-cli", "--help"', formula)
        self.assertIn('system "#{bin}/memo-workflow-cli", "--help"', formula)
        self.assertNotIn('"{bin}/weather-cli"', formula)

    def test_generated_formula_declares_upstream_license(self) -> None:
        module = load_formula_updater()
        digest = "b" * 64
        sha_by_target = {target: digest for target in module.TARGETS}

        formula = module.render_formula(
            "sympoies/nils-alfredworkflow",
            "nils-alfred-cli",
            "1.2.3",
            sha_by_target,
        )

        self.assertIn('license "CC0-1.0"', formula)
        self.assertNotIn('license any_of: ["MIT", "Apache-2.0"]', formula)

    def test_workflow_noop_update_outputs_branch_commit_sha(self) -> None:
        workflow = (ROOT / ".github" / "workflows" / "update-nils-alfred-cli-formula.yml").read_text(
            encoding="utf-8"
        )

        self.assertNotIn("core.setOutput('commit_sha', data.sha);", workflow)
        self.assertIn("github.rest.git.getRef", workflow)
        self.assertIn("ref: `heads/${branch}`", workflow)
        self.assertIn("headRef.data.object.sha", workflow)

    def test_readme_uses_trust_free_install_command(self) -> None:
        readme = (ROOT / "README.md").read_text(encoding="utf-8")
        section = readme.split("## nils-alfred-cli", 1)[1].split("## Install (script)", 1)[0]

        self.assertIn("brew tap sympoies/tap", section)
        self.assertIn("brew install sympoies/tap/nils-alfred-cli", section)
        self.assertNotIn("brew install nils-alfred-cli", section)


if __name__ == "__main__":
    unittest.main()
