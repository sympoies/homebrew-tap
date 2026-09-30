class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.4/nils-cli-v1.31.4-aarch64-apple-darwin.tar.gz"
      sha256 "6dfa0ae5bca76d85a59d8d2466642cda937cc9ecc4de3bc564cfebf3a2c7a798"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.4/nils-cli-v1.31.4-x86_64-apple-darwin.tar.gz"
      sha256 "1bb2e4cc94b8caa8339c2fb529c49d5c0f7d4ac82ff1eb214cdc6dea67fab9e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.4/nils-cli-v1.31.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b37ab1a91de350a81345ebe98b3e71b53f677dc95b90db00968bd3edad52936f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.4/nils-cli-v1.31.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab5379b4c321cde5a6a1b149c3fc9d678e3867580962cb7ad8600bfb170dca9f"
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
