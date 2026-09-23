# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.1/nils-alfred-cli-v1.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "b287f54e9f33539f8a2282bf79591cc2e434ee4ca565f5440507acbd923c3f66"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.1/nils-alfred-cli-v1.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "53ce2e727488df13010a0d48c9b5b8694014cd066c5feda0df61bbed8ef88a01"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.1/nils-alfred-cli-v1.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "192e33a2ec19fcaee973abeb197a022f8e9d3e3fff5696a5d97d9b7496900936"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.1/nils-alfred-cli-v1.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af7394bce0d5b3f160321772a618af1c8b0f5e3ea82a319ccdf713fd97f2982c"
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
