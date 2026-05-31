class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.4/nils-cli-v0.31.4-aarch64-apple-darwin.tar.gz"
      sha256 "f9d11d8a2b831ec56f33ba4a7ff363d5c00624a139367379af44d2e3d2df18ed"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.4/nils-cli-v0.31.4-x86_64-apple-darwin.tar.gz"
      sha256 "a399ea0d56ec5f0f49a1812094a63bbdcbcf1934384f30ec5c91a6f78cd36cb0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.4/nils-cli-v0.31.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3848dcd0fb03234ecc883e9bfde4b8317ea3e9770a25a0f658cde8565acd9ea8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.4/nils-cli-v0.31.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe44011a21c978cf716137486f16aa66ed901972d35deb35ba3c1702db1fae66"
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
