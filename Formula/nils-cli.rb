class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.4/nils-cli-v1.29.4-aarch64-apple-darwin.tar.gz"
      sha256 "165fc1883450dc3ff297f473815c0693681cdb5587cc45090078e219d1a2dda5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.4/nils-cli-v1.29.4-x86_64-apple-darwin.tar.gz"
      sha256 "55e2350a269d0a52547d97221d9d611044bc0ca20f6ad2579c493d4a6b071f23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.4/nils-cli-v1.29.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f635f0fb7ca5892c5facfa69a02f595ad4badb1fc3a0476c53752db4a4219ce"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.4/nils-cli-v1.29.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7508b7a04ca0563cbb4b05f592d08fe1f192a1b1216eaf1a7da4c3da1dacb1a0"
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
