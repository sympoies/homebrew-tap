# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.2/nils-alfred-cli-v1.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "709cffd943978961a3552b3a0021218a362e046d57b46970516152b2b9bebf17"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.2/nils-alfred-cli-v1.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "ad6994d8b64f8bdf9627bb72970ff7bff58e7dbbe7e010f39f8580a3212c80a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.2/nils-alfred-cli-v1.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3805b6d3f9cded6941ee1d7d828a68576fe98cee9622db0ff700bcbcc09e9196"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.2/nils-alfred-cli-v1.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89bda6ff886e5fab8ed93e6ea40319d1cb7ebd1778439f5c9acf50ac9ec4899f"
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
