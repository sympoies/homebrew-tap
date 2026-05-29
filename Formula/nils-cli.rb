class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.4/nils-cli-v0.28.4-aarch64-apple-darwin.tar.gz"
      sha256 "d8b6a09739d1dd18303974901709c0baa104365ede0ffb168a6d29180a60640b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.4/nils-cli-v0.28.4-x86_64-apple-darwin.tar.gz"
      sha256 "8aea9d1e3401d37efa5745a581d3a73bcf4f032b966bd4eb30bb6e843e54db22"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.4/nils-cli-v0.28.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1808df2e79eaed7e3ac4404c317050ef915f27ff7fc87de402ecb0b3196b9503"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.4/nils-cli-v0.28.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b20772c1fdbffacff4043f5366274d5607b89d2e55630cd8734fb8a932b6d219"
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
