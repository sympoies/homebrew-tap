class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.2/nils-cli-v0.25.2-aarch64-apple-darwin.tar.gz"
      sha256 "f7959b141321942db13586d53156083822c64734f8821e48cfb05d347a476abb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.2/nils-cli-v0.25.2-x86_64-apple-darwin.tar.gz"
      sha256 "2f0874b620810dfdd229d34c70599e192fa396a8ed8a7ae8df6e4ec50cffe751"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.2/nils-cli-v0.25.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9796e1972bebe95dd88966e880351bfb4d7698238f9a07c80012a362f599c07d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.2/nils-cli-v0.25.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "be4045965075b18393a2e8e4c4cab635e6aa152eb39e527c909c758cf64bf664"
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
