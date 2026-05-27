class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.0/nils-cli-v0.25.0-aarch64-apple-darwin.tar.gz"
      sha256 "a2c55e35f1f979b96285d2c3cfa221d179984f831c9a31ed7f6e223cbbd326a0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.0/nils-cli-v0.25.0-x86_64-apple-darwin.tar.gz"
      sha256 "d3efd6b495afaa0355a18bcb658f8333a9104c840b210aa74feef974c4b8e523"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.0/nils-cli-v0.25.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b9c58f3ba5a8c930e6ad6b39e3a59393d6fde27b83a6200b4991225124375924"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.0/nils-cli-v0.25.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dc996ed64f1530d91d5074270387f0b092197142b45c9fa68d4ace334abaa40a"
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
