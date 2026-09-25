# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.2/nils-alfred-cli-v1.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "e6ce97b2b6943a97a4609ed71d8b12d05f277d3094d0fa37e5fcc97bd58a584e"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.2/nils-alfred-cli-v1.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "c8e55d29d606307aa0b1c14cb16fa4d2a44e411089e6deefe553c9cf995e210e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.2/nils-alfred-cli-v1.7.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fd7e3c01a6a5544a175b08d857aab955816596cc14d6dc615926d0f01e06aeae"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.2/nils-alfred-cli-v1.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d01e2107e8f834e69638df5625b9f5fc5a0cf83104667ea7acb14298c4804e2"
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
