class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.6/nils-cli-v0.7.6-aarch64-apple-darwin.tar.gz"
      sha256 "42fe05864211e05ebdbce966e340cc4c496551183a25ed76cab6f9e3c68f36db"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.6/nils-cli-v0.7.6-x86_64-apple-darwin.tar.gz"
      sha256 "ae68ae2a7d9c1fba2b047d8036da53cb2e97e3cddf0ca33bd3e4b6cb99e6f2d4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.6/nils-cli-v0.7.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7ff06aa7ca5c0351f0ae3bdbbf2fc88978d5583f60fb22538409d7084ed1777e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.6/nils-cli-v0.7.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f7465b0acaf2f8c4923374de0b1ef4e6eb4423b5aa41875dc07f6bd54d81f3ee"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]

    bash_files = Dir["completions/bash/*"]
    bash_completion_files = bash_files.reject { |f| File.basename(f) == "aliases.bash" }
    bash_completion.install bash_completion_files if bash_completion_files.any?

    bash_aliases = bash_files.find { |f| File.basename(f) == "aliases.bash" }
    pkgshare.install bash_aliases => "aliases.bash" if bash_aliases
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
    end
  end
end
