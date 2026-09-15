class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.30/nils-cli-v1.28.30-aarch64-apple-darwin.tar.gz"
      sha256 "54d6e75378cbbcae625ced34dc1e48f2568def75e07cb1e302c6053ef7c8fbfa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.30/nils-cli-v1.28.30-x86_64-apple-darwin.tar.gz"
      sha256 "e6e6b94c3335dd86eae96eb0af0135fec1d41779da1800a544c022be3eb143ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.30/nils-cli-v1.28.30-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b31827b822d4c3e148d45c895fe509b95ac1349da933154d2427a919f34ef2f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.30/nils-cli-v1.28.30-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47b240c0bda266d0e9687ebc7ea76cc8138152e41d5280d4b2bc1347ab1813a5"
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
