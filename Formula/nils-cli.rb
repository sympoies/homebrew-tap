class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.1/nils-cli-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "d5b70c78ba4c45702bd687cf7dfeff957a6d68daaa83be90a0b2bc11122833e3"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.1/nils-cli-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "fd01fa4282cca2a868e2eecc337dbf2ca35598632fd46bb92c9f501e26e98dd8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.1/nils-cli-v0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "785da0a2d8bd0d6276d8f59c4c34888d4c0a51b82c4af91ddbced1099ba7ceb1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.1/nils-cli-v0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ed97f747e4da96fdbd9f1449a182b9cbc40e41687add34fbe6ecfa57c39b13ff"
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
