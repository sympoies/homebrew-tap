class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.18/nils-cli-v1.20.18-aarch64-apple-darwin.tar.gz"
      sha256 "f408c08431fba5ecf518c0b793a53059b643bdc0205739a9a2dba9f224c16c26"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.18/nils-cli-v1.20.18-x86_64-apple-darwin.tar.gz"
      sha256 "8c624d63b60e1aa4336f1b256e63d279cbbe87e69d5fa79ebf979ba4792fbad6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.18/nils-cli-v1.20.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b583a24bb01116d4834723a80995f30b8c64323990d06a408b1a968383c60244"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.18/nils-cli-v1.20.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1261f82f4c776d562fe03d15749cf3c996f62eb1546748e26a8b7e09f36b2ddf"
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
      ENV["AGENT_RUN_FORMULA_TEST"] = nil
      (testpath/".env").write("AGENT_RUN_FORMULA_TEST=ok\n")
      system "#{bin}/agent-run", "exec", "--cwd", testpath, "--", "sh", "-c",
             "test \"$AGENT_RUN_FORMULA_TEST\" = ok"
    end
  end
end
