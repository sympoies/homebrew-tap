class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.7/nils-cli-v0.8.7-aarch64-apple-darwin.tar.gz"
      sha256 "15ea0952ea171a32112b73d3471ff64f101298d898e6e5888b23f6ad511f9426"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.7/nils-cli-v0.8.7-x86_64-apple-darwin.tar.gz"
      sha256 "fc5594ce05fec453fc7fc4f137c6c5c6781bdeacb77e0108900c1e7310a29513"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.7/nils-cli-v0.8.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f3f36abf67775fbe8c28ddb7259dfc57530f487f79ac8d277adefc9179e7600"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.7/nils-cli-v0.8.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d05619245157ca4b8061de13f05a14e15f18bc5c145ed56fc87c251cb6990f25"
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
