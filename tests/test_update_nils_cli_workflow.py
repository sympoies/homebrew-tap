import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
WORKFLOW = ROOT / ".github/workflows/update-nils-cli-formula.yml"


class NilsCliRecoveryWorkflowTests(unittest.TestCase):
    def test_manual_recovery_fails_before_checkout_when_revision_drifts(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("expected_workflow_sha:", workflow)
        guard = workflow.index("- name: Verify recovery workflow revision")
        checkout = workflow.index("- name: Checkout")
        self.assertLess(guard, checkout)
        self.assertIn("EXPECTED_WORKFLOW_SHA: ${{ inputs.expected_workflow_sha }}", workflow)
        self.assertIn('[[ "${EXPECTED_WORKFLOW_SHA}" =~ ^[0-9a-f]{40}$ ]]', workflow)
        self.assertIn('[[ "${GITHUB_SHA}" == "${EXPECTED_WORKFLOW_SHA}" ]]', workflow)

    def test_noop_formula_path_outputs_a_commit_sha_not_the_blob_sha(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn("github.rest.repos.getCommit({", workflow)
        self.assertIn("const branchHead = branchCommit.sha;", workflow)
        self.assertIn("ref: branchHead,", workflow)
        self.assertIn("core.setOutput('commit_sha', branchHead);", workflow)
        self.assertNotIn("core.setOutput('commit_sha', data.sha);", workflow)


if __name__ == "__main__":
    unittest.main()
