# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.3.4/nils-alfred-cli-v1.3.4-aarch64-apple-darwin.tar.gz"
      sha256 "e192e80ac515695fe0d1dd8041d74d603989a5c9092d482701014e0c24f9b90d"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.3.4/nils-alfred-cli-v1.3.4-x86_64-apple-darwin.tar.gz"
      sha256 "468126ed3570853510cff1f8086db22c596885fb5d43186bb16f3526746df5a1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.3.4/nils-alfred-cli-v1.3.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eeb5e2d096c7914d9264d98eac37ddc73efe5145e9bc2e5dc510612083d61301"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.3.4/nils-alfred-cli-v1.3.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47855eb455fed3a902d842e2db3004c78158aba46b09408e89fa82ee18b21bd6"
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
