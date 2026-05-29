class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.5/nils-cli-v0.28.5-aarch64-apple-darwin.tar.gz"
      sha256 "190e7994190107e0a1e611428635fb132b108fe4e4611a4fd11002f5c0b2921b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.5/nils-cli-v0.28.5-x86_64-apple-darwin.tar.gz"
      sha256 "b3f47ab8a3c2e6b6937ac63f8fa92221a7046802432268dc59525b1576bdc6db"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.5/nils-cli-v0.28.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca78ddca6725aaf3e06a4e8e9b33de39741826e1ff4dbd3db3c4ba933a294495"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.5/nils-cli-v0.28.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bdcf3969ddb1b41366b9fdcc00a0a5e3ffed1fefed8433a115486fe55ab52e64"
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
