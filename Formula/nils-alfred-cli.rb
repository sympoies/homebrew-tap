# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.5.0/nils-alfred-cli-v1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "abc1be27382073eee7117cefedbf59004962170b2d5a6b417c24a5f26223a348"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.5.0/nils-alfred-cli-v1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "52138547e7dc5250014d1d40b0da6d5f4f3b3076e8f00ee8991121c94b2e3172"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.5.0/nils-alfred-cli-v1.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "726c554495c3f38048993d5c503e8b4126de7e3fa7a7b28a9043fcfa16c489f4"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.5.0/nils-alfred-cli-v1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b17e0f3cfbcbf2ab271d22e516161e4de0102c0f1991b719e1e17f282b694a84"
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
