class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.1/nils-cli-v0.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "55e8ca46224ab82c3957251eb84fa47491a4e27c354e2bc9b2bf872d5be52892"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.1/nils-cli-v0.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "e31cd1d64301b11c2bc0b969826fef72f0a18c440fa10ff65961d1954ae7509f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.1/nils-cli-v0.20.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bd656932fa49bd76e55c628ff356617db7e042d5d00a1af0389fd0e55d18ee3"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.1/nils-cli-v0.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4753345a9ab0f91daaa62aa5af66cf5a91f8b7bd33e63c98e5b5126e73b24271"
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
