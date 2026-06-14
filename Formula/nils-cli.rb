class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.4.0/nils-cli-v1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "1d919fdb7be3bd160c37d8c5d8f888df440931cab182d87bebcd611b2823961a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.4.0/nils-cli-v1.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "255b85466f0210598161cf63419c69cdb83a5d8a795542a9885815b004ba603b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.4.0/nils-cli-v1.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8186dd6178d5aaeceacc7cf8f1ef428ca299440568fec1991cbfe8910b8c9bf0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.4.0/nils-cli-v1.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "395ec0917f65c2dc1bc1a547ed10e6134dc1a8958b92c1ea0ea56ee65decd184"
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
