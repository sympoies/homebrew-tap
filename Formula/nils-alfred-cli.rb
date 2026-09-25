# frozen_string_literal: true

# Standalone CLI bundle from nils-alfredworkflow.
class NilsAlfredCli < Formula
  desc "Standalone CLI bundle from nils-alfredworkflow"
  homepage "https://github.com/sympoies/nils-alfredworkflow"
  license "CC0-1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.3/nils-alfred-cli-v1.7.3-aarch64-apple-darwin.tar.gz"
      sha256 "6bede6a475b6b9660f86facd22caf9f35a41d7727658d9c07852afcba84aa8a6"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.3/nils-alfred-cli-v1.7.3-x86_64-apple-darwin.tar.gz"
      sha256 "6edca99e47ce4ddeffd8b538bfc04cbb38900c748358a58439796d89d496c614"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.3/nils-alfred-cli-v1.7.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4425fa89d7a874da076bfd54b709b228c8aefe57f5507d5cfe7d6836b47fc12"
    else
      url "https://github.com/sympoies/nils-alfredworkflow/releases/download/v1.7.3/nils-alfred-cli-v1.7.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f348204b0be8904947b10f10df40c42de0fb735aa9f236b2455e8aa793618ed1"
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
