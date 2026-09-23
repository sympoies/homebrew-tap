# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.0/nils-alfred-cli-v1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "0a009e38947e927e9f832921597555accb1514999992b37f5eea0d0cb5819082"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.0/nils-alfred-cli-v1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "4d752c8a238a301632cf07e72ced4d5ab73782f884ffdabc20001df0ae8ea9ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.0/nils-alfred-cli-v1.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97c20df7767d06696a643b7af49ff96b5316155366f5e99013bfe5f53c062be0"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.6.0/nils-alfred-cli-v1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "697edde43d90c2132087bdd80dd6d84a28b44a7dc3e37ef1ead349a59d6268bf"
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
