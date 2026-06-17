class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.3/nils-cli-v1.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "d1805ef50ce0951ed4c0edbb353a6b85b1e6cd3b23b5396dc58d986cad7eceff"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.3/nils-cli-v1.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "12026c23304453ecef166278999ec64db3e791ac4cbe35a890ad23adcd0a5757"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.3/nils-cli-v1.9.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72ed28fd371256caa8b48dff1c15fdb54a7f392d50e9f218cf290e2a09660616"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.3/nils-cli-v1.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c9b787764812c7647e8b3fe8b7bb7527ef5425273c4f6e7f04534700fd71a9d5"
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
