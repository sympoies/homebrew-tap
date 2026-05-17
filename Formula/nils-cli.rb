class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.6/nils-cli-v0.8.6-aarch64-apple-darwin.tar.gz"
      sha256 "861e12e3da0e1b1e325cdabe59ae106398df28b15261f8c84d9502613dda3e6b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.6/nils-cli-v0.8.6-x86_64-apple-darwin.tar.gz"
      sha256 "ac10a7ededec146ee4c7e4493a0f90b143930eb2e340b736e018746f741e04de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.6/nils-cli-v0.8.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f619b487ac0ec413997577ad4ede3cbb7795f1357e43d9b313fa7d49a646b634"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.6/nils-cli-v0.8.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2800065d3c94ae0c2ea685a29eb2f0eb6a14f1789092d23167f33e35f3ad208d"
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
