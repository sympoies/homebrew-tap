class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.1/nils-cli-v0.29.1-aarch64-apple-darwin.tar.gz"
      sha256 "6c50dbf7fc6c868f494cb7d2ddc9ca2d0c56dde6cf85b70313b895a294d2dae9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.1/nils-cli-v0.29.1-x86_64-apple-darwin.tar.gz"
      sha256 "d74afd591d0a0c556a603c1896353be403df72e9770ff760300bedd191ebed2e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.1/nils-cli-v0.29.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eba95e6ce2e4c6ad2dd09ae7f9b3a14a9f3d8dccaabcb25d8614762aceee570e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.1/nils-cli-v0.29.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7bfdd6cee2d20bf59cab5ccd88d5f74fd945dad6e3f352b157e15cfa19dda708"
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
