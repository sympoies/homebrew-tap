# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.4.0/nils-alfred-cli-v1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "c8f4494ea5f8d73ed5aee460445e98f2f342be81a0aa74ae0f7cc91d48c474c4"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.4.0/nils-alfred-cli-v1.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "6830ac1e0672bb6db66fad7a3de8114d87f340679352fab57f8de06920e30680"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.4.0/nils-alfred-cli-v1.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "befdccf39f03dd5a036860d8ad7d5fe0bdf5a06d609b30503d5d65742b29b806"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.4.0/nils-alfred-cli-v1.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60bdf39f0fffb8b5d197f88332a55f61014bfdb062e99aa0bff3080879b13e40"
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
    system "#{bin}/weather-cli", "--help"
    system "#{bin}/workflow-readme-cli", "--help"
    system "#{bin}/randomer-cli", "--help"
  end
end
