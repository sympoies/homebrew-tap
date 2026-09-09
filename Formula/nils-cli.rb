class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.13/nils-cli-v1.28.13-aarch64-apple-darwin.tar.gz"
      sha256 "73caaeb1118e3b856d795487bf527a41a83516220cca80fe66abfe2aef697baf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.13/nils-cli-v1.28.13-x86_64-apple-darwin.tar.gz"
      sha256 "fd58824f0b1217912936955ccafb212c843b736589875ac0dc77d164914a9753"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.13/nils-cli-v1.28.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "687b9b70912bc5619852b3d5f59e6aa39b8aee46d967a0e33bbb44b066946cb7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.13/nils-cli-v1.28.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6b9bdfb18cdc6b25ef128e3ccd8c69c51794296ee51fe4e7cc2c0f02585c0b31"
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
